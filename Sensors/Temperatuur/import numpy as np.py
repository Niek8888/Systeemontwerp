import numpy as np
import matplotlib.pyplot as plt

# Gegevens
X = np.array([800, 1798, 1077, 1160, 1030, 751, 1114, 936])  # ADC-waarden
Y = np.array([2.15, 23.78, 9.122223, 11.146332, 8.019379, 0.726711, 10.040817, 5.688179])  # Temperatuurwaarden

# Pas een polynoom van graad 2 aan
coefficients = np.polyfit(X, Y, 4)
polynomial = np.poly1d(coefficients)

# Genereren van waarden voor plot
X_fit = np.linspace(min(X), max(X), 100)
Y_fit = polynomial(X_fit)

# Resultaten
print(f"Polynoom Coëfficiënten: {coefficients}")

# Resultaten
a, b, c, d, e = coefficients
print(f"Polynoom Coëfficiënten: a = {a}, b = {b}, c = {c}")
print(f"Formule: T = {a:.5f} * ADC^2 + {b:.5f} * ADC + {c:.5f}")

# Plot de gegevens en de polynoom
plt.scatter(X, Y, color='red', label='Data punten')
plt.plot(X_fit, Y_fit, label='Polynoom fit', color='blue')
plt.xlabel('ADC-waarden')
plt.ylabel('Temperatuur')
plt.title('Polynoom Regressie')
plt.legend()
plt.show()