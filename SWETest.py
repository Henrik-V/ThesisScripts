# -*- coding: utf-8 -*-
import numpy as np
import keras
from sklearn.preprocessing import StandardScaler
from matplotlib import pyplot

#Provide path if the model file is in another folder
modelDensity = keras.models.load_model('modelDensity')
modelDepth = keras.models.load_model('modelDepth')

sc = StandardScaler()
#path to test data
path = ""
testData = np.genfromtxt(path, delimiter=',')
#Separating inputs from outputs and scaling inputs
xTestData = np.hstack((testData[:,:5], testData[:,6:8]))
yTestDataDensity = testData[:,-1]
yTestDataDepth = testData[:,-2]
xTestData = sc.fit_transform(xTestData)

#Estimating depth and density
yTestPredictedDensity = modelDensity.predict(xTestData)
yTestPredictedDepth = modelDepth.predict(xTestData)

#Prealocating array
SWE = np.zeros((len(testData),2))

#Calculating SWE
for i in range(len(testData)):
    SWE[i,0] = (yTestDataDepth[i])*yTestDataDensity[i]/1000
    SWE[i,1] = (yTestPredictedDepth[i])*yTestPredictedDensity[i]/1000

#Plotting estimated SWE vs. target SWE    
pyplot.plot(SWE[:,1], color='blue', label = 'Estimated SWE')
pyplot.plot(SWE[:,0], color = 'orange', label = 'Measured SWE')
pyplot.title('SWE Model')
pyplot.legend()
pyplot.ylabel('SWE [cm]')
pyplot.xlabel('Samples')
pyplot.savefig('PySWEMo.png')
pyplot.show()