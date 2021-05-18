load('testdata.mat');
load('testtarget.mat');

predictedB_R_50 = DepthB_R_50(TestData);


hold on
plot(predictedB_R_50, 'b');
plot(TestTarget(:,1), 'color',[0.9100    0.4100    0.1700]);
title('Neural Network Snow Depth Prediction');
xlabel('Sample');
ylabel('Snow Depth [cm]');


legend('Predicted Depth', 'Measured Depth')

hold off