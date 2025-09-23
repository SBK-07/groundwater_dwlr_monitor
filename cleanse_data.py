import pandas as pd
import numpy as np
import re
import os

# --- Step 1: Load dataset ---
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
DATA_PATH = os.path.join(ROOT, "invention_model\\dummy_datasets\\rmn", "rmn2023.csv")
# NEW_DATA_PATH = os.path.join(ROOT, "data", "chennai2023.csv")
df1 = pd.read_csv(DATA_PATH)

# Load new data
# df2 = pd.read_csv(NEW_DATA_PATH)

# Append rows (ignore index to reassign sequential index)
# df1 = pd.concat([df1, df2], ignore_index=True)


# --- Step 2: Define standard names mapping ---
standard_names = {
    "date": "Date",
    "waterlevel": "Water_Level_m",
    "water_level": "Water_Level_m",
    "temperature": "Temperature_C",
    "rainfall": "Rainfall_mm",
    "ph": "pH",
    "dissolvedoxygen": "Dissolved_Oxygen_mg_L",
    "dissolved_oxygen": "Dissolved_Oxygen_mg_L",
   	"Water Level (m)": "Water_Level_m",
    "Temperature (Â°C)": "Temperature_C",
    "Temperature (°C)": "Temperature_C",	
    "Rainfall (mm)"	: "Rainfall_mm",
    "pH Level": "pH",
    "Dissolved Oxygen (mg/L)": "Dissolved_Oxygen_mg_L"

}

def normalize_column_name(col):
    """Make column comparable by removing spaces, underscores, lowering case."""
    return re.sub(r'[^a-z0-9]', '', col.lower())

# --- Step 3: Rename columns dynamically ---
rename_dict = {}
for col in df1.columns:
    norm_col = normalize_column_name(col)
    for key in standard_names:
        if key in norm_col:  # fuzzy match
            rename_dict[col] = standard_names[key]
            break

df1 = df1.rename(columns=rename_dict)

print("After renaming columns:\n", df1.columns)

# --- Step 4: Now continue your cleaning pipeline ---
df1["Date"] = pd.to_datetime(df1["Date"], errors="coerce")
df1 = df1.sort_values("Date").set_index("Date")

# Replace negatives in Rainfall
valid_mean = df1.loc[df1['Rainfall_mm'] >= 0, 'Rainfall_mm'].mean()
df1['Rainfall_mm'] = df1['Rainfall_mm'].apply(lambda x: valid_mean if x < 0 else x)

# Water level cleaning
df1.loc[df1["Water_Level_m"] < 0, "Water_Level_m"] = None
df1["Water_Level_m"] = df1["Water_Level_m"].interpolate(method="time").ffill()

# --- Anomaly detection function (your code) ---
def detect_and_fix_anomalies(df, columns):
    df_fixed = df.copy()

    for col in columns:
        if df_fixed[col].dtype.kind in 'biufc':  # numeric only
            if col.lower().startswith("ph"):  # Special case
                mask = (df_fixed[col] < 1.5) | (df_fixed[col] > 12.5)
                print(f"{col}: {mask.sum()} anomalies found (outside 1.5–12.5)")
            else:
                Q1 = df_fixed[col].quantile(0.25)
                Q3 = df_fixed[col].quantile(0.75)
                IQR = Q3 - Q1
                mask = (df_fixed[col] < (Q1 - 1.5 * IQR)) | (df_fixed[col] > (Q3 + 1.5 * IQR))
                print(f"{col}: {mask.sum()} anomalies found (IQR method)")

            df_fixed.loc[mask, col] = np.nan
            df_fixed[col] = df_fixed[col].interpolate(method="linear").ffill().bfill()

    return df_fixed

df1 = detect_and_fix_anomalies(
    df1, ['Temperature_C', 'Rainfall_mm', 'Water_Level_m', 'pH', 'Dissolved_Oxygen_mg_L']
)

df1.to_csv("dwlr_new_data.csv")
print("File successfully cleansed and saved to the desired location..!!")
