import pandas as pd
import os

# Define locations and years
locations = ['cgl', 'chennai', 'rmn']  # Updated to match your folder names (cgl for Chengalpattu, rmn for Ramanathapuram)
years = ['2022', '2023', '2024']

# Output Dart code
dart_code = "// Generated from CSV files in subfolders\n"
dart_code += "import 'package:groundwater_monitor/models/groundwater_data.dart';\n\n"
dart_code += "List<GroundwaterData> getHardcodedData() {\n"
dart_code += "  final List<GroundwaterData> data = [\n"

for location in locations:
    for year in years:
        folder_path = os.path.join(location, f"{location}{year}.csv")
        if os.path.exists(folder_path):
            print(f"Processing {folder_path}...")
            df = pd.read_csv(folder_path)

            # Clean outliers
            df = df[(df['waterLevel'] >= 0) & (df['waterLevel'] <= 10)]
            df = df[df['rainfall'] <= 1000]
            df = df[df['temperature'] <= 50]
            df = df[(df['pHLevel'] >= 0) & (df['pHLevel'] <= 14)]
            df = df[df['dissolvedOxygen'] >= 0]
            df = df[df['dissolvedOxygen'] <= 15]

            # Map location prefix to actual location name
            loc_name = 'CGL' if location == 'cgl' else 'Chennai' if location == 'chennai' else 'Ramanathapuram'

            for _, row in df.iterrows():
                date = pd.to_datetime(row['date'])
                anomaly = 'Suspicious' if row['waterLevel'] > 5 else 'Normal'
                dart_code += f"""    GroundwaterData(
      date: DateTime({date.year}, {date.month}, {date.day}),
      waterLevel: {row['waterLevel']},
      rainfall: {row['rainfall']},
      temperature: {row['temperature']},
      pHLevel: {row['pHLevel']},
      dissolvedOxygen: {row['dissolvedOxygen']},
      anomalyStatus: '{anomaly}',
      stationStatus: 'Active',
      location: '{loc_name}',
    ),\n"""
        else:
            print(f"File {folder_path} not found. Skipping... (Please provide the file)")

dart_code += "  ];\n"
dart_code += "  return data.where((d) {\n"
dart_code += "    return d.waterLevel >= 0 &&\n"
dart_code += "        d.waterLevel <= 10 &&\n"
dart_code += "        d.rainfall <= 1000 &&\n"
dart_code += "        d.temperature <= 50 &&\n"
dart_code += "        d.pHLevel >= 0 &&\n"
dart_code += "        d.pHLevel <= 14 &&\n"
dart_code += "        d.dissolvedOxygen >= 0 &&\n"
dart_code += "        d.dissolvedOxygen <= 15;\n"
dart_code += "  }).toList();\n"
dart_code += "}\n"

# Write to file
with open('hardcoded_data_file.dart', 'w') as f:
    f.write(dart_code)

print("Generated hardcoded_data.dart with data from CSVs in subfolders!")