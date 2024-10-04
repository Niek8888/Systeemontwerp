import numpy as np

# Gegeven waarden
R = 24000  # Weerstand in Ohm

# Witte ruiswaarden
U_white_ref = 2e-6  # Spanningsreferentie witte ruis in V/sqrt(Hz)
U_white_opamp = 90e-9  # Opamp witte ruis in V/sqrt(Hz)

# Frequentiegrenzen
f_cutoff = 10  # Frequentie waar de witte ruis het overneemt (10 Hz)
f_low_ref = 0.1  # Lagere frequentiegrens voor referentie
f_low_opamp = 0.01  # Lagere frequentiegrens voor opamp
f_high = 5  # Bovenste frequentiegrens voor de berekeningen

# Functie voor integratie van 1/f-ruis (tot cutoff)
def integrate_flicker_noise(low_f, cutoff_f, A):
    return A * np.log(cutoff_f / low_f)

# Ruissterkte (A bepaald uit witte ruis bij 10 Hz)
A_ref = U_white_ref * f_cutoff  # Voor de referentie
A_opamp = U_white_opamp * f_cutoff  # Voor de opamp

# Nieuwe cutoff frequentie gebaseerd op de bovenste grens van 5 Hz
f_cutoff_new = min(f_cutoff, f_high)

# Integreer 1/f-ruis voor zowel de referentie als de opamp over hun respectieve frequentiegebieden
U_n_ref_flicker_new = integrate_flicker_noise(f_low_ref, f_cutoff_new, A_ref)
U_n_opamp_flicker_new = integrate_flicker_noise(f_low_opamp, f_cutoff_new, A_opamp)

# Aangepaste totale ruis (alleen flicker noise tot de nieuwe cutoff)
U_n_ref_total_new = U_n_ref_flicker_new  # Geen witte ruis boven 5 Hz
U_n_opamp_total_new = U_n_opamp_flicker_new  # Geen witte ruis boven 5 Hz

# Stroomruis omrekenen (spanningsruis gedeeld door weerstand)
I_n_ref_total_new = U_n_ref_total_new / R
I_n_opamp_total_new = U_n_opamp_total_new / R

# Totale stroomruis kwadratisch optellen
I_n_total_new = np.sqrt(I_n_ref_total_new**2 + I_n_opamp_total_new**2)

# Resultaten
print(I_n_ref_total_new, I_n_opamp_total_new, I_n_total_new)
