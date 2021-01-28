% This script is to be run after Script A and the subsequent file 
% data has been saved to a location in a local directory. Example
% file data has been provided.

% The file returns an array containing the jerk, angular speed
% and cumulative displacement of all upper body joints/segments 

clear all;clc;close all
%% Filter design
% Axis Neuron sample frequency when setup in >= 18 neuron mode 
Fs = 120;

% Low pass filter design for gyroscope data
d = fdesign.lowpass('Fp,Fst,Ap,Ast',20,20.5,1,80,Fs);
Hd = design(d,'equiripple');

% Band pass filter design for accelerometer data
% Band pass frequency range is between 0.5 and 30 Hz. 
f1 = 0.2; f2=20; 

% Normalized pass frequency ranges (Wn1, Wn2):
Wn1=f1/(0.5*Fs);      
Wn2=f2/(0.5*Fs);     
        
% Fourth order (N=4) filter passes all signal components within           
% a frequency range of: [Wn1 Wn2]
N=4;
        
% Compute second order filter coefficients:
[b, a]    = butter(N, [Wn1, Wn2], 'bandpass'); 
        
%% File Conventions       
% Insert string array for the filenames of the Axis Neuron trial files 
% EXAMPLE string data inserted 
Filename_ARRAY = ["Example_Data_1", "Example_Data_2" , "Example_Data_3" , ...
    "Example_Data_4" , "Example_Data_5" ,"Example_Data_6" ];

% Manually crop the start of the data to remove unwanted data (number
% represents frame number)
CROPstart_ARRAY = [1 1 1 1 1 1]; 

% Manually crop the end of the data to remove unwanted data (number
% represents frame number)
% -- These frame numbers represent compatable values with the example data files --
CROPend_ARRAY = [25000 76000 66000 61000 63000 26000];
    
for global_count = 1: length(Filename_ARRAY)
    
    % Initialise large array
    DATA = zeros(200000,944);
    
    % Load data into the workspace
    load(strcat("/data/",Filename_ARRAY(global_count),".mat")); 
    
    % Convert string expression into numerical array output
    Arrayhold = eval(Filename_ARRAY(global_count)); 
    
    % Store in variable object 
    DATA = Arrayhold(CROPstart_ARRAY(global_count):CROPend_ARRAY(global_count),1:end);

    %% Segment variable array locations - Angular velocity in the .calc file
    % Angular velocities    
    Spine3_X_av = DATA(:,286); Spine3_Y_av = DATA(:,287); Spine3_Z_av = DATA(:,288);
    
    Spine2_X_av = DATA(:,302); Spine2_Y_av = DATA(:,303); Spine2_Z_av = DATA(:,304);
    
    Spine1_X_av = DATA(:,318); Spine1_Y_av = DATA(:,319); Spine1_Z_av = DATA(:,320);
    
    Spine_X_av = DATA(:,334); Spine_Y_av = DATA(:,335); Spine_Z_av = DATA(:,336);
    
    Right_Shoulder_X_av = DATA(:,126); Right_Shoulder_Y_av = DATA(:,127); Right_Shoulder_Z_av = DATA(:,128); 
    
    Right_Arm_X_av = DATA(:,142); Right_Arm_Y_av = DATA(:,143); Right_Arm_Z_av = DATA(:,144); 
    
    Right_Forearm_X_av = DATA(:,158); Right_Forearm_Y_av = DATA(:,159); Right_Forearm_Z_av = DATA(:,160); 
    
    Right_Hand_X_av = DATA(:,174); Right_Hand_Y_av = DATA(:,175); Right_Hand_Z_av = DATA(:,176);
    
    Left_Shoulder_X_av = DATA(:,190); Left_Shoulder_Y_av = DATA(:,191); Left_Shoulder_Z_av = DATA(:,192);
    
    Left_Arm_X_av = DATA(:,206); Left_Arm_Y_av = DATA(:,207); Left_Arm_Z_av = DATA(:,208); 
    
    Left_Forearm_X_av = DATA(:,222); Left_Forearm_Y_av = DATA(:,223); Left_Forearm_Z_av = DATA(:,224); 
    
    Left_Hand_X_av = DATA(:,238); Left_Hand_Y_av = DATA(:,239); Left_Hand_Z_av = DATA(:,240);
    
    Head_X_av = DATA(:,254); Head_Y_av = DATA(:,255); Head_Z_av = DATA(:,256); 
    
    % Upper body angular velocity array 
    AV_array = rad2deg([Right_Shoulder_X_av Right_Shoulder_Y_av Right_Shoulder_Z_av...
        Right_Arm_X_av Right_Arm_Y_av Right_Arm_Z_av Right_Forearm_X_av...
        Right_Forearm_Y_av Right_Forearm_Z_av Right_Hand_X_av Right_Hand_Y_av Right_Hand_Z_av...
        Left_Shoulder_X_av Left_Shoulder_Y_av Left_Shoulder_Z_av Left_Arm_X_av...
        Left_Arm_Y_av Left_Arm_Z_av Left_Forearm_X_av Left_Forearm_Y_av Left_Forearm_Z_av...
        Left_Hand_X_av Left_Hand_Y_av Left_Hand_Z_av Spine3_X_av Spine3_Y_av Spine3_Z_av ...
        Spine_X_av Spine_Y_av Spine_Z_av Head_X_av Head_Y_av Head_Z_av]);
    
     %% Segment variable array locations - Acceleration in the .calc file 
    % Linear Acceleration 
    Spine3_X_acc = DATA(:,283); Spine3_Y_acc = DATA(:,284); Spine3_Z_acc = DATA(:,285);
    
    Spine2_X_acc = DATA(:,299); Spine2_Y_acc = DATA(:,300); Spine2_Z_acc = DATA(:,301);
    
    Spine1_X_acc = DATA(:,315); Spine1_Y_acc = DATA(:,316); Spine1_Z_acc = DATA(:,317);
    
    Spine_X_acc = DATA(:,331); Spine_Y_acc = DATA(:,332); Spine_Z_acc = DATA(:,333);    
    
    Right_Shoulder_X_acc = DATA(:,123); Right_Shoulder_Y_acc = DATA(:,124); Right_Shoulder_Z_acc = DATA(:,125); 
    
    Right_Arm_X_acc = DATA(:,139); Right_Arm_Y_acc = DATA(:,140); Right_Arm_Z_acc = DATA(:,141); 
    
    Right_Forearm_X_acc = DATA(:,155); Right_Forearm_Y_acc = DATA(:,156); Right_Forearm_Z_acc = DATA(:,157); 
    
    Right_Hand_X_acc = DATA(:,171); Right_Hand_Y_acc = DATA(:,172); Right_Hand_Z_acc = DATA(:,173);
    
    Left_Shoulder_X_acc = DATA(:,187); Left_Shoulder_Y_acc = DATA(:,188); Left_Shoulder_Z_acc = DATA(:,189);
    
    Left_Arm_X_acc = DATA(:,203); Left_Arm_Y_acc = DATA(:,204); Left_Arm_Z_acc = DATA(:,205); 
    
    Left_Forearm_X_acc = DATA(:,219); Left_Forearm_Y_acc = DATA(:,220); Left_Forearm_Z_acc = DATA(:,221); 
    
    Left_Hand_X_acc = DATA(:,235); Left_Hand_Y_acc = DATA(:,236); Left_Hand_Z_acc = DATA(:,237);
    
    Head_X_acc = DATA(:,251); Head_Y_acc = DATA(:,252); Head_Z_acc = DATA(:,253); 
   
    % Upper body linear acceleration array 
    ACC_arrays = [Right_Shoulder_X_acc Right_Shoulder_Y_acc Right_Shoulder_Z_acc...
        Right_Arm_X_acc Right_Arm_Y_acc Right_Arm_Z_acc Right_Forearm_X_acc...
        Right_Forearm_Y_acc Right_Forearm_Z_acc Right_Hand_X_acc Right_Hand_Y_acc Right_Hand_Z_acc...
        Left_Shoulder_X_acc Left_Shoulder_Y_acc Left_Shoulder_Z_acc Left_Arm_X_acc...
        Left_Arm_Y_acc Left_Arm_Z_acc Left_Forearm_X_acc Left_Forearm_Y_acc Left_Forearm_Z_acc...
        Left_Hand_X_acc Left_Hand_Y_acc Left_Hand_Z_acc Spine3_X_acc Spine3_Y_acc Spine3_Z_acc...
        Spine_X_acc Spine_Y_acc Spine_Z_acc Head_X_acc Head_Y_acc Head_Z_acc]*9.81;

    %% Filtering 
                       
        % Filter accelerometer data - Remove effect of gravity
        ACC_array  = filter(b, a, ACC_arrays); % Measured signal
        
        % Filter gyroscope data
        AV_array = filter(Hd,AV_array);
        
    %%  Kinematics calculations 
    % Give duration of trial as a vector of time to allow integration using
    % the trapezoidal rule 
    Tstate = 0:1/Fs:(length(ACC_array)/Fs-1/Fs);
   
    % Differentiate Acceleration with respect to time to give jerk 
    Linear_Jerk = abs(diff(ACC_array,1)*Fs); 
      
    % Double time domain integration and Cumulative displacment calculation     
    % Integration of acceleration with respect to time to give velocity 
    for i = 1:33        
        VEL_array(:,i) = cumtrapz(Tstate',ACC_array(:,i));    
    end
    
    % Integration of velocity with respect to time to give displacement    
    for i = 1:33        
        DIS_array(:,i) = cumtrapz(Tstate',VEL_array(:,i));    
    end
        
    % Calculate Magnitudes              
    n = 1;
    for x = 1:3:33  
        for i = 1:length(DIS_array)
            
            % Compute magnitude of Displacment
            Displacement_magnitude(i,n) = sqrt(DIS_array(i,x)^2 + DIS_array(i,(x+1))^2 + DIS_array(i,(x+2))^2);
            
            % Compute magnitude of Angular Speed
            Angular_speed_magnitude(i,n) = sqrt(AV_array(i,x)^2 + AV_array(i,(x+1))^2 + AV_array(i,(x+2))^2);
            
            % Account for differential shift in length
            if i <= (length(DIS_array) - 1)
                
                % Compute magnitude of Linear Jerk
                Linear_Jerk_magnitude(i,n) = sqrt(Linear_Jerk(i,x)^2 + Linear_Jerk(i,(x+1))^2 + Linear_Jerk(i,(x+2))^2);
            end
        end
         n = n + 1;
    end
        
    % Difference between each dispalcement point
    for p = 1:11
        for i = 1:length(DIS_array)-1
            disp_magnitude_diff(i,p) = abs(diff([Displacement_magnitude(i,p) Displacement_magnitude(i+1,p)]));                               
        end                          
    end
    
    % Sum total distance moved / Cumulative displacment
    Cumul_Displacement = sum(disp_magnitude_diff);
       
    %% Magntiude calculations        
    % For each body joint/segment 
    for X = 1:11
             
        % Mean Angular Speed 
        mean_angular_speeds(X,:) = mean(Angular_speed_magnitude(:,X));
       
        % Mean Linear Jerk
        mean_Total_LJerk(X,:) = mean(Linear_Jerk_magnitude(:,X));
              
    end

    %% Results
    % Return all kineamtic variables 
    Results(global_count,:) = [mean_angular_speeds', mean_Total_LJerk',Cumul_Displacement];
    
    % Clear all unnecessary varibles
    clearvars -except Results CROPstart_ARRAY CROPend_ARRAY Hd global_count Filename_ARRAY Fs b a

    % Display trial number for user reference
    fprintf('Trial number: %d \n', global_count);
    
end

% Save kinematic results in capsule
csvwrite('/results/Script_C_Kinematic_Data', Results);

% Plot results...

