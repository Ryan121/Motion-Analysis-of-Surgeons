% This script acts as the client to the Axis Neuron server and facilitates
% the transfer of the .calc file data in binary format.

% Run this script BEFORE running Axis Neuron. 

%%  Declare size of data Array (the number of frames within Axis Neuron)
clear all;close all;clc;

% The number of frames within Axis Neuron
numberOfFrames = 500000;

% The number of columns in a .calc file binary transmission 
cols = 944;

% Define the Array for the streamed/imported data
Dataarray = zeros(numberOfFrames,cols); 

% Define save location for Pre-processed Mo-Cap data
% INSERT DIR HERE
savedir = '';

%% Input for file name
dlgtitle = 'File Input';
prompt = 'Enter file name:';
dims = [1 35];
filename = inputdlg(prompt,dlgtitle,dims);

% Prepare file name and location 
str = convertCharsToStrings(filename);
X = convertStringsToChars(str);
string = strcat(savedir,str,'.mat');

%% Open TCP client in order to recieve Mo-Cap data

% The IP of the server (In this case it is the host)
IPAddress = '127.0.0.1'; 

% The Port number defined for binary .calc transmission within Axis Neuron
% (default is 7003)
Port = 7003;

% Initialise client object
tcpipAxisNeuron = tcpip(IPAddress,Port,'NetworkRole','client');

% Set buffer size to avoid data loss or disconnect
tcpipAxisNeuron.InputBufferSize = 200000; 

% Listen for server transmission (Axis Neuron must be open) 
fopen(tcpipAxisNeuron); 

% Set flag variables
timedout = false;  timeoutcount = 0; frame_number=0; 

%% Recieve and decode Mo-Cap data

% A temporary array to hold a frame of data
Data = zeros(1,cols);

% The number of characters in a single binary frame
b_chars = 3848;

% Wait while no data is available
while(tcpipAxisNeuron.BytesAvailable == 0)
end

% Recieve data unless transmission stops 
while(~timedout)
    if(tcpipAxisNeuron.BytesAvailable > 0 )
        
        % Read binary .calc file data
        rawData = fread(tcpipAxisNeuron,b_chars);
        
        % Set flag
        timeoutcount = 0; 
               
        % Decode binary stream and store
        for i=(0:(cols-1)) 
            Dataarray(i+1)=typecast(uint8(rawData((i*4+65):(i*4+68))),'single');
        end
        
        % Display frame number for user reference
        fprintf('frame number: %d \n', frame_number);
        
        % Increment display counter
        frame_number = frame_number + 1;
        
    else 
        % Increment time out sequence        
        timeoutcount = timeoutcount + 1;
        
        if timeoutcount > 500
            % Stop receiving data
            timedout = true;
        end
    end 
end

% Close and destroy TCP object 
fclose(tcpipAxisNeuron);
delete(tcpipAxisNeuron);

%% Save file to predefined location

% Shorten array if inital declaration was set too large
Dataarray = Dataarray(1:frame_number,:);

% Convert to format suitable for the save function 
eval([X '= Dataarray;']);

% Save data
save(string, X);
