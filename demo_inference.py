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

# Load ELM (Keras) + XGBoost booster, run combined inference
from tensorflow import keras
elm = keras.models.load_model('elm_model.h5', compile=False)
import xgboost as xgb
xgb_booster = xgb.XGBRegressor()
xgb_booster.load_model('xgb_booster.json')

y_pred_elm = elm.predict(X, verbose=0).flatten()
residual_pred = xgb_booster.predict(X).flatten()
y_pred = y_pred_elm + residual_pred

print("Predicted groundwater level (first sample):", y_pred[0])