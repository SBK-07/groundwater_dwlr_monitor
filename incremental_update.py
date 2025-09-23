import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow import keras


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



# Load new data with correct columns
df_new = pd.read_csv('dwlr_new_data.csv')
feature_cols = ['Temperature_C', 'Rainfall_mm', 'pH', 'Dissolved_Oxygen_mg_L']
target_col = 'Water_Level_m'
df_new = df_new.dropna(subset=feature_cols + [target_col])
X_new = df_new[feature_cols].values
y_new = df_new[target_col].values

# Load models
elm = keras.models.load_model('elm_model.h5', custom_objects={'ELMLayer': ELMLayer}, compile=False)
booster = keras.models.load_model('booster_model.h5', compile=False)

# Retrain only output layer of ELM
for layer in elm.layers:
    layer.trainable = isinstance(layer, keras.layers.Dense)
elm.compile(optimizer='adam', loss=keras.losses.MeanSquaredError())
elm.fit(X_new, y_new, epochs=5, batch_size=16, verbose=1)

# Update booster on new residuals
y_pred_elm = elm.predict(X_new).flatten()
residuals = y_new - y_pred_elm
booster.compile(optimizer='adam', loss=keras.losses.MeanSquaredError())
booster.fit(X_new, residuals, epochs=5, batch_size=16, verbose=1)

# Save updated models
elm.save('elm_model.h5')
booster.save('booster_model.h5')

print("\n" + "="*60)
print("🔄 INCREMENTAL UPDATE COMPLETED")
print("="*60)
print("✅ ELM model updated and saved")
print("✅ Booster model updated and saved")
print("\n🔍 Running model evaluation...")

# Import and run evaluation
try:
    from evaluate_updated_model import evaluate_model_performance
    eval_folder, metrics = evaluate_model_performance()
    print(f"\n📁 All evaluation results saved in: {eval_folder}/")
    print("📊 Check the folder for:")
    print("   - comprehensive_evaluation.png (detailed plots)")
    print("   - metrics_comparison.png (performance comparison)")
    print("   - evaluation_metrics.json (detailed metrics)")
except Exception as e:
    print(f"⚠️  Evaluation failed: {e}")
    print("You can run 'python evaluate_updated_model.py' manually")

print("="*60)