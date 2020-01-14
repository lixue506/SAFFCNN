function vn1 = vn(n, m, delt)
if m == 1
    delt * ypn(n, m, alpha, T, N, h) + (1 - delt) * yn()
elseif m > 1
    delt * yn() + (1 - delt) * yn()
end
        