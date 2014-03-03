function [  ] = plot2(  )

figure(2);
hold on;
for m=1:10
    [R]=Copy_of_MM1(1,m);
    plot(m, R, 'rx','LineWidth', 5);
end

end

