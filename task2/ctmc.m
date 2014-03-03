function [ ] = ctmc( States, l, m, Lambda )

format short
%%%%%%%%%%%p0
P = zeros(1, States);  
times_visited = zeros(1, States);
final_state = 0;
transition_number = 0;
%%%%%%% event_list init %%%%%
Event_List=zeros(3,1);
Event_List(1,1) = 1; %event1 transition
Event_List(2,1) = 0; %T=0
Event_List(3,1) = 1; %state 1
%Event_List
%%%%%%%%%%%

%%% transition table init %%%
Q = zeros(States, States);
for line = 1 : States
    for col = 1 : States
        
        if line == 1
            if col == 1
                Q(line, col) = -l;
            elseif col == 2
                Q(line, col) = l;
            end
        elseif line == States
            if col == States
                Q(line, col) = -m;
            elseif col == States - 1
                Q(line, col) = m;
            end
        end
        
        if line == col && (line ~= 1 && line ~= States)
            Q(line, col) = -(l + m);
            Q(line, col-1) = m;
            Q(line, col+1) = l;
        end
    end        
end
disp(Q)
%%%%%%%%%%%%%%%%%%
flag=true;
T=0;

while flag
    final_state = Event_List(3,1);
    disp('while')
    Event_List
    event=Event_List(1,1);
    
    if event==1
        disp('transition')
        transition_number = transition_number + 1;
        [T,Event_List, times_visited] =Event1(T,Event_List, States, Q, times_visited);
        
    elseif event==2
        disp('calc')
        [Event_List, P] = Event2(T, Event_List, P, Lambda, States, times_visited );
    
    elseif event==3
        disp('terminate')
        % Add Event3 here.
        [T,flag,Event_List]=Event3(T,flag,Event_List);        
    end
    Event_List(:,1)=[];
    %Event_List=(sortrows(Event_List',[2,1]))';
end

%%%%%%%%%%%%%%%%%%%%%%%%%RESULTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\nexecutions %d\n', transition_number);
fprintf('final state %d\n', final_state);
disp('state visits')
disp(times_visited)
end

function [T,Event_List, times_visited] =Event1(T,Event_List, States, Q, times_visited)
T=Event_List(2,1);
fprintf('time %d\n', T);
Event_List

if Event_List(3,1) == 1
    Event_List(1, end + 1) = 2; %first calcuclate
    Event_List(2, end) = T; %calc for the same time
    Event_List(3, end) = 2; %next state
    times_visited(Event_List(3,1)) = times_visited(Event_List(3,1)) + 1;
elseif Event_List(3,1) == States
    Event_List(1, end + 1) = 2; %first calcuclate
    Event_List(2, end) = T; %calc for the same time
    Event_List(3, end) = States - 1; %next state
    times_visited(Event_List(3,1)) = times_visited(Event_List(3,1)) + 1;
else
    left = Q(Event_List(3,1), Event_List(3,1) - 1)
    right = Q(Event_List(3,1), Event_List(3,1) + 1)
    if left < right
        Event_List(1, end + 1) = 2; %first calcuclate
        Event_List(2, end) = T; %calc for the same time
        Event_List(3, end) = Event_List(3,1) - 1; %next state
        times_visited(Event_List(3,1)) = times_visited(Event_List(3,1)) + 1;
    elseif left > right
        Event_List(1, end + 1) = 2; %first calcuclate
        Event_List(2, end) = T; %calc for the same time
        Event_List(3, end) = Event_List(3,1) + 1; %next state
        times_visited(Event_List(3,1)) = times_visited(Event_List(3,1)) + 1;
    end
    Event_List
end

end


function [Event_List, P] = Event2(T, Event_List, P, Lambda, States, times_visited )
T=Event_List(2,1);
fprintf('time : %d\n', T);

for i = 1 : States
    P(i) = times_visited(i) / sum(times_visited);
end

if P(1) == P(1:States)
   disp('steady state reached')
   Event_List(1,end + 1) = 3;
   Event_List(2,end) = T;
   Event_List(3,end) = Event_List(3,1);
   
else %no steady state yet
    disp('not yet')
    Event_List(1, end + 1) = 1;
    Event_List(2, end) = T + exprnd(Lambda);
    Event_List(3, end) = Event_List(3,1);
end

figure(1);
hold on;
plot(T, P, '.-');
xlabel('time');
ylabel('rate');


%Event_List
end


function [T,flag,Event_List]=Event3(T,flag,Event_List)

T=Event_List(2,1);
flag=false;
disp('Simulation End')

end
