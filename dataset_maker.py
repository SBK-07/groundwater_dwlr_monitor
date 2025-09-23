import pandas as pd
from sklearn.model_selection import train_test_split

# Config
input_csv = "dwlr_new_data.csv"
train_out = "training_set.csv"
test_out = "test_data.csv"
test_size = 0.2
random_state = 42

# Read
df = pd.read_csv(input_csv)

# Ensure deterministic split with shuffling
train_df, test_df = train_test_split(df, test_size=test_size, random_state=random_state, shuffle=True)

train_df.to_csv(train_out, index=False)
test_df.to_csv(test_out, index=False)

print(f"Saved {train_out} (n={len(train_df)}) and {test_out} (n={len(test_df)})")