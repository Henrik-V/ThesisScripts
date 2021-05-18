# -*- coding: utf-8 -*-

import numpy as np
import keras
import keras.layers as ly
from sklearn.preprocessing import StandardScaler
from matplotlib import pyplot

inputNumber = 7
outputNumber = 1

#Path to training data
path = "path"

trainingData = np.genfromtxt(path, delimiter=',')

#randomizing order of training data because the split later splits it at the end of the data set
np.random.shuffle(trainingData)

#Scaling input data an split into input, x, and output, y, data
sc = StandardScaler()
xTrainingData = np.hstack((trainingData[:,:5], trainingData[:,6:8]))
yTrainingData = trainingData[:,-outputNumber]
xTrainingData = sc.fit_transform(xTrainingData)


#Creating neural network
inputs = keras.Input(shape=(inputNumber,))

hiddenLayer1 = ly.Dense(150, activation="relu")(inputs)
hiddenLayer2 = ly.Dense(125, activation="tanh")(hiddenLayer1)
hiddenLayer3 = ly.Dense(100, activation="relu")(hiddenLayer2)
hiddenLayer4 = ly.Dense(75, activation="relu")(hiddenLayer3)
hiddenLayer5 = ly.Dense(50, activation="relu")(hiddenLayer4)
hiddenLayer6 = ly.Dense(25, activation="relu")(hiddenLayer5)

output = ly.Dense(outputNumber)(hiddenLayer6)

model = keras.Model(inputs=inputs, outputs=output, name="DensityModel")

model.compile(loss="mean_squared_error", 
              optimizer="adam", 
              metrics=["mean_squared_error"])

history = model.fit(xTrainingData, yTrainingData, epochs=1000, validation_split=0.2)

#Path to test data
testPath =""
testData = np.genfromtxt(testPath, delimiter=',')
#Separate inputs from output and scaling the input
xTestData = np.hstack((testData[:,:5], testData[:,6:8]))
yTestData = testData[:,-outputNumber]
xTestData = sc.transform(xTestData)

#Predict density based on inputs and plot with target densities
yTestPredicted = model.predict(xTestData)

pyplot.plot(yTestPredicted, color='blue', label = 'predicted density')
pyplot.plot(yTestData, color = 'orange', label = 'real density')
pyplot.title('Model Test')
pyplot.legend()
pyplot.show()