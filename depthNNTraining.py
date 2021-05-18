# -*- coding: utf-8 -*-
import numpy as np
import keras
import keras.layers as ly
from sklearn.preprocessing import StandardScaler
from matplotlib import pyplot

inputNumber = 7
outputNumber = 1

#Path to training and testing sets of data
trainPath = ""
testPath = ""

trainingSet = np.genfromtxt(trainPath, delimiter=',')
testingSet = np.genfromtxt(testPath, delimiter=',')

sc = StandardScaler()

#Separating inputs and outputs and scaling inputs
xTrainingSet = np.hstack((trainingSet[:,:5], trainingSet[:,6:8]))
yTrainingSet = trainingSet[:,-outputNumber-1]
xTrainingSet = sc.fit_transform(xTrainingSet)

xTestingSet = np.hstack((testingSet[:,:5], testingSet[:,6:8]))
yTestingSet = testingSet[:,-outputNumber-1]
xTestingSet = sc.transform(xTestingSet)




#Creating neural network
inputs = keras.Input(shape=(inputNumber,))

hiddenLayer1 = ly.Dense(200, activation="tanh")(inputs)
hiddenLayer2 = ly.Dense(125, activation="tanh")(hiddenLayer1)
hiddenLayer3 = ly.Dense(80, activation="relu")(hiddenLayer2)
hiddenLayer4 = ly.Dense(100, activation="sigmoid")(hiddenLayer3)
hiddenLayer5 = ly.Dense(75, activation="tanh")(hiddenLayer4)
hiddenLayer6 = ly.Dense(75, activation="sigmoid")(hiddenLayer5)
hiddenLayer7 = ly.Dense(50, activation="relu")(hiddenLayer6)
hiddenLayer8 = ly.Dense(50, activation="relu")(hiddenLayer7)

output = ly.Dense(outputNumber)(hiddenLayer8)

model = keras.Model(inputs=inputs, outputs=output, name="DepthModel")

model.compile(loss="mean_squared_error", 
              optimizer="adam", 
              metrics=["mean_squared_error"])

#training the neural network
history = model.fit(xTrainingSet, yTrainingSet, epochs=1000, validation_data=(xTestingSet, yTestingSet))

#Path to test data
testPath = ""
testData = np.genfromtxt(testPath, delimiter=',')
#Separating inputs from outputs and scaling inputs
xTestData = np.hstack((testData[:,:5], testData[:,6:8]))
yTestData = testData[:,-outputNumber-1]
xTestData = sc.transform(xTestData)

#Estimate outputs based on tets input and compare to target data
yTestPredicted = model.predict(xTestData)

pyplot.plot(yTestPredicted, color='blue', label = 'predicted depth')
pyplot.plot(yTestData, color = 'orange', label = 'real depth')
pyplot.title('Model Test')
pyplot.legend()
pyplot.show()