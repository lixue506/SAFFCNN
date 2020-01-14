function yn=yn(h,alph,m)
tmp = 0
tmmp = 0
for i=0:m-1
    if i==0
        tmp= tmp + fai(i)*(t+n*h+h)^i
    else
        tmp= tmp + fai(i)*(t+n*h+h)^i/factorial(i)
    end
end
for j=0:n:
    tmmp = tmmp + a(h,alpha,n+1,j)*f()
end
yn = h^alpha*f()/gamma(alpha+2) + tmp + tmmp/gamma(alpha)
end