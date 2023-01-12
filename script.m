% Charger les échantillons
load samples.mat

% Définir la taille d'un demi-symbole L
L = 32;

samples = samples1;
t = length(samples);

% Initialiser à zéro
M = zeros(1, uint64((t/(2*L))+1));
P = zeros(1, uint64((t/(2*L))+1));
R = zeros(1, uint64((t/(2*L))+1));
compt = 1;

% Transposer les échantillons pour les mettre en ligne
samples = samples.';



% Calculer la métrique M(d) pour chaque valeur de décalage d
for d = 0:t-2*L
    % calculer la corrélation entre les échantillons d et d+L
    P(compt) = sum(samples(d+L+1:d+L+L) .* conj(samples(d+1:d+L)));
    % normaliser la corrélation par l'énergie du demi-symbole
    R(compt) = sum(abs(samples(d+1+L:d+L+L)).^2);
    % vérifier que corr et energy ne sont pas égaux à zéro
    if P(compt) ~= 0 && R(compt) ~= 0
        M(compt) = abs(P(compt)).^2 ./ R(compt).^2;
    else
        M(compt) = 0;
        disp(['corr = ', num2str(P(compt)), ' energy = ', num2str(R(compt)), ' for d = ', num2str(d), ' taille = ', num2str(t)])
    end
    compt = compt+1;
end

% Afficher la métrique M(d)
stem(M);
title('M');
