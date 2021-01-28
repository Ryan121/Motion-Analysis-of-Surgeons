% This script is to be run after Script A and the subsequent file 
% data has been saved to a location in a local directory. 

% In order to run this script a calibration file is required which
% represents the particpants/suit users neutral I posture. Once a
% calibration file and acutal trial file have been recorded and saved to
% a local directory run this script.

% Ensure the correct local directory is selected in 'DIR' with the
% approprite cropping constants (if required). If not constants are set the
% script takes the complete length (all frames) of the  file. 

% The file returns an array containing a total LUBA posture score for each
% trial, combined individual LUBA segment scores and individual scores for
% each axis of rotation within each segment (In Results)

close all;clear all;clc;
CROPstart_ARRAY = []; CROPend_ARRAY = []; % Set to empty by default

% Axis Neuron sample frequency when setup in >= 18 neuron mode 
Fs = 120;

% Insert string array for the filenames of the Axis Neuron calibration files 
% EXAMPLE string data inserted 
CAL_ARRAY = ["calibration_1", "calibration_2", "calibration_3", "calibration_4", "calibration_5", "calibration_6"];

% Insert string array for the filenames of the Axis Neuron trial files 
% EXAMPLE string data inserted 
Filename_ARRAY = ["Example_Data_1", "Example_Data_2" , "Example_Data_3" , ...
    "Example_Data_4" , "Example_Data_5" ,"Example_Data_6"];

% Manually crop the start of the data to remove unwanted data (number
% represents frame number)
%CROPstart_ARRAY = [850 1 730 500 700 1 1]; 

% Manually crop the end of the data to remove unwanted data (number
% represents frame number)
%CROPend_ARRAY = [25330 15680 17130 16900 21700 15450];

% Set directory to load calibration and trial files from 
DIR = "C:\My Documents\";

%% Calibration refernce
% Establish the reference values for all upper segments for each member 
% of the trial cohort
[calib_array, ~] = Script_B_function(DIR, CAL_ARRAY, 1, 0, 0, zeros(0,0,0), Fs);


%% Trial results
% Set cropping constants if arrays are empty
if isempty(CROPstart_ARRAY) == true
    CROPstart_ARRAY = ones(1,length(Filename_ARRAY));
end
if isempty(CROPend_ARRAY) == true
    for i = 1:length(Filename_ARRAY)
        load(strcat(DIR,Filename_ARRAY(i),".mat"));       
        CROPend_ARRAY(i) = size(eval(Filename_ARRAY(i)),1);
        clearvars -except DIR Filename_ARRAY CROPstart_ARRAY CROPend_ARRAY calib_array
    end
end

% Run trial analysis and return LUBA results    
[~, Results] = Script_B_function(DIR, Filename_ARRAY, 0, CROPstart_ARRAY, CROPend_ARRAY, calib_array, Fs);
        
% Plot results...
