import pandas as pd
import statsmodels.api as sm

data = pd.read_csv("german_credit_data.csv")

data.rename(columns={'Credit amount': 'Credit_amount'}, inplace=True)

data = data[['Age', 'Duration', 'Credit_amount']]

X = data[['Age', 'Duration']] 
X = sm.add_constant(X)

Y = data['Credit_amount']

model = sm.OLS(Y, X).fit()

print(model.params.round(2)) 
print(model.rsquared.round(2))
