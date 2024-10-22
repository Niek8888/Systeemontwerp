close all;
clear

%milivolt mv e-3
%micro volt uV e-6
%nano volt nV e-9

%pico ampere pA e-12
%femto ampere fA e-15

f_high = 1;  % Bovenste frequentiegrens voor de berekeningen
% de sensor heeft een regeltijd van 10 Seconden in een omgeving waar het waait met 1 m/s

run('Octave_input_noise.m');

low_voltage_sensor = I_sensor * 980 * 52 * 4;
high_voltage_sensor = I_sensor * 1194 * 52 * 4;
voltage_sensor = high_voltage_sensor - low_voltage_sensor;
voltage_ADC = 3.3;
bit_resolution = voltage_ADC/(2^12);


frequentie = logspace(-1, 7, 100000);
%stap = 1;
%frequentie = 1:stap:10e6; %beginwaarde : stapgrote : eindwaarde

%k = physconst('Boltzmann');
k = 1.380649e-23;  % Boltzmann constant in J/K

% source impedance %
R_source = 1180;
source_impedance = R_source;

% Pre-amp %
%overdracht amplifier
gain = 52; %versterking van amplifier
fc = 350e3; %cutoff frequentie amplifier
R = 1;
C = 1 / (2 * pi * R * fc);

H = 1 ./ sqrt(1 + (frequentie * 2 * pi * R * C).^2 );
transfer_amplifier = H * gain;
%semilogx(frequentie,H);

%Equivalent Voltage Input Noise from amplifier
%Breedbandruis
broadband_voltage_noise = 30e-9;
%1 over F ruis op 1 Hz
voltage_noise_low = 40e-9;
%1 over F ruis
one_over_F_voltage_noise = (sqrt((voltage_noise_low)^2 - (broadband_voltage_noise)^2) ./ (frequentie));
%total
voltage_noise_amplifier = sqrt((one_over_F_voltage_noise).^2 + (broadband_voltage_noise)^2);
%Equivalent Current Input Noise from amplifier
current_noise_amplifier = 1e-13;
voltgage_current_noise = current_noise_amplifier .* source_impedance;
%Voltage Input Noise from Feed_back_resitor
Feed_back_resitor = 972;
Noise_Feed_back_resitor = sqrt(4 * k * T * Feed_back_resitor);
%Input Noise
Input_Noise = sqrt(4 * k * T * R_source + (I_n_total_input*1194).^2);
%total Voltage Input Noise from amplifier
total_voltage_noise_input = sqrt((voltage_noise_amplifier).^2 + (voltgage_current_noise).^2 + (Input_Noise).^2 + (Noise_Feed_back_resitor).^2);
%output noise amplifier
output_noise_amplifier = total_voltage_noise_input .* transfer_amplifier;




%overdracht amplifier
gain_2 = 4; %versterking van amplifier
fc = 350e3; %cutoff frequentie amplifier
R = 1;
C = 1 / (2 * pi * R * fc);

# geen idee wat dit is moet ik nog uitzoeken
source_impedance = 10;

H_2 = 1 ./ sqrt(1 + (frequentie * 2 * pi * R * C).^2 );
transfer_amplifier_2 = H_2 * gain_2;

%Equivalent Voltage Input Noise from amplifier
%Breedbandruis
broadband_voltage_noise = 30e-9;
%1 over F ruis op 1 Hz
voltage_noise_low = 40e-9;
%1 over F ruis
one_over_F_voltage_noise = (sqrt((voltage_noise_low)^2 - (broadband_voltage_noise)^2) ./ (frequentie));
%total
voltage_noise_amplifier = sqrt((one_over_F_voltage_noise).^2 + (broadband_voltage_noise)^2);
%Equivalent Current Input Noise from amplifier
current_noise_amplifier = 1e-13;
voltgage_current_noise = current_noise_amplifier .* source_impedance;
%Voltage Input Noise from Feed_back_resitor
Feed_back_resitor = 16500;
Noise_Feed_back_resitor = sqrt(4 * k * T * Feed_back_resitor);
%Input Noise
Input_Noise = sqrt((output_noise_amplifier).^2 + (U_n_ref_total_new).^2);
%total Voltage Input Noise from second amplifier
total_voltage_noise_input_2 = sqrt((voltage_noise_amplifier).^2 + (voltgage_current_noise).^2 + (Input_Noise).^2 + (Noise_Feed_back_resitor).^2);
%output noise second amplifier
output_noise_amplifier_2 = total_voltage_noise_input_2 .* transfer_amplifier_2;

output_noise_rc = (1 ./ sqrt(1 + (frequentie * 2 * pi * 1 * (1 / (2 * pi * 1 * 10))).^2 )) .* output_noise_amplifier_2 .* (1 ./ sqrt(1 + (frequentie * 2 * pi * 1 * (1 / (2 * pi * 1 * 5e5))).^2 ));

% Maak een interpolatiefunctie van output_noise_amplifier_2 afhankelijk van frequentie
output_noise_func = @(f) interp1(frequentie, output_noise_rc, f, 'linear');

Ruis_vermogen = integral(output_noise_func, 0.1, f_high);
SNR_versterker = 20 * log10(voltage_sensor/Ruis_vermogen);

disp(['Spanningsbereik van de uitgang sensor ', num2str(voltage_sensor), ' V']);
disp(["Spanning van de temperatuur:" num2str(voltage_sensor/600), "V / 0.1 graden Celcius"]);
disp(['Spanning resulotie van de bits ', num2str(bit_resolution), ' V']);
disp(['Totale spannings ruis integreed over de bandbreedte: ', num2str(Ruis_vermogen), ' V']);
disp(['SNR van het totale systeem: ', num2str(SNR_versterker), ' dB']);

loglog(frequentie, output_noise_rc);
hold on
%loglog(frequentie, total_voltage_noise_input);
%hold on

xlabel('frequentie Hz', "fontsize", 40);
ylabel('v/sqrt(Hz)', "fontsize", 40);
set(gca, 'FontSize', 40);  % aanpassing voor de eenheidstapjes (ticks)
grid on;
pause;
