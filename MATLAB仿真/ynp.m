function ypn = ynp(n, m, alpha, T, N, h)
r = 0
for k = 0 : m - 1
    r += fai(k) * ((n+1)* T / N)^k / factorial(k)
end

for j = 0 : n
    r += 1/gamma(alpha) * (h^alpha/alpha) * ((n-j+1)^alpha - (n-j)^alpha) * f()    
end
