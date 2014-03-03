function [ ] = dtmc( States )

format long
%%%%%%%%%%%p0
p_next = zeros(1, States); %pn next vector 
p_cur = zeros(1, States); %p0 initial vector
disp('give p0 initial vector')
for i = 1:States
    p_cur(i) = input('');
end
%%%%%%%%%%%%%%%%%

%%%%%%% event_list init %%%%%
Event_List=zeros(3,1);
Event_List(1,1) = 1; %event1 transition
Event_List(2,1) = 0; %T=0
Event_List(3,1) = 1; %state 1
%Event_List
%%%%%%%%%%%

%%% transition table init %%%
P = zeros(States, States);
for line = 1 : States
    fprintf('probabilities for staion %d\n', line);
    for row = 1 : States
        P(line, row) = input('');
    end        
end
disp(P)
%%%%%%%%%%%%%%%%%%

flag=true;
T=0;

while flag
    event=Event_List(1,1);
    
    if event==1
        disp('transition')
        [T,Event_List,p_cur,p_next ]=Event1(T,Event_List, States, P, p_cur, p_next);
        
    elseif event==2
        disp('calc')
        [Event_List, p_cur, p_next ] = Event2(T, Event_List, p_cur, p_next );
    
    elseif event==3
        disp('terminate')
        % Add Event3 here.
        [T,flag,Event_List]=Event3(T,flag,Event_List);        
    end
    Event_List(:,1)=[];
    %Event_List=(sortrows(Event_List',[2,1]))';
end

%%%%%%%%%%%%%%%%%%%%%%%%%RESULTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nprobability vector ');
disp(p_cur)
fprintf('execution times %d\n', T);
end

function [T,Event_List,p_cur,p_next ]=Event1(T,Event_List, States, P, p_cur, p_next)
T=Event_List(2,1);
fprintf('time %d\n', T);
%%Event_List

transition = rand();
probability_sum = 0;

for each_state = 1 : States %next state
    probability_sum = probability_sum + P( Event_List(3,1), each_state );
    if transition <= probability_sum
        Event_List(1, end + 1) = 2; %first calcuclate
        Event_List(2, end) = T; %calc for the same time
        Event_List(3, end) = each_state; %next state
        break
    end
end

p_next = p_cur * P';


%Event_List
end


function [Event_List, p_cur, p_next ] = Event2(T, Event_List, p_cur, p_next )
T=Event_List(2,1);
fprintf('time : %d\n', T);

%p_cur
%p_next
%p_cur == p_next
%Event_List
if p_cur == p_next
   disp('steady state reached')
   Event_List(1,end + 1) = 3;
   Event_List(2,end) = T;
   Event_List(3,end) = Event_List(3,1);
   
else %no steady state yet
    disp('not yet')
    p_cur = p_next;
    Event_List(1, end + 1) = 1;
    Event_List(2, end) = T + 1;
    Event_List(3, end) = Event_List(3,1);
end

figure(1);
hold on;
for i=1:length(p_cur)
    %plot(T, p_cur(i), '-');    
    %plot(T, p_cur(i), '-o');
    plot(T, p_cur(i), '.-');
    %plot(T, p_cur(i), '.');  
    xlabel('time');
    ylabel('probability');
end
%Event_List
end


function [T,flag,Event_List]=Event3(T,flag,Event_List)

T=Event_List(2,1);
flag=false;
disp('Simulation End')

end
