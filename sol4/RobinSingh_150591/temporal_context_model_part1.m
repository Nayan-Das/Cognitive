clear;
% the temporal context model assumes that the past becomes increasingly
% dissimilar to the future, so that memories become harder to retrieve the
% farther away in the past they are
%%
N_WORLD_FEATURES = 5;
N_ITEMS = 10;
ENCODING_TIME = 500;
TEST_TIME = 20;

% we are going to model the world as a set of N continuous-valued features.
% we will model observations of states of the world as samples from N
% Gaussians with time-varying means and fixed variance. For simplicity,
% assume that agents change nothing in the world.

% first fix the presentation schedule; I'm assuming its random

schedule = [sort(round(rand(1,N_ITEMS)*ENCODING_TIME))' (1:N_ITEMS)'];
schedule_load = ENCODING_TIME/median(diff(schedule(:,1)));                  %(median encoding load will be large if time between presentations is small)
encoding = zeros(N_ITEMS,N_WORLD_FEATURES+1);

world_m = [1 2 1 2 3];                                                      % can generate randomly for yourself world mean
world_var = 1;                                                              % world variance which is fixed to 1
delta = 0.05;                                                               % rate of drift over time
beta_param = 0.001;                                                         % context drift parameter i.e from slides (ct := beta*c_t + c_t-1) it will reduce
                                                                            % the world mean in every iteration
%% simulating encoding

m = 1;
for time = 1:ENCODING_TIME
    world_m = world_m + delta;
%     world_m = beta_param*world_m + delta;                                 % not used as it will reduce world_m very fast
    world = normrnd(world_m, world_var);
    % any item I want to encode in memory, I encode in association with the
    % state of the world at that time.
    if(m<(N_ITEMS+1))
        if(time==schedule(m,1))
            encoding(m,:) = [world m];                                      % encoding using concatenation of world context and item itself                                            
            m =  m + 1;
        end;  
    end;
end;

%% Retrieval

% simulating retrieval using SAM, but with a bijective image-item mapping
out = zeros(1,TEST_TIME);
while(time<ENCODING_TIME+TEST_TIME)
% the state of the world is the retrieval cue
    world_m = world_m + delta;
%     world_m = beta_param*world_m + delta;                                 % not used as it will reduce world_m very fast
    world = normrnd(world_m, world_var);                                    % model world evolution

    soa = zeros(1,N_ITEMS);
    for m = 1:N_ITEMS
        soa(m) = encoding(m,:)*transpose([world,m]);                        % finding association strengths using encoding and current context
    end;
    soa = soa/norm(soa);                                                    % normalize using L-2 norm
    out(time-ENCODING_TIME+1) = find(drawFromADist(soa));
    time = time + 1;       
end;

success = length(unique(out));                                              % success is number of unique retrievals
fprintf('No. of Correct Retrievals: %d/10\n', success)
% humans can retrieve about 7 items effectively from memory. get this model
% to behave like humans