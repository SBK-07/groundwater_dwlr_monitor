import numpy as np
import tensorflow as tf


import pandas as pd
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt
import json
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error

# Load test data (assume same columns as training)
df = pd.read_csv('stream_new_rows.csv')
feature_cols = ['Temperature_C', 'Rainfall_mm', 'pH', 'Dissolved_Oxygen_mg_L']
target_col = 'Water_Level_m'
df = df.dropna(subset=feature_cols + [target_col])
X = df[feature_cols].values.astype(np.float32)
y_true = df[target_col].values

# Load TFLite model
interpreter = tf.lite.Interpreter(model_path="elm_booster.tflite")
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Predict for all samples
y_pred = []
for i in range(X.shape[0]):
	x_input = X[i:i+1]
	interpreter.set_tensor(input_details[0]['index'], x_input)
	interpreter.invoke()
	output = interpreter.get_tensor(output_details[0]['index'])
	y_pred.append(output[0][0])
y_pred = np.array(y_pred)

print("Predicted groundwater level:", output[0][0])