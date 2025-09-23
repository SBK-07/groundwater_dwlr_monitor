import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow import keras
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
# --- Evaluation and Metrics (on test set) ---
import xgboost as xgb
import datetime



# --- Ensure TensorFlow uses GPU if available ---
print("TensorFlow version:", tf.__version__)
gpus = tf.config.list_physical_devices('GPU')
if gpus:
    try:
        for gpu in gpus:
            tf.config.experimental.set_memory_growth(gpu, True)
        print(f"GPUs detected: {gpus}")
    except Exception as e:
        print(f"Could not set GPU memory growth: {e}")
else:
    print("No GPU found, running on CPU.")
    print("If you have an NVIDIA GPU, ensure you have installed the correct CUDA Toolkit and cuDNN for your TensorFlow version.")
    print("See: https://www.tensorflow.org/install/gpu for setup help.")
# Calculate metrics for ELM+Booster

# --- Load DWLR CSV with correct columns ---
df = pd.read_csv('dwlr_new_data.csv')

# Use these columns: Date,Water_Level_m,Temperature_C,Rainfall_mm,pH,Dissolved_Oxygen_mg_L
# Target: Water_Level_m, Features: Temperature_C, Rainfall_mm, pH, Dissolved_Oxygen_mg_L
feature_cols = ['Temperature_C', 'Rainfall_mm', 'pH', 'Dissolved_Oxygen_mg_L']
target_col = 'Water_Level_m'

# Drop rows with missing values in features or target
df = df.dropna(subset=feature_cols + [target_col])

X = df[feature_cols].values
y = df[target_col].values

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# --- ELM Layer (Random hidden, trainable output) ---
class ELMLayer(keras.layers.Layer):
    def __init__(self, n_hidden, activation='relu', **kwargs):
        super().__init__(**kwargs)
        self.n_hidden = n_hidden
        self.activation = keras.activations.get(activation)
        self.trainable = False  # Hidden weights are frozen

    def build(self, input_shape):
        self.W = self.add_weight(
            shape=(input_shape[-1], self.n_hidden),
            initializer='random_normal',
            trainable=False,
            name='W'
        )
        self.b = self.add_weight(
            shape=(self.n_hidden,),
            initializer='zeros',
            trainable=False,
            name='b'
        )

    def call(self, inputs):
        return self.activation(tf.matmul(inputs, self.W) + self.b)

def build_elm(n_features, n_hidden):
    inputs = keras.Input(shape=(n_features,))
    x = ELMLayer(n_hidden)(inputs)
    outputs = keras.layers.Dense(1, trainable=True)(x)
    model = keras.Model(inputs, outputs)
    model.compile(optimizer='adam', loss='mse')
    return model

# --- Train ELM ---
n_hidden = 64
elm = build_elm(X_train.shape[1], n_hidden)
elm.fit(X_train, y_train, epochs=30, batch_size=32, verbose=1, validation_split=0.1)

# --- Residual Booster (XGBoost on ELM residuals) ---
y_pred_elm = elm.predict(X_train).flatten()
residuals = y_train - y_pred_elm

# XGBoost will learn to predict residuals given input features
xgb_booster = xgb.XGBRegressor(
    n_estimators=300,
    max_depth=4,
    learning_rate=0.05,
    subsample=0.9,
    colsample_bytree=0.9,
    reg_lambda=1.0,
    random_state=42,
    n_jobs=-1
)
xgb_booster.fit(X_train, residuals)


# --- Evaluation ---
y_pred_test_elm = elm.predict(X_test).flatten()
y_pred_test_combined = y_pred_test_elm + xgb_booster.predict(X_test).flatten()
mse_elm = mean_squared_error(y_test, y_pred_test_elm)
mse_combined = mean_squared_error(y_test, y_pred_test_combined)

import matplotlib.pyplot as plt
import json
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error

# Calculate metrics for ELM+XGBoost combined
r2 = r2_score(y_test, y_pred_test_combined)
mae = mean_absolute_error(y_test, y_pred_test_combined)
mse = mean_squared_error(y_test, y_pred_test_combined)
rmse = np.sqrt(mse)

results = {
    "r2": r2,
    "mae": mae,
    "mse": mse,
    "rmse": rmse
}

# Save results as JSON
with open('prediction_metrics.json', 'w') as f:
    json.dump(results, f, indent=2)
print("Metrics saved to prediction_metrics.json")

# Plot actual vs predicted
plt.figure(figsize=(10,6))
plt.plot(y_test, label='Actual', marker='o')
plt.plot(y_pred_test_combined, label='Predicted (ELM+XGB)', marker='x')
plt.title('Actual vs Predicted Groundwater Level (Test Set)')
plt.xlabel('Sample Index')
plt.ylabel('Water_Level_m')
plt.legend()
plt.tight_layout()
plt.savefig('actual_vs_predicted.png')
plt.close()
print("Chart saved to actual_vs_predicted.png")
print(f"ELM MSE: {mse_elm:.4f}")
print(f"ELM+XGB MSE: {mse_combined:.4f}")
improvement_pct = 100.0 * (mse_elm - mse_combined) / mse_elm if mse_elm > 0 else 0.0
print(f"Combined model reduced MSE by {improvement_pct:.2f}% vs ELM-only")

# --- Export ELM to TFLite for on-device inference (XGB runs server-side) ---
converter = tf.lite.TFLiteConverter.from_keras_model(elm)
tflite_model = converter.convert()
with open('elm.tflite', 'wb') as f:
    f.write(tflite_model)
print("TFLite model exported: elm.tflite")

# --- SAVE MODELS ---
elm.save('elm_model.h5')
xgb_booster.save_model('xgb_booster.json')
print("Models saved: elm_model.h5 and xgb_booster.json")

# Save a small manifest for downstream tools
manifest = {
    "created_at": datetime.datetime.now().isoformat(),
    "feature_columns": feature_cols,
    "target_column": target_col,
    "elm_hidden_units": n_hidden,
    "xgb_params": {
        "n_estimators": 300,
        "max_depth": 4,
        "learning_rate": 0.05,
        "subsample": 0.9,
        "colsample_bytree": 0.9,
        "reg_lambda": 1.0,
        "random_state": 42
    },
    "artifacts": {
        "elm_h5": "elm_model.h5",
        "xgb_json": "xgb_booster.json",
        "elm_tflite": "elm.tflite",
        "metrics_json": "prediction_metrics.json",
        "actual_vs_predicted": "actual_vs_predicted.png"
    }
}
with open('model_manifest.json', 'w') as f:
    json.dump(manifest, f, indent=2)

def predict_future(elm_model, xgb_model, last_row, feature_cols, days=1):
    """
    Predict groundwater level for the next 'days' days.
    last_row: pd.Series or np.array with the latest known features.
    feature_cols: list of feature column names.
    days: number of days to predict ahead.
    Returns: list of predicted water levels.
    """
    preds = []
    current_features = last_row.copy()
    for _ in range(days):
        # Prepare input for model
        X_input = np.array([current_features[feature_cols].astype(np.float32)])
        y_pred_elm_next = elm_model.predict(X_input)[0, 0]
        residual_next = xgb_model.predict(X_input)[0]
        y_pred = y_pred_elm_next + residual_next
        preds.append(y_pred)
        # Update features for next day (customize as needed)
        # For demo: keep other features constant, update water level
        current_features['Water_Level_m'] = y_pred
        # If you have future estimates for other features, update them here
    return preds

# Example usage:
# Get the last row from your dataframe
last_row = df.iloc[-1].copy()
# Predict next day
next_day_pred = predict_future(elm, xgb_booster, last_row, feature_cols, days=1)
print(f"Predicted groundwater level for next day: {next_day_pred[0]:.3f}")

# Predict next 30 days (1 month)
next_month_preds = predict_future(elm, xgb_booster, last_row, feature_cols, days=30)
print(f"Predicted groundwater levels for next month: {next_month_preds}")

# Predict for next 12 months (assuming 30 days per month)
next_year_preds = predict_future(elm, xgb_booster, last_row, feature_cols, days=12*30)
print(f"Predicted groundwater levels for next year: {next_year_preds}")

# For monthly summary, you can take the last value of each 30-day block:
monthly_preds = [next_year_preds[i*30-1] for i in range(1, 13)]
print(f"Predicted groundwater level at the end of each month: {monthly_preds}")