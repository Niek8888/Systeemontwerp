close all;
clear

%milivolt mv e-3
%micro volt uV e-6
%nano volt nV e-9

%pico ampere pA e-12
%femto ampere fA e-15

%frequentie = logspace(-1, 7, 100000);
stap = 1;
%frequentie = 1:stap:10e3; %beginwaarde : stapgrote : eindwaarde
frequentie = 99
%k = physconst('Boltzmann');
k = 1.380649e-23;  % Boltzmann constant in J/K
c = 55;
T = c + 273,15;

% source impedance %
R_source = 12e3;
source_impedance = R_source;

if frequentie <= 10
    one_over_f_noise_current_opamp = 260e-9
elseif frequentie <= 200
    one_over_f_noise_current_opamp = 85e-9  % 85 nV/√Hz
elseif frequentie <= 2000
    one_over_f_noise_current_opamp = 85e-9 * exp(-0.002 * (frequentie - 100))  % exponential drop between 100 and 1kHz
else
    one_over_f_noise_current_opamp = 30e-9 * exp(-0.001 * (frequentie - 1000))  % further decay beyond 1kHz
end
% dit laten checken door stijn
noise_current_opamp_current = 0;


% Pre-amp %
%overdracht amplifier
gain = 52; %versterking van amplifier
fc = 350e3; %cutoff frequentie amplifier

R = 1;
C = 1 / (2 * pi * R * fc);

H = 1 ./ sqrt(1 + (frequentie * 2 * pi * R * C).^2 );
transfer_amplifier = H * gain;
%semilogx(frequentie,H);

%output noise amplifier
output_noise_amplifier = one_over_f_noise_current_opamp .* transfer_amplifier;
S_un = 24000 * 4 * k * T
Un_eff_opamp = S_un * (5 + 0.01 * log(10/1000))
Un_eff_V_ref = S_un * (5 + 0.1 * log(10/1000))

Un_eff_2 = Un_eff_opamp + Un_eff_V_ref
Un_eff = sqrt(Un_eff_2)
In_eff = Un_eff/24000^2



%noise plot
semilogx(frequentie, one_over_f_noise_current_opamp);
%hold on
%loglog(frequentie, total_voltage_noise_input);
hold on




xlabel('frequentie Hz');
ylabel('v/sqrt(Hz)');
%legend('input noise amplifier','resitor input noise','voltgage current noise','total noise input');
grid on;
%pause;
