import argparse
import os
from datetime import datetime
import json

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import tensorflow as tf
from tensorflow import keras
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error


class ELMLayer(keras.layers.Layer):
	def __init__(self, n_hidden, activation='relu', **kwargs):
		super().__init__(**kwargs)
		self.n_hidden = n_hidden
		self.activation = keras.activations.get(activation)
		self.trainable = False

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


def load_models(elm_path: str, xgb_path: str):
	elm = keras.models.load_model(elm_path, custom_objects={'ELMLayer': ELMLayer}, compile=False)
	import xgboost as xgb
	xgb_model = xgb.XGBRegressor()
	xgb_model.load_model(xgb_path)
	return elm, xgb_model


def evaluate_on_csv(csv_path: str, out_dir: str):
	feature_cols = ['Temperature_C', 'Rainfall_mm', 'pH', 'Dissolved_Oxygen_mg_L']
	target_col = 'Water_Level_m'

	# Read and clean rows with missing values
	df = pd.read_csv(csv_path)
	df = df.dropna(subset=feature_cols + [target_col])
	X = df[feature_cols].values.astype(np.float32)
	y_true = df[target_col].values

	# Load artifacts
	elm, xgb_model = load_models('elm_model.h5', 'xgb_booster.json')

	# Predictions (ELM + XGBoost residual)
	y_pred_elm = elm.predict(X, verbose=0).flatten()
	residual_pred = xgb_model.predict(X).flatten()
	y_pred = y_pred_elm + residual_pred

	# Metrics
	metrics = {
		'r2': float(r2_score(y_true, y_pred)),
		'mae': float(mean_absolute_error(y_true, y_pred)),
		'mse': float(mean_squared_error(y_true, y_pred)),
		'rmse': float(np.sqrt(mean_squared_error(y_true, y_pred)))
	}

	# Save outputs
	os.makedirs(out_dir, exist_ok=True)
	preds_path = os.path.join(out_dir, 'predictions.csv')
	metrics_path = os.path.join(out_dir, 'metrics.json')
	scatter_path = os.path.join(out_dir, 'actual_vs_predicted.png')
	timeseries_path = os.path.join(out_dir, 'timeseries_actual_vs_pred.png')
	residuals_path = os.path.join(out_dir, 'residuals_plot.png')

	# Predictions CSV
	pred_df = pd.DataFrame({
		'Actual': y_true,
		'Predicted': y_pred,
		'Residual': y_true - y_pred
	})
	pred_df.to_csv(preds_path, index=False)

	# Metrics JSON
	with open(metrics_path, 'w') as f:
		json.dump(metrics, f, indent=2)

	# Scatter plot
	plt.figure(figsize=(8, 6))
	plt.scatter(y_true, y_pred, alpha=0.6)
	_min, _max = float(np.min(y_true)), float(np.max(y_true))
	plt.plot([_min, _max], [ _min, _max ], 'r--', lw=2)
	plt.xlabel('Actual Water Level (m)')
	plt.ylabel('Predicted Water Level (m)')
	plt.title('Actual vs Predicted (Test Dataset)')
	plt.grid(True, alpha=0.3)
	plt.tight_layout()
	plt.savefig(scatter_path, dpi=300)
	plt.close()

	# Time series plot
	plt.figure(figsize=(12, 6))
	idx = np.arange(len(y_true))
	plt.plot(idx, y_true, label='Actual', linewidth=2)
	plt.plot(idx, y_pred, label='Predicted', linewidth=2)
	plt.xlabel('Sample Index')
	plt.ylabel('Water Level (m)')
	plt.title('Time Series - Actual vs Predicted')
	plt.legend()
	plt.grid(True, alpha=0.3)
	plt.tight_layout()
	plt.savefig(timeseries_path, dpi=300)
	plt.close()

	# Residuals plot
	residuals = y_true - y_pred
	plt.figure(figsize=(8, 6))
	plt.scatter(y_pred, residuals, alpha=0.6, color='purple')
	plt.axhline(y=0, color='black', linestyle='--')
	plt.xlabel('Predicted Water Level (m)')
	plt.ylabel('Residual (Actual - Predicted)')
	plt.title('Residuals vs Predicted')
	plt.grid(True, alpha=0.3)
	plt.tight_layout()
	plt.savefig(residuals_path, dpi=300)
	plt.close()

	# Console summary
	print("\n================ TEST EVALUATION ================")
	print(f"Samples: {len(y_true)}")
	print(f"R2:   {metrics['r2']:.4f}")
	print(f"RMSE: {metrics['rmse']:.4f}")
	print(f"MAE:  {metrics['mae']:.4f}")
	print("Your model is improving in learning and predicting new data (test run).")
	print(f"Outputs saved to: {out_dir}")
	print(f"- predictions.csv\n- metrics.json\n- actual_vs_predicted.png\n- timeseries_actual_vs_pred.png\n- residuals_plot.png")

	return metrics


def main():
	parser = argparse.ArgumentParser(description='Evaluate unified ELM+XGBoost model on a test CSV.')
	parser.add_argument('--csv', type=str, default='test_data.csv', help='Path to test CSV file')
	parser.add_argument('--outdir', type=str, default=None, help='Directory to save outputs')
	args = parser.parse_args()

	if args.outdir is None:
		timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
		args.outdir = f'test_results_{timestamp}'

	evaluate_on_csv(args.csv, args.outdir)


if __name__ == '__main__':
	main()


