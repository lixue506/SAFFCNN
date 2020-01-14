function a=a(h,alpha,n,j)
    if j==0
        a = h^alpha*(n^(alpha+1)-(n-alpha)*(n+1)^alpha)/(alpha*(1+alpha))
    elseif j>=1 && j<=n
            a = h^alpha*((n-j+2)^(alpha+1)+(n-j)^(alpha+1)-2*(n-j+1)^(alpha+1))/(alpha*(1+alpha))
    else
        a = h^alpha/(alpha*(alpha+1))
    end
end