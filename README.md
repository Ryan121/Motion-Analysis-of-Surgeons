# Motion-Analysis-of-Surgeons
Motion analysis of Laparoscopic Surgeons using the Perception Neuron motion capture system

--------------------------------------------------------------------------------------------------------
The main scripts and functions contained within this capsule facilitate the following capabilities:
(1) the transmission of binary data using the Perception Neuron motion capture system via the 
systems proprietary software (Axis Neuron) in MATLAB for analysis (Script A), (2) the computation 
of the localised joint angle kinematics when referenced against the neutral I posture of study 
participants (Script B & B_function), (3) the postural assessment of the localised joint angles 
utilising the LUBA ergonomic framework for standing postures (LUBA functions), (4) the kinematic
analysis of upper body joint/segments producing variables for jerk, angular speed and 
cumulative displacement (Script C)

Several settings need to be correctly set within Axis Neuron for these scripts to perform as desired:

- Ensure binary data is being streamed out of the Axis Neuron .calc file option in the software settings
- Ensure the Port is set to the same as defined in Script A
- Ensure local quaternion data is streamed from the software

(1) - Script A

This script is to be used initially to transfer data from Axis Neuron to MATLAB and store the decoded raw
data in a predefined local directory. Detials on the script use can be found within the script header.

Script A has been previously used in [1], to faciliate a MATLAB-based analysis; however, the Script has been
submitted within this capsule due to its use within [2].

(2) - Script B

This serves as the master script that runs the B_function and LUBA scripts. This script is run after Script A
is used to read the data into MATLAB, to then compute the joint angles and output the LUBA results for all trials
streamed into MATLAB.

(3) - LUBA functions

The LUBA functions for each joint were defined using the LUBA ergonomic framework in standing postures [3].

(4) - Script C

This script facilitates a kinematic and dynamic workload assessment. This script is run after Script A
is used to read the data into MATLAB, then the kineamtic variables of linear jerk, angular speed and
cumulative displacment are computed. This script has been submitted within this capsule due to 
its use within [4].

[1] R. Sers, S. Forrester, E. Moss, S. Ward, J. Ma, M. Zecca, Validity of the Perception Neuron inertial 
motion capture system for upper body motion analysis, Meas. J. Int. Meas. Confed. 149 (2020). 
doi:10.1016/j.measurement.2019.107024.

[2] R. Sers, Steph Forrester, E. Moss, S. Ward, M. Zecca, The impact of patient body mass index on 
surgeon posture, MedRxiv. (2020). doi:doi.org/10.1101/2020.11.24.20237123
(This pre-print is due to be submitted for peer review)

[3] D. Kee, W. Karwowski, LUBA: An assessment technique for postural loading on the upper body based on 
joint motion discomfort and maximum holding time, Appl. Ergon. 32 (2001) 357–366. 
doi:10.1016/S0003-6870(01)00006-0.

[4] R. Sers, Steph Forrester, E. Moss, S. Ward, M. Zecca, Effect of patient body mass index on the upper 
body kinematics of laparoscopic surgeons (This manuscript is due to be submitted for peer review)


