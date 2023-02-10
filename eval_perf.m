StopTime = '0.001';

%%% PARAMETRES FIXES %%%
Te = 4.0181e-08;
prefix_len = 12;

path_delays = [0 Te 10*Te];
path_gains = [0 -3 -6];

%%% SERIE MESURES 1 : VARIATION DE LA TAILLE DE l'IFFT %%%
pilots_rate = 0.125;
res1 = [0 0 0 ; 0 0 0 ; 0 0 0 ; 0 0 0 ; 0 0 0 ; 0 0 0 ; 0 0 0 ; 0 0 0 ; 0 0 0];
fprintf('==> SERIE MESURES 1, taux de pilotes fixé à %.3f\n\n', pilots_rate);
N_ST_arr = [64 128 256];
SNR_arr = [50 24 12];
for i = 1:length(N_ST_arr)
    for j = 1:length(SNR_arr)
        N_ST = N_ST_arr(i);
        SNR = SNR_arr(j);
        fprintf('RUN SIM : IFFT = %i | SNR = %i\n', N_ST, SNR);
        %%% NE PAS MODIFIER %%%
        N_SP = round( N_ST * pilots_rate );
        N_SD = N_ST - N_SP;
        TsOFDM = N_ST*Te;
        if N_SP ~= 0
            pilots_inter = floor( N_SD / N_SP );
        else
            pilots_inter = 2^8;
        end
        padding_len = 2^nextpow2(N_ST) - N_ST;
        out_data = N_SD - (N_SP-1)*pilots_inter;
        %%%%%%%%%%%%%%%%%%%%%%%
        
        simOut = sim('OFDM_model_v2020','SimulationMode','accelerator',...
                    'StopTime', StopTime);
        
        BER = simOut.BER.Data(end, 1);
        bitrate = 1 / ( ( ( N_ST + padding_len + prefix_len ) * Te ) / ( 2 * N_SD ) );

        E = N_ST / N_ST^2;

        res1(i, 1) = N_ST;
        res1(i, 2) = SNR;
        res1(i, 3) = BER;

        fprintf('   BER = %.2f %%\n', 100*BER);
        fprintf('   bitrate = %.2f Mb/s\n', (10e-6)*bitrate);
        fprintf('   E = %d\n', E);
        fprintf('   out_data = %i\n\n', out_data);
    end
end

%%% SERIE MESURES 2 : VARIATION DU TAUX DE PILOTES %%%
N_ST = 128;
fprintf('==> SERIE MESURES 2, taille IFFT fixée à %i\n\n', N_ST);
for pilots_rate = [0.125 0.25 0.5]
    for SNR = [50 24 12]
        fprintf('RUN SIM : pilots_rate = %.3f | SNR = %i\n', pilots_rate, SNR);

        %%% NE PAS MODIFIER %%%
        N_SP = round( N_ST * pilots_rate );
        N_SD = N_ST - N_SP;
        TsOFDM = N_ST*Te;
        if N_SP ~= 0
            pilots_inter = floor( N_SD / N_SP );
        else
            pilots_inter = 2^8;
        end
        padding_len = 2^nextpow2(N_ST) - N_ST;
        out_data = N_SD - (N_SP-1)*pilots_inter;
        %%%%%%%%%%%%%%%%%%%%%%%
        
        simOut = sim('OFDM_model_v2020','SimulationMode','accelerator',...
                    'StopTime', StopTime);
        
        BER = simOut.BER.Data(end, 1);
        bitrate = 1 / ( ( ( N_ST + padding_len + prefix_len ) * Te ) / ( 2 * N_SD ) );

        E = N_ST / N_ST^2;

        fprintf('   BER = %.2f %%\n', 100*BER);
        fprintf('   bitrate = %.2f Mb/s\n', (10e-6)*bitrate);
        fprintf('   E = %d\n', E);
        fprintf('   out_data = %i\n\n', out_data);
    end
end
