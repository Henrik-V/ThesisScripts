clear
Raw1 = readtable('Cabin2SnoDeLogData202012.csv');
Raw2 = readtable('Cabin3SnoDeLogData20212.csv');
Raw3 = readtable('Cabin1SnoDeLogData202011.csv');

%Remove invalid pressure values
Raw3 = Raw3(Raw3.PressSens_2_Atm_mBar_ > 900, :);
Raw1 = Raw1(Raw1.PressSens_2_Atm_mBar_ > 900, :);

%Only using samples with the unsupervised learning flag off
Raw1 = Raw1(strcmp(Raw1.SupervisedLearningFlag, 'OFF'), :);
Raw2 = Raw2(strcmp(Raw2.Var14, 'OFF'), :);
Raw3 = Raw3(strcmp(Raw3.SupervisedLearningFlag, 'OFF'), :);

%Preallocating arrays
TestTarget1 = zeros(size(Raw1, 1), 2);
TestTarget2 = zeros(size(Raw2, 1), 2);
TestTarget3 = Raw3{:,10:11};

%Conberting from table to array and only keeping moisture sensor, atm.
%pressure, and temperature
Data1 = [Raw1{:,3:8}, Raw1{:,9:10}];
Data2 = [str2double(strrep(Raw2{:,3:8}, ',', '.')), str2double(strrep(Raw2{:,9:10}, ',', '.'))];
Data3 = [Raw3{:,2:7}, Raw3{:,8:9}];
TestData = [Data3; Data1; Data2];

Raw1 = readtable('Cabin2SnoDeLogData202012.csv');
Raw2 = readtable('Cabin3SnoDeLogData20212.csv');
Raw3 = readtable('Cabin1SnoDeLogData202011.csv');

%Remove invalid pressure values
Raw3 = Raw3(Raw3.PressSens_2_Atm_mBar_ > 900, :);
Raw1 = Raw1(Raw1.PressSens_2_Atm_mBar_ > 900, :);


%Filling in samples with the unsupervised learning flags with density and
%depth data based on last manual measurement.
x=1;
density = 225;
height = 60;
for i = 1:size(Raw1,1)
    
    if strcmp(Raw1.SupervisedLearningFlag(i), 'ON')
        density = Raw1{i,12};
        height = str2double(strrep(Raw1{i,11}, ',', '.'));
    end
    if strcmp(Raw1.SupervisedLearningFlag(i), 'OFF')
    TestTarget1(x, 2) = density;
    TestTarget1(x, 1) = height;
    x = x+1;
    end
end

x=1;
density = 233;
height = 81;
for i = 1:size(Raw2,1)
    
    if strcmp(Raw2.Var14(i), 'ON')
        density = Raw2{i,12};
        height = Raw2{i,11};
    end
    if strcmp(Raw2.Var14(i), 'OFF')
    TestTarget2(x, 2) = density;
    TestTarget2(x, 1) = height;
    x = x+1;
    end
end

TestTarget = [TestTarget3; TestTarget1; TestTarget2];
testData = [TestData, TestTarget];
%Saving for use in MATLAB
save('testInput', 'TestData');
save('testtarget', 'TestTarget');

%Saving for use in other programs
writematrix(testData, 'testData.csv');