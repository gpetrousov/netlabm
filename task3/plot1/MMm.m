function [N] = MMm( l,m,servers )

T=0;
flag=true;
Q=zeros(2,0);
counter_id=0;

Tprev = 0;
arrival = 0;
departe = 0;
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

available_servers=servers;
pending_clients=0;%clients that found the system busy

sum_delay=0;
number_delay=0;

Event_List=[1, 3; 0, 0];

while flag
    
    event=Event_List(1,1);
    
    if event==1
        T=Event_List(2,1);
        counter_id=counter_id+1;
        disp('Arrival at time')
        disp(T)
        disp('Client ID')
        disp(counter_id)
        disp('---------')
        Q(1,end+1)=counter_id;
        Q(2,end)=T;
        arrival = arrival + 1;
        if available_servers>0
            available_servers=available_servers-1;
            Event_List(1,end+1)=2;
            Event_List(2,end)=T+exprnd(1/m,1,1);
        else
           pending_clients=pending_clients+1;
        end
        Event_List(1,end+1)=1;
        Event_List(2,end)=T+exprnd(1/l,1,1);
        
    elseif event==2
        T=Event_List(2,1);
        L=size(Q);
        if ~isempty(Q)
            disp('Departure at time')
            disp(T)
            disp('Client ID')
            disp(Q(1,1))
            disp('---------')
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
                serv_time_count = serv_time_count + 1;
            end
            if L(2) > servers
                q_time_sum = q_time_sum + T - Q(2,servers+1);
                q_time_count = q_time_count + 1;
            end
            Q(:,1)=[];
            departe = departe + 1;
        end
       % available_servers
        if available_servers>=0 && pending_clients>0
            Event_List(1,end+1)=2;
            Event_List(2,end)=T+exprnd(1/m,1,1);
            pending_clients=pending_clients-1;
        else
            available_servers=available_servers+1;
        end
        
    elseif event ==3
        T = Event_List(2,1);
        disp('cacl at time')
        disp(T)
        disp('---------')
        L = size(Q);
        
        %cacl clients in queue-server
        if L(2) < servers
            clients_in_q = 0;
            clients_in_s = L(2);
        elseif L(2) == servers
            clients_in_q = 0;
            clients_in_s = servers;            
        elseif L(2) > servers
            clients_in_q = L(2) - servers;
            clients_in_s = servers;
        end
                
        if sys_client_count == 0
            L = size(Q);

            q_client_sum = q_client_sum + clients_in_q;
            q_client_count = q_client_count + 1;

            sys_client_sum = sys_client_sum + L(2);
            sys_client_count = sys_client_count + 1;

            if L(2) >= 1
                serv_client_sum = serv_client_sum + clients_in_s;
                serv_client_count = serv_client_count + 1;
            end
        else
            N_prev = sys_client_sum / sys_client_count;

            fprintf('nprev = %f\n', N_prev);

            L = size(Q);
            %clients for queue
            q_client_sum = q_client_sum + clients_in_q;
            q_client_count = q_client_count + 1;

            %clients for system
            sys_client_sum = sys_client_sum + L(2);
            sys_client_count = sys_client_count + 1;
            N_curr = sys_client_sum / sys_client_count;

            %clients for server
            if L(2) >= 1
                serv_client_sum = serv_client_sum + clients_in_s;
                serv_client_count = serv_client_count + 1;
            end

            fprintf('ncur %f\n', N_curr);

            if abs(N_prev - N_curr) < 0.0001
                flag = false;
                fprintf('\n\nsimulation end\n');
                %return;
            end
        end
        Event_List(1, end+1) = 3;
        Event_List(2, end) = T+1;

    end
    
    Event_List(:,1)=[];
    Event_List=sortrows(Event_List',2)';
end
%%%%%RESULTS%%%%%
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
        
end

