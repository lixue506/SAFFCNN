function yn = yn(n, m, alpha, T, N, h)
r = 0
for k = 0 : m - 1
   r += fai_k * ((n+1)*T/N)^k / factorial(k)
end

r += h^alpha/gamma(alpha+2)*f()
t =  1/gamma(alpha)*h^alpha/(alpha*(alpha+1))
for j = 0 : n
    if j==0
        r += t*n^(alpha+1)-(n-alpha)*(n+1)^alpha *f()
    elseif j>=1 || j<=n
        r += t * ((n-j+2)^(alpha+1) + (n-j)^(alpha+1)-2*(n-j+1)^(alpha+1))*f()
    else
        r += t*f()
    end
end
