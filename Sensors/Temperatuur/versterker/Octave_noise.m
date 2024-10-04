close all;
clear

%milivolt mv e-3
%micro volt uV e-6
%nano volt nV e-9

%pico ampere pA e-12
%femto ampere fA e-15

run('Octave_input_noise.m');

frequentie = logspace(-1, 7, 100000);
%stap = 1;
%frequentie = 1:stap:10e6; %beginwaarde : stapgrote : eindwaarde

%k = physconst('Boltzmann');
k = 1.380649e-23;  % Boltzmann constant in J/K
c = 55;
T = c + 273.15;



% source impedance %
R_source = 1e3;
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
broadband_voltage_noise = 15e-9;
%1 over F ruis op 1 Hz
voltage_noise_low = 60e-9;
%1 over F ruis
one_over_F_voltage_noise = (sqrt((voltage_noise_low)^2 - (broadband_voltage_noise)^2) ./ (frequentie));
%total
voltage_noise_amplifier = sqrt((one_over_F_voltage_noise).^2 + (broadband_voltage_noise)^2);
%Equivalent Current Input Noise from amplifier
current_noise_amplifier = 1e-15;
voltgage_current_noise = current_noise_amplifier .* source_impedance;
%Voltage Input Noise from Feed_back_resitor
Feed_back_resitor = 972;
Noise_Feed_back_resitor = sqrt(4 * k * T * Feed_back_resitor);
%Input Noise
Input_Noise = sqrt(4 * k * T * R_source + (I_n_total_input*1194).^2)
%total Voltage Input Noise from amplifier
total_voltage_noise_input = sqrt((voltage_noise_amplifier).^2 + (voltgage_current_noise).^2 + (Input_Noise).^2 + (Noise_Feed_back_resitor).^2);
%output noise amplifier
output_noise_amplifier = total_voltage_noise_input .* transfer_amplifier;

%noise plot
loglog(frequentie, output_noise_amplifier);
hold on
%loglog(frequentie, total_voltage_noise_input);
%hold on

xlabel('frequentie Hz');
ylabel('v/sqrt(Hz)');
%legend('input noise amplifier','resitor input noise','voltgage current noise','total noise input');
grid on;
pause;


