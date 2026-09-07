clc;
clear;
close all;

s = tf('s');

% -------------------------------
% Plant
% -------------------------------
G = (978 - 0.0255*s)/(2.87e-7*s^2 + 1.695e-4*s + 6.5);

% -------------------------------
% CORRECT PI Controller
% -------------------------------
Kp = 0.00106;
Ki = 1.065;

Gc = Kp + Ki/s;

% -------------------------------
% Open-loop
% -------------------------------
Gol = Gc * G;

figure;
margin(Gol);
grid on;
title('Correct Bode Plot (with RHP constraint)');

% -------------------------------
% Closed-loop
% -------------------------------
T = feedback(Gc*G,1);

% -------------------------------
% Step Response Comparison
% -------------------------------
t = 0:1e-5:0.02;
Vref = [64 75 85];

figure;

for i = 1:length(Vref)

    y_open = Vref(i)*step(G,t);
    y_closed = Vref(i)*step(T,t);

    subplot(3,1,i)
    plot(t,y_open,'r--','LineWidth',1.5); hold on;
    plot(t,y_closed,'b','LineWidth',1.5);

    title(['V_{ref} = ', num2str(Vref(i)), ' V'])
    legend('Open Loop','Closed Loop')
    grid on;

end

% -------------------------------
% Display PM & GM
% -------------------------------
[GM, PM, Wcg, Wcp] = margin(Gol);

fprintf('\n--- CORRECT DESIGN ---\n');
fprintf('Gain Margin = %.2f dB\n',20*log10(GM));
fprintf('Phase Margin = %.2f deg\n',PM);