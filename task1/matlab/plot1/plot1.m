function [  ] = plot1(  )

figure(1);
hold on;
for l=1:10
    [N]=Copy_of_MM1(l,10);
    plot(l,N,'rx','LineWidth',5);
end

end

