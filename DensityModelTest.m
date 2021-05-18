load('testdata.mat');
load('testtarget.mat');
load('DensityModel.mat');

predicted = DensityModel.predictFcn(TestData);

hold on
plot(predicted, 'b');
plot(TestTarget(:,2), 'color',[0.9100    0.4100    0.1700]);
title('Estimated vs. measured density');
xlabel('Sample');
ylabel('Density [kg/m3]');

legend('Estimated Density', 'Measured Density')

hold off