function [outSig] = throughChannel_OneRay_TimeSig(inSig, sampleRate, powerLoss_dB, delay_ns, freqShift_Hz, randomPhase_rad)
%THROUGHTCHANNEL_ONERAY_TIMESIG 此处显示有关此函数的摘要
%   此处显示详细说明

    scaler = db2mag(0 - powerLoss_dB);
    outSig_scale = scaler * inSig;
    
    %%% consider the fraction delay.
    %delay_sample = (delay_ns * 1e-9) * sampleRate;
    %fractionFilter = designCDLPathDelayFilters(delay_sample);
    %fractionFilter = fractionFilter ./ norm(fractionFilter);
    
    %%% ignore the fraction delay.
    delay_n = fix((delay_ns * 1e-9) * sampleRate);
    fractionFilter = [zeros(1,delay_n) 1];
    
    outSig_delay = conv(outSig_scale, fractionFilter);
    outSig_delay = outSig_delay(1:size(inSig,2));
    
    timeStamp = ((1:size(inSig,2)) - 1)/sampleRate;
    phaseChange = exp(1i*(randomPhase_rad + 2*pi*freqShift_Hz*timeStamp));
    outSig = outSig_delay .* phaseChange;
end

