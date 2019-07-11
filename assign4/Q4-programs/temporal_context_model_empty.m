
clear;

% the temporal context model assumes that the past becomes increasingly
% dissimilar to the future, so that memories become harder to retrieve the
% farther away in the past they are

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
schedule_load = ENCODING_TIME/median(diff(schedule(:,1)));                  % variable important for parts 2,3 of assignment
encoding = zeros(N_ITEMS,N_WORLD_FEATURES+1);

world_m = [1 2 1 2 3];              % can generate randomly for yourself
world_var = 1;
delta = 0.05;                       % what does this parameter affect?
beta_param = 0.001;                 % what does this parameter affect?
m = 1;

% simulating encoding

for time = 1:ENCODING_TIME
    world_m = world_m + delta;
    world = normrnd(world_m, world_var);
    % any item I want to encode in memory, I encode in association with the
    % state of the world at that time.
    if(m<(N_ITEMS+1))
        if(time==schedule(m,1))
            encoding(m,:) =                                                 % encode into the encoding vector
            m =  m + 1;
        end;  
    end;
end;

% simulating retrieval using SAM, but with a bijective image-item mapping
while(time<ENCODING_TIME+TEST_TIME)
% the state of the world is the retrieval cue
                                                                                % model world evolution

    for m = 1:N_ITEMS
        soa(m) =                                                                % finding association strengths
    end;
                                                                                 % normalize
    
    out(time-ENCODING_TIME+1) = find(drawFromADist(soa));
    time = time + 1;       
end;

success = length(unique(out));                                                  % success is number of unique retrievals

% humans can retrieve about 7 items effectively from memory. get this model
% to behave like humans