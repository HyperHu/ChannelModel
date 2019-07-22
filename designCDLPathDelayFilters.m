function [pathFilters] = designCDLPathDelayFilters(pathDelays)
    % calculate integer part 'n' and fractional part 'rho' of path delays
    channelFilterDelay = 10;
    Astop = 70.0;
    n = fix(pathDelays);
    rho = mod(pathDelays,1);
    assert(n >= channelFilterDelay);
    
    % for each fractional delay 'rho', design filter coefficients 'h'
    h = designFractionalDelay(rho, 0.0001, channelFilterDelay, Astop);
    
    % delay filter coefficients according to integer path delays
    pathFilters = [zeros(1,n-channelFilterDelay+1) h];
end

function weights = designFractionalDelay(fd,approxError,NP,Astop)
    L = ceil(1/(2*approxError));

    [~,phaseIdx] = min(abs(bsxfun(@minus,fd,1-(0:L)/L)),[],2);

    b = designMultirateFIR(L,1,NP,Astop);

    p = reshape(b,L,[]);

    if (phaseIdx == L+1)
        % zero fractional delay
        weights = zeros(1,NP*2);
        weights(NP) = 1;
    else
        weights = p(phaseIdx,:);
    end
end
