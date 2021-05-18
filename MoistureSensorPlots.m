Raw1 = readtable('Cabin2SnoDeLogData202012.csv');
Raw2 = readtable('Cabin3SnoDeLogData20212.csv');
Raw3 = readtable('Cabin1SnoDeLogData202011.csv');

Data1 = [Raw1{:,3:10}, str2double(strrep(Raw1{:,11}, ',', '.')), Raw1{:,12}];
Data2 = [str2double(strrep(Raw2{:,3:10}, ',', '.')), Raw2{:,11:12}];
Data3 = Raw3{:,2:11};
Data = [Data3; Data1; Data2];

%1 - Cap1
%2 - Cap2
%3 - Cap3
%4 - Cap4
%5 - Cap5
%6 - Pressure
%7 - Atm pressure
%8 - Temp
%9 - Heigth
%10 - Density


figure('Name', 'Soil moisture sensor over time', 'NumberTitle', 'off');
for capID = 1:5
    sp = subplot(5,1,capID);
    y = Data(:, capID);
    x = Data(:,7);
    plot(y);
    title(sprintf('Moisture Sensor #%d',capID));
    %xlabel('AtmPressure');
    ylabel('Voltage [mV]');
    legend(sprintf('Moisture Sensor #%d', capID));
end
