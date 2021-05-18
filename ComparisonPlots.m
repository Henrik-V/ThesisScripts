clear
Raw1 = readtable('Cabin2SnoDeLogData202012.csv');
Raw2 = readtable('Cabin3SnoDeLogData20212.csv');
Raw3 = readtable('Cabin1SnoDeLogData202011.csv');

%Remove invalid pressure values
Raw3 = Raw3(Raw3.PressSens_2_Atm_mBar_ > 900, :);
Raw1 = Raw1(Raw1.PressSens_2_Atm_mBar_ > 900, :);

%Convert from table to array.
Data1 = [Raw1{:,3:10}, str2double(strrep(Raw1{:,11}, ',', '.')), Raw1{:,12}];
Data2 = [str2double(strrep(Raw2{:,3:10}, ',', '.')), Raw2{:,11:12}];
Data3 = Raw3{:,2:11};


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

sensorHeights =[10 30 50 80 110];

%Filling in depth and density values on samples with supervised flag off
density = 225;
height = 60;
for i = 1:size(Raw1,1)
    
    if strcmp(Raw1.SupervisedLearningFlag(i), 'ON')
        density = Raw1{i,12};
        height = str2double(strrep(Raw1{i,11}, ',', '.'));
    end
    if strcmp(Raw1.SupervisedLearningFlag(i), 'OFF')
    Data1(i, 10) = density;
    Data1(i, 9) = height;
    
    end
end


density = 233;
height = 81;
for i = 1:size(Raw2,1)
    
    if strcmp(Raw2.Var14(i), 'ON')
        density = Raw2{i,12};
        height = Raw2{i,11};
    end
    if strcmp(Raw2.Var14(i), 'OFF')
    Data2(i, 10) = density;
    Data2(i, 9) = height;
   
    end
end

Data = [Data3; Data1; Data2];


for capID = 1:5
    figure('Name', sprintf('Moisture Sensor #%d - Sjusjøen - Nov, Dec, Feb', capID), 'NumberTitle', 'off');
    
    for i = 1:4
        
        switch(i)
            case 1
                label = 'Atm. Pressure [mBar]';
            case 2
                label = 'Temperature [C]';
            case 3
                label = 'Depth [cm]';
            case 4
                label = 'Density [kg/m3]';
        end
        
        hold on
        yyaxis left
        sp = subplot(4,1,i);
        y = Data(:, capID);
        plot(y);
        title(sprintf('Moisture Sensor #%d',capID));
        xlabel('Sample');
        ylabel('Voltage [mV]');
        
        

        yyaxis right
        plot(Data(:,6+i));
        ylabel(label);

        
        
        yyaxis left
        yl = ylim;
        %Creating verticies for colouring background of plot based on
        %sensor coverage
        verticies(:,:,1) = [0 yl(1); 172 yl(1); 172 yl(2); 0 yl(2)];
        verticies(:,:,2) = [172 yl(1); 221 yl(1); 221 yl(2); 172 yl(2)];
        verticies(:,:,3) = [221 yl(1); 309 yl(1); 309 yl(2); 221 yl(2)];
        verticies(:,:,4) = [309 yl(1); 313 yl(1); 313 yl(2); 309 yl(2)];
        verticies(:,:,5) = [313 yl(1); 372 yl(1); 372 yl(2); 313 yl(2)];
        f=[1 2 3 4];
        
        %Deciding face colort based on sensor heigth and snow depth
        for x = 1:size(verticies, 3)
            if Data(verticies(2,1,x),9) >= sensorHeights(capID)
                patch('Faces', f, 'Vertices', verticies(:,:,x), 'FaceColor', 'green', 'FaceAlpha', 0.05, 'EdgeAlpha', 0); 
            else
                patch('Faces', f, 'Vertices', verticies(:,:,x), 'FaceColor', 'red', 'FaceAlpha', 0.05, 'EdgeAlpha', 0);
            end
        end
        
        %vertical lines identifying where December and February starts
        xline(173, '-');
        xline(312, '-');
        
        legend(sprintf('Moisture Sensor %d', capID));
        
        hold off
        
    end
end



