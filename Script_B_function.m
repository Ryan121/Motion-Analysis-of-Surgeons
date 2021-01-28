% A function to calculate joint/segment posture in reference to the calibration
% postures and to work out the LUBA classifcations of each segment
% individually and collectively

function [calib_array, Results] = Script_B_function(DIR, ARRAY, con, ...
    CROPstart_ARRAY, CROPend_ARRAY, calib_array, Fs)

    % Iterate through all files 
    for global_count = 1:length(ARRAY)
        %% Load and prepare files
        % Load file into workspace from the directory DIR
        load(strcat(DIR,ARRAY(global_count),".mat"));  
        
        % Convert string expression into numerical array output
        hold = eval(ARRAY(global_count));
        
        % Check if trial data function call
        if con == 0
            % Store in variable object of the same name
            hold = hold(CROPstart_ARRAY(global_count):CROPend_ARRAY(global_count),1:end);
            
            % Calculate the amount of time required to complete the task
            time = (CROPend_ARRAY(global_count) - CROPstart_ARRAY(global_count))/Fs;
            
        end

        %% Eular angle calculations - Quaternion partitioning
        % The following array locations within the .calc file are defined 
        % within the Perception Neuron / Axis Neuron userguide documentation   
        
        % In general, different rotation orders were used for individual 
        % body segments to avoid the incidence of gimbal lock within the 
        % angular kinematics
        
        % Partition head and neck sensor quaternion outputs
        neckQUATS = hold(:,263:266);
        headQUATS = hold(:,247:250);

        % Torso sensor quaternion outputs
        %spine3_QUATS = hold(:,279:282);  
        spine2_QUATS = hold(:,295:298);                            
        spine1_QUATS = hold(:,311:314);
        spine_QUATS = hold(:,327:330);
        hips_QUATS = hold(:,7:10);

        % Left extremity sensor quaternion outputs
        l_Shoulder_quats = hold(:,183:186);
        l_Upperarm_QUATS = hold(:,199:202);
        l_Elbow_QUATS = hold(:,215:218);
        l_Wrist_QUATS = hold(:,231:234);

        % Right extremity sensor quaternion outputs
        r_Shoulder_quats = hold(:,119:122);
        r_Upperarm_QUATS = hold(:,135:138);
        r_Elbow_QUATS = hold(:,151:154);
        r_Wrist_QUATS = hold(:,167:170);

        %% Head and neck    
        % Combine outputs
        c_out = quatmultiply(neckQUATS(:,1:4), headQUATS(:,1:4));     
        % Convert to angles
        [a,b,c] = quat2angle(c_out,'ZXY');   
        % Convert to degrees
        NECKangles = ((180/pi)*[a , b , c]);
        clear a b c c_out
        
        %% Shoulders / Upper arms
        % Combine outputs
        c_out = quatmultiply(l_Shoulder_quats(:,1:4),l_Upperarm_QUATS(:,1:4)); 
        
        % For applications were the shoulders are not very dyanmic using just l_Upperarm_QUATS(:,1:4) to 
        % evaluate shoulder motion is feasible due to small activation of l_Shoulder_quats(:,1:4)

        % Convert to angles and degrees
        % A different rotation order was used to avoid aignal distortion 
        % due to gimbal lock. The first angle was taken and the rotation 
        % order was changed in order to take the primary axis of rotation 
        % of the other planes of motion  
        [a,b,c] = quat2angle(c_out,'ZYX');  
        % Left Shoulder Adduction/Abductionn (Z)
        L_AA_angles = ((180/pi)*[a , b , c]);
        clear a b c c_out
        
        % Combine outputs and convert to angles and degrees
        c_out = quatmultiply(r_Shoulder_quats(:,1:4),r_Upperarm_QUATS(:,1:4));  
        [a,b,c] = quat2angle(c_out,'ZYX');
        % Right Shoulder Adduction/Abduction (Z)
        R_AA_angles  = ((180/pi)*[a , b , c]);
        clear a b c c_out
        
        c_out = quatmultiply(l_Shoulder_quats(:,1:4),l_Upperarm_QUATS(:,1:4));  
        [a,b,c] = quat2angle(c_out,'YXZ');
        % Left Shoulder internal/external rotation (Y)
        L_IER_angles = ((180/pi)*[a , b , c]);
        clear a b c c_out
        
        c_out = quatmultiply(r_Shoulder_quats(:,1:4),r_Upperarm_QUATS(:,1:4));  
        [a,b,c] = quat2angle(c_out,'YXZ');
        % Right Shoulder internal/external rotation (Y)
        R_IER_angles  = ((180/pi)*[a , b , c]);
        clear a b c c_out
        
        
        c_out = quatmultiply(l_Shoulder_quats(:,1:4),l_Upperarm_QUATS(:,1:4));  
        [a,b,c] = quat2angle(c_out,'XYZ');
        % Left Shoulder flexion/extension (X)
        L_FE_angles = ((180/pi)*[a , b , c]);
        clear a b c c_out
        
        c_out = quatmultiply(r_Shoulder_quats(:,1:4),r_Upperarm_QUATS(:,1:4));  
        [a,b,c] = quat2angle(c_out,'XYZ');
        % Right Shoulder flexion/extension (X)
        R_FE_angles  = ((180/pi)*[a , b , c]);
        clear a b c c_out

        %% Forearms & Hands
        % Forearms are converted straight to angles as there is no need to
        % combine neurons 
        [a,b,c] = quat2angle(l_Elbow_QUATS,'YZX');
        L_Elbow_angles = ((180/pi)*[a , b , c]);
        clear a b c c_out
        [a,b,c] = quat2angle(r_Elbow_QUATS,'YZX');
        R_Elbow_angles = ((180/pi)*[a , b , c]);
        clear a b c c_out

        % Hands are converted straight to angles as there is no need to
        % combine neurons 
        [a,b,c] = quat2angle(l_Wrist_QUATS,'YZX');
        L_Wrist_angles = ((180/pi)*[a , b , c]);
        clear a b c c_out
        [a,b,c] = quat2angle(r_Wrist_QUATS,'YZX');
        R_Wrist_angles = ((180/pi)*[a , b , c]);
        clear a b c c_out

        %% Thorax        
        % Combine quaternion outputs down the kinematic chain to calculate
        % the motion and posture of the thorax
        c_out = quatmultiply(spine1_QUATS(:,1:4),spine2_QUATS(:,1:4));
        d_out = quatmultiply(spine_QUATS(:,1:4),c_out);
        e_out = quatmultiply(hips_QUATS(:,1:4),d_out);
        [a,b,c] = quat2angle(e_out,'ZXY');
        THORAXangles = rad2deg([a , b, c]);
        clear a b c c_out d_out e_out
        
        % Repeated the calculation but removed hip global axial rotation
        c_out = quatmultiply(spine1_QUATS(:,1:4),spine2_QUATS(:,1:4));
        d_out = quatmultiply(spine_QUATS(:,1:4),c_out);
        [a,b,c] = quat2angle(d_out,'ZXY');
        ROTTHORAXangles = ((180/pi)*[a , b ,c]);
        clear a b c c_out d_out
                
        % Check if calibration data function call
        if con == 1
            % Set empty int to return
            Results = 0;
            % Combine output calibration array
            calib_array(:,:,global_count) = [median(NECKangles); median(THORAXangles); median(ROTTHORAXangles);...
                [median(L_AA_angles(:,1)), median(L_FE_angles(:,1)), median(L_IER_angles(:,1))];...
                [median(R_AA_angles(:,1)), median(R_FE_angles(:,1)), median(R_IER_angles(:,1))];...
                 median(L_Elbow_angles); median(R_Elbow_angles); median(L_Wrist_angles); median(R_Wrist_angles)];
        else
            
           % Angles are referenced against the suit wearers neutral posture 
           % to remove any systematic biases present at measurement time
           for u = 1:size(hold,1)
           %% Neck calibration 
                % Calculate the axial rotation angle in reference to the average neutral posture 
                NECK_ROT_axis(u,1) = diff([mean(mean(calib_array(1,3,:))) NECKangles(u,3) ]);
                % Calculate the flexion/extension angle in reference to the average neutral posture 
                NECK_FE_axis(u,1) = diff([mean(mean(calib_array(1,2,:))) NECKangles(u,2) ]);
                % Calculate the lateral angle in reference to the average neutral posture 
                NECK_LF_axis(u,1) = diff([mean(mean(calib_array(1,1,:))) NECKangles(u,1) ]);

           %% Left Shoulder calibration
                % Calculate the internal/external rotation angle in reference to the average neutral posture 
                L_UA_IER_axis(u,1) = diff([-mean(mean(abs(calib_array(4:5,3,:)))) L_IER_angles(u,1)]); % Mean value negative due to suits conventions
                % Calculate the flexion/extension angle in reference to the average neutral posture 
                L_UA_FE_axis(u,1) = diff([L_FE_angles(u,1) mean(mean(abs(calib_array(4:5,2,:)))) ]);
                % Calculate the Adduction/Abductionn angle in reference to the average neutral posture 
                L_UA_AA_axis(u,1) = diff([-mean(mean(abs(calib_array(4:5,1,:)))) L_AA_angles(u,1) ]); % Mean value negative due to suits conventions

           %% Right Shoulder calibration   
                % Calculate the internal/external rotation angle in reference to the average neutral posture 
                R_UA_IER_axis(u,1) = diff([R_IER_angles(u,1) mean(mean(abs(calib_array(4:5,3,:))))]); % Mean value non-negative  due to suits conventions
                % Calculate the flexion/extension angle in reference to the average neutral posture 
                R_UA_FE_axis(u,1) = diff([R_FE_angles(u,1) mean(mean(calib_array(4:5,2,:))) ]);
                % Calculate the Adduction/Abductionn angle in reference to the average neutral posture 
                R_UA_AA_axis(u,1) = diff([R_AA_angles(u,1) mean(mean(abs(calib_array(4:5,1,:))))]);

           %% Thorax calibration 
                % Calculate the axial rotation angle in reference to the average neutral posture 
                THORAX_ROT_axis(u,1) = diff([mean(mean(calib_array(3,3,:))) ROTTHORAXangles(u,3)]);
                % Calculate the flexion/extension angle in reference to the average neutral posture     
                THORAX_FE_axis(u,1) = diff([mean(mean(calib_array(2,1,:))) THORAXangles(u,1) ]);
                % Calculate the lateral flexion angle in reference to the average neutral posture 
                THORAX_LF_axis(u,1) = diff([mean(mean(calib_array(2,2,:))) THORAXangles(u,2) ]);
                
           %% Left Forearm calibration 
                % Calculate the Pronation / Supination angle in reference to the average neutral posture       
                L_Forerarm_PS_axis(u,1) = diff([mean(mean(calib_array(6:7,3,:))) L_Elbow_angles(u,3) ]);
                % Calculate the Flexion / Extension  angle in reference to the average neutral posture  
                L_Forerarm_FE_axis(u,1) = diff([mean(mean(calib_array(6:7,1,:))) L_Elbow_angles(u,1)]);
           
           %% Right Forearm calibration 
                % Calculate the Pronation / Supination angle in reference to the average neutral posture  
                R_Forerarm_PS_axis(u,1) = diff([mean(mean(calib_array(6:7,3,:))) R_Elbow_angles(u,3) ]);
                % Calculate the Flexion / Extension  angle in reference to the average neutral posture 
                R_Forerarm_FE_axis(u,1) = diff([mean(mean(calib_array(6:7,1,:))) R_Elbow_angles(u,1) ]);
        
           %% Left Hand calibration 
                % Calculate the Radial / Ulnar Deviation angle in reference to the average neutral posture
                L_Hand_RUD_axis(u,1) = diff([ L_Wrist_angles(u,1) mean(mean(calib_array(8:9,1,:)))]);
                % Calculate the Flexion / Extension  angle in reference to the average neutral posture  
                L_Hand_FE_axis(u,1) = diff([L_Wrist_angles(u,2) mean(mean(calib_array(8:9,2,:))) ]);
                
           %% Right Hand calibration 
                % Calculate the Radial / Ulnar Deviation angle in reference to the average neutral posture
                R_Hand_RUD_axis(u,1) = diff([mean(mean(calib_array(8:9,1,:))) R_Wrist_angles(u,1) ]);
                % Calculate the Flexion / Extension  angle in reference to the average neutral posture  
                R_Hand_FE_axis(u,1) = diff([mean(mean(calib_array(8:9,2,:))) R_Wrist_angles(u,2) ]);

           end
            
           %% LUBA framework
           % Neck classification
           neckLu = NeckLUBA([abs(NECK_LF_axis), NECK_FE_axis, abs(NECK_ROT_axis)]);
           % Thorax classification
           thoraxLu = ThoraxLUBA([abs(THORAX_LF_axis), THORAX_FE_axis, abs(THORAX_ROT_axis)]);
           % Left Shoulder classification
           lshoulderLu = ShoulderLUBA([L_UA_AA_axis,L_UA_FE_axis, L_UA_IER_axis]);
           % Right Shoulder classification
           rshoulderLu = ShoulderLUBA([R_UA_AA_axis, R_UA_FE_axis, R_UA_IER_axis]);
           % Left Elbow classification
           lelbowLu = ElbowLUBA([L_Forerarm_PS_axis, L_Forerarm_FE_axis]);
           % Right Elbow classification
           relbowLu = ElbowLUBA([R_Forerarm_PS_axis, R_Forerarm_FE_axis]);
           % Left Wrist classification
           lwristLu = WristLUBA([L_Hand_RUD_axis, L_Hand_FE_axis]);
           % Right Wrist classification
           rwristLu = WristLUBA([R_Hand_RUD_axis,  R_Hand_FE_axis]);

           % Compute Total LUBA score combining all segments
           for i = 1:max(size(rwristLu))
                % Sum score for each frame
                TotalLUBA(i,1) = neckLu(i,1) +  thoraxLu(i,1) + lshoulderLu(i,1) +...
                    rshoulderLu(i,1) + lelbowLu(i,1) + relbowLu(i,1) + lwristLu(i,1) +...
                    rwristLu(i,1);     
           end
           
           % Populate Results array with Total score and all individual total
           % segment scores and individual axis of rotation scores
           Results(global_count,:) = [mean(TotalLUBA),mean(neckLu(:,:)),mean(thoraxLu(:,:)),...
               mean(lshoulderLu(:,:)),mean(rshoulderLu(:,:)),mean(lelbowLu(:,:)),...
               mean(relbowLu(:,:)),mean(lwristLu(:,:)),mean(rwristLu(:,:)), time];

           % Display trial number for user reference
           fprintf('Trial number: %d \n', global_count);
          
           % Clear variables
           clearvars -except DIR global_count Results ARRAY CROPstart_ARRAY CROPend_ARRAY calib_array con Fs
           
        end
    end
end