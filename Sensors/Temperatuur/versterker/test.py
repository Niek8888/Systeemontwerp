import math

def calculate_absolute_humidity(temp_celsius, relative_humidity):
    # Berekening van de verzadigingsdampdruk (Es)
    es = 6.112 * math.exp((17.62 * temp_celsius) / (temp_celsius + 243.12))
    
    # Berekening van de werkelijke dampdruk (E)
    e = (relative_humidity) * es
    
    # Berekening van de absolute luchtvochtigheid (AH)
    absolute_humidity = (2.1674 * e) / (temp_celsius + 273.15)
    
    return absolute_humidity

# Voorbeeld invoer
temperature = 23  # Temperatuur in graden Celsius
relative_humidity = 50  # Relatieve luchtvochtigheid in %

# Berekening
ah = calculate_absolute_humidity(temperature, relative_humidity)
ah = ah/1.2
print(f"De absolute luchtvochtigheid is {ah:.2f} g/m³")
