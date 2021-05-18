clear
Raw1 = readtable('Cabin2SnoDeLogData202012.csv');
Raw2 = readtable('Cabin3SnoDeLogData20212.csv');
Raw3 = readtable('Cabin1SnoDeLogData202011.csv');

%Remove invalid pressure values
Raw3 = Raw3(Raw3.PressSens_2_Atm_mBar_ > 900, :);
Raw1 = Raw1(Raw1.PressSens_2_Atm_mBar_ > 900, :);
%Remove samples with zero snow where there should be snow
Raw1 = Raw1(str2double((Raw1.ManSnowHeight_cm_)) > 0, :);
Raw2 = Raw2(Raw2.Var11 > 0, :);

%Only samples with the supervisedlearning flag on
Raw1 = Raw1(strcmp(Raw1.SupervisedLearningFlag, 'ON'), :);
Raw2 = Raw2(strcmp(Raw2.Var14, 'ON'), :);
Raw3 = Raw3(strcmp(Raw3.SupervisedLearningFlag, 'ON'), :);

%Convert from table to array
Data1 = [Raw1{:,3:10}, str2double(strrep(Raw1{:,11}, ',', '.')), Raw1{:,12}];
Data2 = [str2double(strrep(Raw2{:,3:10}, ',', '.')), Raw2{:,11:12}];
Data3 = Raw3{:,2:11};
trainingData = [Data3; Data1; Data2];

%Create trainig and test sets for models that will be validated not on
%random samples, but on some samples for each depth.
trainingSet = [trainingData(1:9,:);trainingData(22:79,:); trainingData(92:117,:); trainingData(122:123,:);
    trainingData(128:134,:); trainingData(136:138,:); trainingData(146:156,:);];

testingSet = [trainingData(10:21,:); trainingData(80:91,:); trainingData(118:121,:); trainingData(124:127,:);
    trainingData(135,:); trainingData(139:145,:);];

%Saving to file for use in other programs than MATLAB
writematrix(trainingData, 'trainingData.csv');
writematrix(trainingSet, 'trainingSet.csv');
writematrix(testingSet, 'testingSet.csv');

%Saving for use in MATLAB
matlabTrainingInput = [trainingData(:,1:5), trainingData(:,7:8)];
matlabTriningTargetDensity = trainingData(:,10);
matlabTriningTargetHeight = trainingData(:,9);
save('matlabTrainingInput', 'matlabTriningTargetDensity', 'matlabTriningTargetHeight');