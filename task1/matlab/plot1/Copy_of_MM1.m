function [N] = Copy_of_MM1(l,m)

Tprev = 0;
arrival = 0;
departe = 0;
%l = 3;
%m = 4;
flag = true;
T = 0; 
%N = 0; % Mesos arithmos pelatvn sto systima
%R = 0; % mesos xronos anamonis sto sistima
id = 0;
Q=zeros(2,0);
    
Event_List = zeros(2,4);
Event_List(:,1) = [ 1, 0 ];
Event_List(:,2) = [ 2, 0 ];
Event_List(:,3) = [ 3, 1 ];

sys_client_sum = 0;
sys_client_count = 0;

sys_time_sum = 0;
sys_time_count = 0;

q_client_sum = 0;
q_client_count = 0;

serv_client_sum = 0;
serv_client_count = 0;

q_time_sum = 0;
q_time_count = 0;

serv_time_sum = 0;
serv_time_count = 0;

while flag
    event = Event_List(1,1);
    
    if event == 1
        %disp('EV 1')
        [Q, Event_List, id, T, arrival] = arrivals(Q, Event_List, id, T, l,arrival);
    elseif event == 2
        %disp('EV 2')
        [T, Event_List, Q, sys_time_sum, sys_time_count,q_time_sum,q_time_count,serv_time_sum,serv_time_count, departe,Tprev] = departures( T, Event_List, Q, m, sys_time_sum, sys_time_count,q_time_sum,q_time_count,serv_time_sum,serv_time_count,departe, Tprev);
    elseif event == 3
        %disp('EV 3')
        [T, Event_List, sys_client_sum, sys_client_count, flag, q_client_sum, q_client_count, serv_client_sum, serv_client_count] = calc(T, Event_List, Q, sys_client_sum, sys_client_count, flag, q_client_sum,q_client_count, serv_client_sum, serv_client_count );
    end
    
    Event_List(:,1)=[];
    Event_List=(sortrows(Event_List',[2,1]))';
           
end % sim end
    
%results
N = sys_client_sum /sys_client_count;
R = sys_time_sum / sys_time_count;
fprintf('SIM:\naverage clients in system: %.3f\n',N);
avg_q = q_client_sum / q_client_count;
if avg_q < 0
    avg_q = 0;
end
fprintf('average clients in queue: %.3f\n', avg_q);
fprintf('average clients in server: %.3f\n', serv_client_sum/serv_client_count);   
fprintf('average time in system: %.3f\n', R);
fprintf('average time in queue: %.3f\n', q_time_sum/q_time_count);
fprintf('average time in server: %.3f\n', serv_time_sum/serv_time_count);
fprintf('total arrivals in system: %d\n', arrival); 
fprintf('total departures from system: %d\n', departe);
%LITLE 
%N = l/(m-l);
%R = 1/(m-l);
%fprintf('\nLITLE:\nN is %.3f and R is %.3f\n',N ,R);
   
end


function [Q, Event_List, id, T,arrival] = arrivals(Q, Event_List, id, T, l,arrival)
T = Event_List(2,1);
fprintf('arrival at %f\n', T);
L = size(Q);
id = id + 1;

Q(1,L(2)+1) = id;
Q(2,L(2)+1) = T;
arrival = arrival + 1;
    
Event_List(1,end+1)=1;
Event_List(2,end)=T+exprnd(1/l, 1, 1);
       
end


function [T, Event_List, Q, sys_time_sum, sys_time_count, q_time_sum,q_time_count,serv_time_sum,serv_time_count,departe, Tprev] = departures( T, Event_List, Q, m, sys_time_sum, sys_time_count,q_time_sum,q_time_count,serv_time_sum,serv_time_count,departe, Tprev)
T = Event_List(2,1);
fprintf('departure at %f\n', T);
L = size(Q);    
if L(2) > 0
    sys_time_sum  = sys_time_sum + T - Q(2,1);
    sys_time_count = sys_time_count + 1;
    
    if departe == 0 %first time only
        Tprev = T;
        serv_time_sum = T - Q(2,1);
        serv_time_count = serv_time_count + 1;
    else
        Tcur = T;
        serv_time_sum = serv_time_sum + Tcur - Tprev;
        Tprev = Tcur;        
        
        %serv_time_sum = serv_time_sum + T - Q(2,1);
        serv_time_count = serv_time_count + 1;
    end
    
    if L(2) > 1
    %q_time_sum = q_time_sum + T - Q(2,end); % this was initialy
        q_time_sum = q_time_sum + T - Q(2,2);
        q_time_count = q_time_count + 1;
    
    Q(:,1)=[];    
    departe = departe + 1;
else
    disp('No clients in Q')
end

%if L(2) > 1
    %q_time_sum = q_time_sum + T - Q(2,end);
%    q_time_sum = q_time_sum + T - Q(2,2);
%    q_time_count = q_time_count + 1;
end
    
Event_List( 1, end+1 ) = 2;
Event_List( 2, end ) = T + exprnd(1/m, 1, 1);
        
end


function [T, Event_List, sys_client_sum, sys_client_count, flag, q_client_sum, q_client_count, serv_client_sum, serv_client_count] = calc(T, Event_List, Q, sys_client_sum, sys_client_count, flag, q_client_sum,q_client_count, serv_client_sum, serv_client_count )
T = Event_List(2,1);

if sys_client_count == 0
    L = size(Q);
    
    q_client_sum = q_client_sum + L(2) - 1;
    q_client_count = q_client_count + 1;
    
    sys_client_sum = sys_client_sum + L(2);
    sys_client_count = sys_client_count + 1;
    
    if L(2) >= 1
        serv_client_sum = serv_client_sum + 1;
        serv_client_count = serv_client_count + 1;
    end
else
    N_prev = sys_client_sum / sys_client_count;
    
    fprintf('nprev = %f\n', N_prev);
    
    L = size(Q);
    %clients for queue
    q_client_sum = q_client_sum + L(2) - 1;
    q_client_count = q_client_count + 1;
    
    %clients for system
    sys_client_sum = sys_client_sum + L(2);
    sys_client_count = sys_client_count + 1;
    N_curr = sys_client_sum / sys_client_count;
    
    %clients for server
    if L(2) >= 1
        serv_client_sum = serv_client_sum + 1;
        serv_client_count = serv_client_count + 1;
    end
    
    fprintf('ncur %f\n', N_curr);
    
    if abs(N_prev - N_curr) < 0.0001
        flag = false;
        fprintf('\n\nsimulation end\n');
        return;
    end
end
    
Event_List(1, end+1) = 3;
Event_List(2, end) = T+1;
    
end
