load('testdata.mat');
load('testtarget.mat');

predictedB_R_50 = DensityB_R_50(TestData);


hold on
plot(predictedB_R_50, 'b');
plot(TestTarget(:,2), 'color',[0.9100    0.4100    0.1700]);
title('Neural Network Snow Density Prediction');
xlabel('Sample');
ylabel('Density [kg/m^3]');


legend('Predicted Density', 'Measured Density')

hold off