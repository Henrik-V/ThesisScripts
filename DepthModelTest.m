load('testdata.mat');
load('testtarget.mat');
load('DepthModel.mat');

predicted = DepthModel.predictFcn(TestData);

hold on
plot(predicted, 'b');
plot(TestTarget(:,1), 'color',[0.9100    0.4100    0.1700]);
title('Estimated vs. measured depth');
xlabel('Sample');
ylabel('Depth [cm]');

legend('Estimated Depth', 'Measured Depth')

hold off