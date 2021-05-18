# -*- coding: utf-8 -*-
import numpy as np
import keras
from sklearn.preprocessing import StandardScaler
from matplotlib import pyplot

#Provide path if the model file is in another folder
model = keras.models.load_model('modelDepth')
outputNumber = 2
sc = StandardScaler()
#path to test data
path = ""
testData = np.genfromtxt(path, delimiter=',')
#Separating inputs from outputs and scaling inputs
xTestData = np.hstack((testData[:,:5], testData[:,6:8]))
yTestData = testData[:,-outputNumber]
xTestData = sc.fit_transform(xTestData)

#Plot density estimated by model vs target densities.
yTestPredicted = model.predict(xTestData)

pyplot.plot(yTestPredicted, color='blue', label = 'Estimated Depth')
pyplot.plot(yTestData, color = 'orange', label = 'Measured Depth')
pyplot.title('Snow Depth Model')
pyplot.legend()
pyplot.ylabel('Depth [cm]')
pyplot.xlabel('Samples')
pyplot.savefig('PyDepMo.png')
pyplot.show()