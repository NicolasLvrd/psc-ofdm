% Charger les échantillons
load samples.mat

% Définir la taille d'un demi-symbole L
L = 32;

samples = samples3;
t = length(samples);
T = 64*50e-9;
start = 1;
Ng = 3;
ds = 1;

% Initialiser à zéro
M = zeros(1, uint64((t/(2*L))+1));
P = zeros(1, uint64((t/(2*L))+1));
R = zeros(1, uint64((t/(2*L))+1));
M1 = zeros(1, uint64((t/(2*L))+2*L+1));
Mf = zeros(1, uint64((t/(2*L))+1));
Rf = zeros(1, uint64((t/(2*L))+1));
phi = zeros(1, uint64((t/(2*L))+1));
offset = zeros(1, uint64((t/(4000*L))+1));
compt = 1;
res=zeros(1, uint64((t/(2*L))+1));

% Transposer les échantillons pour les mettre en ligne
samples = samples.';



% Calculer la métrique M(d) pour chaque valeur de décalage d
for d = start:t-2*L
    % calculer la corrélation entre les échantillons d et d+L
    P(compt) = sum(samples(d+L+1:d+L+L) .* conj(samples(d+1:d+L)));
    % normaliser la corrélation par l'énergie du demi-symbole
    R(compt) = sum(abs(samples(d+1+L:d+L+L)).^2);
    Rf(compt)=(1/2)*(sum(abs(samples(d:d+63).^2)));
    % vérifier que corr et energy ne sont pas égaux à zéro
    if P(compt) ~= 0 && R(compt) ~= 0
        M(compt) = abs(P(compt)).^2 ./ R(compt).^2;
    else
        M(compt) = 0;
        disp(['corr = ', num2str(P(compt)), ' energy = ', num2str(R(compt)), ' for d = ', num2str(d), ' taille = ', num2str(t)])
    end
    if P(compt)~=0 && Rf(compt) ~=0
         Mf(compt) = abs(P(compt)).^2 ./ Rf(compt).^2;
    else
         Mf(compt) = 0;
    end

    if d>12 
        M1(compt)=(1/(Ng+1))*sum(Mf(d-Ng : d));
        %if M1(compt) > M1(res)
         %  res = compt;
        %end
    end
    
    if d > 2000*ds
        res = 1;
        for i = (2000*(ds-1))+1:(2000*(ds))+1
            if M1(i) > M1(res)
                res = i;
            end
        end
        
        offset(ds) = angle(P(res))/(pi*T); 
        ds = ds + 1;
    end
    
    compt = compt+1;
end

res2 = find(M1 == max(M1));
deltaf = median(offset(~isnan(offset)));

test = angle(P(29986));
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
