function [  ] = plot1( )

figure(1);
hold on;

for l=1:10
    [N] = MMm(l,10,1);
    plot(l,N,'rx','LineWidth',5);
end

for l=1:10
    [N] = MMm(l,10,2);
    plot(l,N,'kx','LineWidth',5);
end

for l=1:10
    [N] = MMm(l,10,5);
    plot(l,N,'gx','LineWidth',5);
end

for l=1:10
    [N] = MMm(l,10,10);
    plot(l,N,'bx','LineWidth',5);
end

end

