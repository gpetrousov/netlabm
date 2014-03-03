function [  ] = plot2( )

figure(1);
hold on;

for m=1:10
    [R] = MMm(1,m,1);
    plot(m,R,'rx','LineWidth',5);
end

for m=1:10
    [R] = MMm(1,m,2);
    plot(m,R,'kx','LineWidth',5);
end

for m=1:10
    [R] = MMm(1,m,5);
    plot(m,R,'gx','LineWidth',5);
end

for m=1:10
    [R] = MMm(1,m,10);
    plot(m,R,'bx','LineWidth',5);
end

end

