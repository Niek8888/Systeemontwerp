% Gegeven waarden
R = 24000;  % Weerstand in Ohm
c = 55;     % temperatuur in celcius
T = c + 273,15;   % temperatuur in kelvin
k_B = 1.38e-23;  % Boltzmann constante
I_sensor = (128/3)* 10 ^ -6;

% Witte ruiswaarden
U_white_ref = 2e-6;  % Spanningsreferentie witte ruis in V/sqrt(Hz)
U_white_opamp = 90e-9;  % Opamp witte ruis in V/sqrt(Hz)

% Frequentiegrenzen
f_cutoff = 10;  % Frequentie waar de witte ruis het overneemt (10 Hz)
f_low_ref = 0.1;  % Lagere frequentiegrens voor referentie
f_low_opamp = 0.01;  % Lagere frequentiegrens voor opamp
f_high = 5;  % Bovenste frequentiegrens voor de berekeningen

% Functie voor integratie van 1/f-ruis
function result = integrate_flicker_noise(low_f, cutoff_f, A)
  result = A * log(cutoff_f / low_f);
end

% Ruissterkte (A bepaald uit witte ruis bij 10 Hz)
A_ref = U_white_ref * f_cutoff;  % Voor de referentie
A_opamp = U_white_opamp * f_cutoff;  % Voor de opamp

% Nieuwe cutoff frequentie gebaseerd op de bovenste grens van 5 Hz
f_cutoff_new = min(f_cutoff, f_high);

% Integreer 1/f-ruis voor zowel de referentie als de opamp
U_n_ref_flicker_new = integrate_flicker_noise(f_low_ref, f_cutoff_new, A_ref);
U_n_opamp_flicker_new = integrate_flicker_noise(f_low_opamp, f_cutoff_new, A_opamp);

% Aangepaste totale ruis (alleen flicker noise tot de nieuwe cutoff)
U_n_ref_total_new = U_n_ref_flicker_new;  % Geen witte ruis boven 5 Hz
U_n_opamp_total_new = U_n_opamp_flicker_new;  % Geen witte ruis boven 5 Hz

% Stroomruis omrekenen (spanningsruis gedeeld door weerstand)
I_n_ref_total_new = U_n_ref_total_new / R;
I_n_opamp_total_new = U_n_opamp_total_new / R;

% Thermische ruis van de weerstand
I_n_resistor = sqrt(4 * k_B * T / R);

% Totale stroomruis kwadratisch optellen inclusief weerstand
I_n_total_input = sqrt(I_n_ref_total_new^2 + I_n_opamp_total_new^2 + I_n_resistor^2);

SNR = 20*log10(I_sensor/I_n_total_input);

% Resultaten weergeven
disp(['Stroomruis van de spanningsreferentie: ', num2str(I_n_ref_total_new), ' A/sqrt(Hz)']);
disp(['Stroomruis van de opamp: ', num2str(I_n_opamp_total_new), ' A/sqrt(Hz)']);
disp(['Thermische stroomruis van de weerstand: ', num2str(I_n_resistor), ' A/sqrt(Hz)']);
disp(['Totale stroomruis: ', num2str(I_n_total_input), ' A/sqrt(Hz)']);
disp(['SNR:', num2str(SNR), 'dB']);
