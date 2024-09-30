close all;
clear

% Parameters
A_white = 0.6e-6; % Witte ruis in V/√Hz
A_2 = 1.6e-6; % Ruiswaarde van 0.1 tot 10 Hz in V/√Hz
K = A_2 - A_white; % Bepaal K

% Frequenties instellen
f = logspace(-1, 1, 100); % Frequenties van 0.1 tot 10 Hz in logaritmische schaal

% Ruisberekening
R_f = A_white + K ./ f; % Totale ruis

% Plotten
figure;
semilogx(f, R_f * 1e6); % Plot in µV/√Hz
xlabel('Frequentie (Hz)');
ylabel('Ruis (µV/√Hz)');
title('1/f Ruis Model');
grid on;

