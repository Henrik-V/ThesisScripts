using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.ML;
using Microsoft.ML.Data;

namespace Regression
{
    public partial class Form1 : Form
    {
        static readonly string _trainingPath = @"C:\Users\hnv91\OneDrive\Documents\MasterThesis\CSharp\trainingData.csv";
        static readonly string _testingPath = @"C:\Users\hnv91\OneDrive\Documents\MasterThesis\CSharp\testData.csv";

        public Form1()
        {
            InitializeComponent();

            var context = new MLContext();

            ////Loading data
            var trainingData = context.Data.LoadFromTextFile<Input>(_trainingPath, hasHeader: false, separatorChar: ',');
            var testingData = context.Data.LoadFromTextFile<Input>(_testingPath, hasHeader: false, separatorChar: ',');

            //Testdata for later
            Input[] inputs = context.Data.CreateEnumerable<Input>(testingData, reuseRowObject: false).ToArray();

            

            var normalizingColumns = new[]{

                new InputOutputColumnPair("Cap1"),
                new InputOutputColumnPair("Cap2"),
                new InputOutputColumnPair("Cap3"),
                new InputOutputColumnPair("Cap4"),
                new InputOutputColumnPair("Cap5"),
                new InputOutputColumnPair("AtmPressure"),
                new InputOutputColumnPair("Temperature")

            };

           
            //Normalizing and selecting training algorithm
            var pipeline = context.Transforms.NormalizeMinMax(normalizingColumns)
                .Append(context.Transforms.Concatenate("Features", "Cap1", "Cap2", "Cap3", "Cap4", "Cap5", "AtmPressure", "Temperature"))
                .Append(context.Regression.Trainers.FastForest());


            //Training
            var model = pipeline.Fit(trainingData);


            //Predicting
            var predictor = context.Model.CreatePredictionEngine<Input, Output>(model);

            List<float> predictions = new List<float>();
            List<float> densities = new List<float>();

            for(int i = 0; i < inputs.Length; i++)
            {
                var prediction = predictor.Predict(inputs[i]);
                predictions.Add(prediction.Density);
                densities.Add(inputs[i].Density);
            }

            PopulateChart(densities, predictions);
            
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
        private void PopulateChart(List<float> densities, List<float> predictions)
        {
            DensityChart.Series["Predicted Density"].Points.DataBindY(predictions);
            DensityChart.Series["Measured Density"].Points.DataBindY(densities);
        }

        private void DensityChart_Click(object sender, EventArgs e)
        {

        }
    }

    public class Input
    {
        [LoadColumn(0)]
        public float Cap1 { get; set; }


        [LoadColumn(1)]
        public float Cap2 { get; set; }


        [LoadColumn(2)]
        public float Cap3 { get; set; }


        [LoadColumn(3)]
        public float Cap4 { get; set; }


        [LoadColumn(4)]
        public float Cap5 { get; set; }


        [LoadColumn(6)]
        public float AtmPressure { get; set; }


        [LoadColumn(7)]
        public float Temperature { get; set; }

        //Change colum to 8 fro depth, 9 for density
        [LoadColumn(9), ColumnName("Label")]
        public float Density { get; set; }
    }
    public class Output
    {
        [ColumnName("Score")]
        public float Density;
    }


}
