import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow import keras
import matplotlib.pyplot as plt
import json
import os
from datetime import datetime
from sklearn.metrics import r2_score, mean_absolute_error, mean_squared_error
# import seaborn as sns  # Optional dependency

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

def evaluate_model_performance():
    """
    Evaluate the updated model performance on test data
    """
    print("🔍 Starting Model Evaluation...")
    
    # Create evaluation results folder with timestamp
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    eval_folder = f"evaluation_results_{timestamp}"
    os.makedirs(eval_folder, exist_ok=True)
    print(f"📁 Created evaluation folder: {eval_folder}")
    
    # Load test data (using the original training data as test for comparison)
    print("📊 Loading test data...")
    df_test = pd.read_csv('dwlr_new_data.csv')
    feature_cols = ['Temperature_C', 'Rainfall_mm', 'pH', 'Dissolved_Oxygen_mg_L']
    target_col = 'Water_Level_m'
    df_test = df_test.dropna(subset=feature_cols + [target_col])
    X_test = df_test[feature_cols].values
    y_test = df_test[target_col].values
    
    # Load new data for comparison
    df_new = pd.read_csv('dwlr_new_data.csv')
    df_new = df_new.dropna(subset=feature_cols + [target_col])
    X_new = df_new[feature_cols].values
    y_new = df_new[target_col].values
    
    # Load updated models
    print("🤖 Loading updated models...")
    elm = keras.models.load_model('elm_model.h5', custom_objects={'ELMLayer': ELMLayer}, compile=False)
    booster = keras.models.load_model('booster_model.h5', compile=False)
    
    # Create combined model for predictions
    inputs = keras.Input(shape=(X_test.shape[1],), name="input")
    y_elm = elm(inputs)
    y_boost = booster(inputs)
    outputs = keras.layers.Add()([y_elm, y_boost])
    combined_model = keras.Model(inputs=inputs, outputs=outputs, name="ELMBoosterCombined")
    
    # Predictions on test data
    print("🔮 Making predictions...")
    y_pred_test_elm = elm.predict(X_test, verbose=0).flatten()
    y_pred_test_boost = booster.predict(X_test, verbose=0).flatten()
    y_pred_test_combined = combined_model.predict(X_test, verbose=0).flatten()
    
    # Predictions on new data
    y_pred_new_elm = elm.predict(X_new, verbose=0).flatten()
    y_pred_new_boost = booster.predict(X_new, verbose=0).flatten()
    y_pred_new_combined = combined_model.predict(X_new, verbose=0).flatten()
    
    # Calculate metrics for test data
    print("📈 Calculating metrics...")
    metrics_test = {
        'dataset': 'test_data',
        'elm_only': {
            'r2': r2_score(y_test, y_pred_test_elm),
            'mae': mean_absolute_error(y_test, y_pred_test_elm),
            'mse': mean_squared_error(y_test, y_pred_test_elm),
            'rmse': np.sqrt(mean_squared_error(y_test, y_pred_test_elm))
        },
        'booster_only': {
            'r2': r2_score(y_test, y_pred_test_boost),
            'mae': mean_absolute_error(y_test, y_pred_test_boost),
            'mse': mean_squared_error(y_test, y_pred_test_boost),
            'rmse': np.sqrt(mean_squared_error(y_test, y_pred_test_boost))
        },
        'combined_model': {
            'r2': r2_score(y_test, y_pred_test_combined),
            'mae': mean_absolute_error(y_test, y_pred_test_combined),
            'mse': mean_squared_error(y_test, y_pred_test_combined),
            'rmse': np.sqrt(mean_squared_error(y_test, y_pred_test_combined))
        }
    }
    
    # Calculate metrics for new data
    metrics_new = {
        'dataset': 'new_data',
        'elm_only': {
            'r2': r2_score(y_new, y_pred_new_elm),
            'mae': mean_absolute_error(y_new, y_pred_new_elm),
            'mse': mean_squared_error(y_new, y_pred_new_elm),
            'rmse': np.sqrt(mean_squared_error(y_new, y_pred_new_elm))
        },
        'booster_only': {
            'r2': r2_score(y_new, y_pred_new_boost),
            'mae': mean_absolute_error(y_new, y_pred_new_boost),
            'mse': mean_squared_error(y_new, y_pred_new_boost),
            'rmse': np.sqrt(mean_squared_error(y_new, y_pred_new_boost))
        },
        'combined_model': {
            'r2': r2_score(y_new, y_pred_new_combined),
            'mae': mean_absolute_error(y_new, y_pred_new_combined),
            'mse': mean_squared_error(y_new, y_pred_new_combined),
            'rmse': np.sqrt(mean_squared_error(y_new, y_pred_new_combined))
        }
    }
    
    # Save metrics
    all_metrics = {
        'evaluation_timestamp': timestamp,
        'test_data_metrics': metrics_test,
        'new_data_metrics': metrics_new,
        'model_info': {
            'elm_hidden_units': elm.layers[1].n_hidden,
            'booster_layers': len(booster.layers),
            'total_test_samples': len(y_test),
            'total_new_samples': len(y_new)
        }
    }
    
    with open(f'{eval_folder}/evaluation_metrics.json', 'w') as f:
        json.dump(all_metrics, f, indent=2)
    
    # Create visualizations
    print("🎨 Creating visualizations...")
    
    # 1. Actual vs Predicted - Test Data
    plt.figure(figsize=(15, 10))
    
    plt.subplot(2, 3, 1)
    plt.scatter(y_test, y_pred_test_combined, alpha=0.6, color='blue')
    plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--', lw=2)
    plt.xlabel('Actual Water Level')
    plt.ylabel('Predicted Water Level')
    plt.title('Actual vs Predicted (Test Data)\nCombined Model')
    plt.grid(True, alpha=0.3)
    
    # 2. Actual vs Predicted - New Data
    plt.subplot(2, 3, 2)
    plt.scatter(y_new, y_pred_new_combined, alpha=0.6, color='green')
    plt.plot([y_new.min(), y_new.max()], [y_new.min(), y_new.max()], 'r--', lw=2)
    plt.xlabel('Actual Water Level')
    plt.ylabel('Predicted Water Level')
    plt.title('Actual vs Predicted (New Data)\nCombined Model')
    plt.grid(True, alpha=0.3)
    
    # 3. Time series comparison - Test Data
    plt.subplot(2, 3, 3)
    indices = range(len(y_test))
    plt.plot(indices, y_test, label='Actual', alpha=0.7, linewidth=2)
    plt.plot(indices, y_pred_test_combined, label='Predicted', alpha=0.7, linewidth=2)
    plt.xlabel('Sample Index')
    plt.ylabel('Water Level (m)')
    plt.title('Time Series Comparison\nTest Data')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # 4. Time series comparison - New Data
    plt.subplot(2, 3, 4)
    indices = range(len(y_new))
    plt.plot(indices, y_new, label='Actual', alpha=0.7, linewidth=2)
    plt.plot(indices, y_pred_new_combined, label='Predicted', alpha=0.7, linewidth=2)
    plt.xlabel('Sample Index')
    plt.ylabel('Water Level (m)')
    plt.title('Time Series Comparison\nNew Data')
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # 5. Residuals plot - Test Data
    plt.subplot(2, 3, 5)
    residuals_test = y_test - y_pred_test_combined
    plt.scatter(y_pred_test_combined, residuals_test, alpha=0.6, color='red')
    plt.axhline(y=0, color='black', linestyle='--')
    plt.xlabel('Predicted Water Level')
    plt.ylabel('Residuals')
    plt.title('Residuals Plot\nTest Data')
    plt.grid(True, alpha=0.3)
    
    # 6. Residuals plot - New Data
    plt.subplot(2, 3, 6)
    residuals_new = y_new - y_pred_new_combined
    plt.scatter(y_pred_new_combined, residuals_new, alpha=0.6, color='orange')
    plt.axhline(y=0, color='black', linestyle='--')
    plt.xlabel('Predicted Water Level')
    plt.ylabel('Residuals')
    plt.title('Residuals Plot\nNew Data')
    plt.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig(f'{eval_folder}/comprehensive_evaluation.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    # 7. Metrics comparison bar chart
    plt.figure(figsize=(12, 8))
    
    models = ['ELM Only', 'Booster Only', 'Combined']
    test_r2 = [metrics_test['elm_only']['r2'], metrics_test['booster_only']['r2'], metrics_test['combined_model']['r2']]
    new_r2 = [metrics_new['elm_only']['r2'], metrics_new['booster_only']['r2'], metrics_new['combined_model']['r2']]
    
    x = np.arange(len(models))
    width = 0.35
    
    plt.subplot(2, 2, 1)
    plt.bar(x - width/2, test_r2, width, label='Test Data', alpha=0.8)
    plt.bar(x + width/2, new_r2, width, label='New Data', alpha=0.8)
    plt.xlabel('Model Type')
    plt.ylabel('R² Score')
    plt.title('R² Score Comparison')
    plt.xticks(x, models)
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # RMSE comparison
    test_rmse = [metrics_test['elm_only']['rmse'], metrics_test['booster_only']['rmse'], metrics_test['combined_model']['rmse']]
    new_rmse = [metrics_new['elm_only']['rmse'], metrics_new['booster_only']['rmse'], metrics_new['combined_model']['rmse']]
    
    plt.subplot(2, 2, 2)
    plt.bar(x - width/2, test_rmse, width, label='Test Data', alpha=0.8)
    plt.bar(x + width/2, new_rmse, width, label='New Data', alpha=0.8)
    plt.xlabel('Model Type')
    plt.ylabel('RMSE')
    plt.title('RMSE Comparison')
    plt.xticks(x, models)
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # MAE comparison
    test_mae = [metrics_test['elm_only']['mae'], metrics_test['booster_only']['mae'], metrics_test['combined_model']['mae']]
    new_mae = [metrics_new['elm_only']['mae'], metrics_new['booster_only']['mae'], metrics_new['combined_model']['mae']]
    
    plt.subplot(2, 2, 3)
    plt.bar(x - width/2, test_mae, width, label='Test Data', alpha=0.8)
    plt.bar(x + width/2, new_mae, width, label='New Data', alpha=0.8)
    plt.xlabel('Model Type')
    plt.ylabel('MAE')
    plt.title('MAE Comparison')
    plt.xticks(x, models)
    plt.legend()
    plt.grid(True, alpha=0.3)
    
    # Model performance summary
    plt.subplot(2, 2, 4)
    plt.text(0.1, 0.8, f'Evaluation Summary', fontsize=14, fontweight='bold')
    plt.text(0.1, 0.7, f'Timestamp: {timestamp}', fontsize=10)
    plt.text(0.1, 0.6, f'Test Samples: {len(y_test)}', fontsize=10)
    plt.text(0.1, 0.5, f'New Samples: {len(y_new)}', fontsize=10)
    plt.text(0.1, 0.4, f'Best R² (Combined): {max(test_r2[2], new_r2[2]):.4f}', fontsize=10)
    plt.text(0.1, 0.3, f'Best RMSE (Combined): {min(test_rmse[2], new_rmse[2]):.4f}', fontsize=10)
    plt.xlim(0, 1)
    plt.ylim(0, 1)
    plt.axis('off')
    
    plt.tight_layout()
    plt.savefig(f'{eval_folder}/metrics_comparison.png', dpi=300, bbox_inches='tight')
    plt.close()
    
    # Print summary
    print("\n" + "="*60)
    print("🎯 EVALUATION SUMMARY")
    print("="*60)
    print(f"📁 Results saved in: {eval_folder}/")
    print(f"📊 Test Data - Combined Model:")
    print(f"   R²: {metrics_test['combined_model']['r2']:.4f}")
    print(f"   RMSE: {metrics_test['combined_model']['rmse']:.4f}")
    print(f"   MAE: {metrics_test['combined_model']['mae']:.4f}")
    print(f"📊 New Data - Combined Model:")
    print(f"   R²: {metrics_new['combined_model']['r2']:.4f}")
    print(f"   RMSE: {metrics_new['combined_model']['rmse']:.4f}")
    print(f"   MAE: {metrics_new['combined_model']['mae']:.4f}")
    
    # Determine if model is working well
    if metrics_test['combined_model']['r2'] > 0.7 and metrics_new['combined_model']['r2'] > 0.7:
        print("✅ Model is performing well on both datasets!")
    elif metrics_test['combined_model']['r2'] > 0.5 or metrics_new['combined_model']['r2'] > 0.5:
        print("⚠️  Model performance is moderate. Consider more training data.")
    else:
        print("❌ Model performance is poor. Consider retraining or more data.")
    
    print("="*60)
    
    return eval_folder, all_metrics

if __name__ == "__main__":
    eval_folder, metrics = evaluate_model_performance()
