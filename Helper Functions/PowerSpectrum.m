function [f, p] = PowerSpectrum(timeseries, Fs)

    if size(timeseries, 1) < size(timeseries, 2)
        timeseries = timeseries';
    end
    
    p = [];
    L = size(timeseries, 1);

    for i = 1:size(timeseries, 2)
        NFFT = 2^nextpow2(L); % Next power of 2 from length of eegF
        Y = fft(double(timeseries(:, i)), NFFT) / L;
        f = Fs / 2 * linspace(0, 1, (NFFT / 2) + 1);
        p = [p, medfilt1(2 * abs(Y(1: (NFFT/2) + 1)), 3)];
    end
end




