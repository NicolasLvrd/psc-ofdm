% Charger les échantillons
load samples.mat

% Définir la taille d'un demi-symbole L
L = 32;

samples = samples1;
t = length(samples);
T = 64*50e-9;
start = 1;

% Initialiser à zéro
M = zeros(1, uint64((t/(2*L))+1));
P = zeros(1, uint64((t/(2*L))+1));
R = zeros(1, uint64((t/(2*L))+1));
M1 = zeros(1, uint64((t/(2*L))+2*L+1));
Mf = zeros(1, uint64((t/(2*L))+1));
Rf = zeros(1, uint64((t/(2*L))+1));
phi = zeros(1, uint64((t/(2*L))+1));
offset = zeros(1, uint64((t/(2*L))+1));
compt = 1;
res=1;
deltaf = 0;

% Transposer les échantillons pour les mettre en ligne
samples = samples.';



% Calculer la métrique M(d) pour chaque valeur de décalage d
for d = start:t-2*L
    % calculer la corrélation entre les échantillons d et d+L
    P(compt) = sum(samples(d+L+1:d+L+L) .* conj(samples(d+1:d+L)));
    % normaliser la corrélation par l'énergie du demi-symbole
    R(compt) = sum(abs(samples(d+1+L:d+L+L)).^2);
%%    Rf(compt)=(1/2)*(sum(abs(samples(d:d+63).^2)));
    % vérifier que corr et energy ne sont pas égaux à zéro
    if P(compt) ~= 0 && R(compt) ~= 0
        M(compt) = abs(P(compt)).^2 ./ R(compt).^2;
    else
        M(compt) = 0;
        disp(['corr = ', num2str(P(compt)), ' energy = ', num2str(R(compt)), ' for d = ', num2str(d), ' taille = ', num2str(t)])
    end
%%    if P(compt~=0 && Rf(compt ~=0))
%%         Mf(compt) = abs(P(compt)).^2 ./ Rf(compt).^2;
%%    else
%%         Mf(compt) = 0;
%%    end
%%    if compt>65
%%        M1(compt)=(1/(64+1))*sum(Mf(compt-64 : compt));
%%  
%%        if M1(compt)>M1(res)
%%            res = compt;
%%        end
   
%%        deltaf = angle(P(res))/(pi*T);
%%    end
    if M(compt)>0.99 && M(compt)<=1
        phi(compt) = angle(P(compt));
        offset(compt) = phi(compt)/(pi*T);
    end
    compt = compt+1;
end

test = phi(99949);
test2 = test/(pi*T);



% Afficher la métrique M(d)
subplot(3,1,1)
stem(M);
title('M');
subplot(3,1,2);
stem(offset);
title('offset');
subplot(3,1,3);
stem(phi);
title('phi');
