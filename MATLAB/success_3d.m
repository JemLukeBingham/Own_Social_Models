%SIMPLIFY AND TEST
clc
clear all
syms n1 n2 n1c n1d n2c n2d beta1 beta2 alpha1 alpha2 b c T;

m=n1;
n2 = 1-n1;
n1d=1-n1c;
n2d=1-n2c;
T=1;

p1c(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c)= n1*( n1c*(b-c)  +  n1d*(-c) )+(n2)*( n2c*beta1*beta2*alpha1*(b-c)  +  n2c*beta2*(1-beta1)*b  +  n2c*beta1*(1-beta2)*(-c) + n2d*beta1*(-c));
p1d(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c)= n1*( n1c*b ) + (n2)*( n2c*beta2*b );
p2c(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c) = (n2)*( n2c*(b-c) + n2d*(-c) ) + (n1)*( n1c*beta1*beta2*alpha2*(b-c) + n1c*(1-beta1)*beta2*(-c) + n1c*(1-beta2)*beta1*(b) + n1d*beta2*(-c));
p2d(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c) = (n2)*b*n2c + (n1) * n1c * beta1*(b);

p1bar(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c) = n1c*p1c(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c) + n1d*p1d(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c)
p2bar(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c) = n2c*p2c(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c) + n2d*p2d(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c);
pbar(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c) = n1*p1bar(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c)+n2*p2bar(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c);

n1cdot(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c)=n1c*(p1c-p1bar);
n2cdot(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c)=n2c*(p2c-p2bar);
n1dot(n1c,n2c,n1,beta1,beta2,alpha1,alpha2,b,c)=n1*T*(p1bar-pbar)

n1cnull=symfun(solve(n1cdot==0,n2c),[n1c,n1,beta1,beta2,alpha1,alpha2,b,c])
n2cnull=symfun(solve(n2cdot==0,n1c),[n2c,n1,beta1,beta2,alpha1,alpha2,b,c])

[n1star,n1cstar,n2cstar] = solve(n1dot==0,n1cdot==0,n2cdot==0,n1,n1c,n2c);

n1cstar=simplify(n1cstar)
n2cstar=simplify(n2cstar)
n1star =simplify(n1star)
defectionPoints = [];
extinctionPoints =[];
locationsOfInterest =[];
locationsOfParticularInterest=[];
totalCooperation=[];
partialCooperation=[];
problemPoints=[]
for fp=1:length(n1cstar)    
    if (n1star(fp)==0 | n1star(fp)==1)
        extinctionPoints=[extinctionPoints ; [fp,n1cstar(fp),n2cstar(fp),n1star(fp)]];
    elseif (n1cstar(fp) == 0 & n2cstar(fp) ==0 )
        defectionPoints = [defectionPoints ; [fp,n1cstar(fp),n2cstar(fp),n1star(fp)]];
    elseif (n1cstar(fp)~=0 & n2cstar(fp)~=0)
        if (n1cstar(fp)==1 & n2cstar(fp)==1)
            totalCooperation = [totalCooperation;[fp,n1cstar(fp),n2cstar(fp),n1star(fp)]];
        else
            partialCooperation = [partialCooperation;[fp,n1cstar(fp),n2cstar(fp),n1star(fp)]];
        end
        locationsOfParticularInterest = [locationsOfParticularInterest;[fp,n1cstar(fp),n2cstar(fp),n1star(fp)]];
    else
        locationsOfInterest = [locationsOfInterest;[fp,n1cstar(fp),n2cstar(fp),n1star(fp)]];
    end
end
extinctionPoints
defectionPoints
locationsOfInterest
partialCooperation
totalCooperation
locationsOfParticularInterest;
vars = [n1c,n2c,n1]
dots = [n1cdot,n2cdot,n1dot]
shayni = jacobian(dots,vars);
vecsAndlams=[];
for fp =14
    fp
    if fp==10 | fp ==12
        continue
    end
    location = [n1cstar(fp),n2cstar(fp),n1star(fp)]
    [veceasy,lameasy] = eig(shayni(n1cstar(fp),n2cstar(fp),n1star(fp),beta1,beta1,alpha1,alpha1,b,c))
    [vec,lam] = eig(shayni(n1cstar(fp),n2cstar(fp),n1star(fp),beta1,beta2,alpha1,alpha2,b,c))
    vec= simplify(vec,'steps',200)
    lam = simplify(lam,'steps',200)
end

%#one-dimensional
jacqui = jacobian(n1dot,n1)
n1star1dim11 = simple(solve(n1dot(1,1,n1,beta1,beta2,alpha1,alpha2,b,c)==0,n1))
n1star1dim10 = simple(solve(n1dot(1,0,n1,beta1,beta2,alpha1,alpha2,b,c)==0,n1))
n1star1dim01 = simple(solve(n1dot(0,1,n1,beta1,beta2,alpha1,alpha2,b,c)==0,n1))
n1star1dim00 = simple(solve(n1dot(0,0,n1,beta1,beta2,alpha1,alpha2,b,c)==0,n1))

lam110 = simple(eig(jacqui(1,1,0,beta1,beta2,alpha1,alpha2,b,c)))
lam111 = simple(eig(jacqui(1,1,1,beta1,beta2,alpha1,alpha2,b,c)))
lam11m = simple(eig(jacqui(1,1,n1star1dim11(3),beta1,beta2,alpha1,alpha2,b,c)))

lam100 = simple(eig(jacqui(1,0,0,beta1,beta2,alpha1,alpha2,b,c)))
lam101 = simple(eig(jacqui(1,0,1,beta1,beta2,alpha1,alpha2,b,c)))
lam10m = simple(eig(jacqui(1,0,n1star1dim10(3),beta1,beta2,alpha1,alpha2,b,c)))

lam010 = simple(eig(jacqui(0,1,0,beta1,beta2,alpha1,alpha2,b,c)))
lam011 = simple(eig(jacqui(0,1,1,beta1,beta2,alpha1,alpha2,b,c)))
lam01m = simple(eig(jacqui(0,1,n1star1dim01(3),beta1,beta2,alpha1,alpha2,b,c)))

lam000 = eig(jacqui(0,0,n1star1dim00,beta1,beta2,alpha1,alpha2,b,c))