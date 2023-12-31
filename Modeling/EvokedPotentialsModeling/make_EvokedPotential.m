function [args_out] = make_EvokedPotential(stim,CFs,wts,UR,UR_fs)


% add 2018 and a switch to use either models 
        [p_ihcout_s, p_hsr_s, p_lsr_s, p_ic_s, p_gain_s] = sim_efferent_model(stim,CFs);
        [n_ihcout_s, n_hsr_s, n_lsr_s, n_ic_s, n_gain_s] = sim_efferent_model(-stim,CFs);

        % we should explore this window 
        win=[0.1,0.9];



        %reshape to a new sample rate, only considering HSRs for now.
        ap_psth_env_full = (p_hsr_s+n_hsr_s)/2;
        ap_psth_env_full=ap_psth_env_full';
        ap_psth_env_ic_full = (p_ic_s+n_ic_s)/2;
        ap_psth_env_ic_full=ap_psth_env_ic_full';

        % we should define ap_psth_env and ap_psth_env_ic

psthbins=10;
for i=1:length(CFs)
    ap_psth_env(:,i) = sum(reshape(ap_psth_env_full(:,i),psthbins,length(ap_psth_env_full(:,i))/psthbins)); 
    ap_psth_env_ic(:,i)= sum(reshape(ap_psth_env_ic_full(:,i),psthbins,length(ap_psth_env_ic_full(:,i))/psthbins)); 
end
        

       fs_efr = 100e3/psthbins; %model sample rate/bins  

        %normalized
        an_cap = sum(ap_psth_env(win(1)*fs_efr:win(2)*fs_efr,:),2);
        an_cap = an_cap/max(an_cap);
        an_cap = an_cap-mean(an_cap);


        ic_cap = sum(ap_psth_env_ic(win(1)*fs_efr:win(2)*fs_efr,:),2);
        ic_cap = ic_cap/max(ic_cap);
        ic_cap = ic_cap-mean(ic_cap);

        %TODO: convolve with click later???

        comb_cap = wts(1).*an_cap + wts(2).*ic_cap;
        UR=resample(UR,fs_efr,UR_fs);
        UR=UR-mean(UR);
        convout=conv(comb_cap, UR);

        args_out.convout = convout;
        args_out.ic_cap = ic_cap;
        args_out.an_cap = an_cap;
        args_out.comb_cap = comb_cap;
        args_out.fs_cap = fs_efr;

end