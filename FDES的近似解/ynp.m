function ypn = ynp(m,t,h,alpha,n)
tmmp = 0
tmp = 0
for i=0:m-1
    if i==0
        tmp= tmp + fai(i)*(t+n*h+h)^i
    else
        tmp= tmp + fai(i)*(t+n*h+h)^i/factorial(i)
    end
end
for j=0:n:
    tmmp = tmmp + b(h,alpha,n+1,j)*f()
end
ypn = tmp + tmmp/gamma(alpha)
end


   