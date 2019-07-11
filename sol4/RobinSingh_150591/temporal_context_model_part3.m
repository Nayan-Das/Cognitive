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

dist = makedist('Normal','mu',1,'sigma',0.25);                              % mu controls the mean of the truncated distribution so that the
                                                                            % scheduling remains near the end of interval of 500.
schedule_dist = truncate(dist,0,1);                                         % cant take negative or values greater than 1
n_rvs = random(schedule_dist, 1, N_ITEMS);

% schedule = [(491:500)' (1:N_ITEMS)'];                                      % maximum schedule load can't take this combination
schedule = [sort(round(n_rvs*ENCODING_TIME))' (1:N_ITEMS)'];
schedule_load = ENCODING_TIME/median(diff(schedule(:,1))); 
encoding = zeros(N_ITEMS,N_WORLD_FEATURES+1);

world_m = [1 2 1 2 3];                                                      % can generate randomly for yourself world mean
world_var = 1;                                                              % world variance

delta = rand(1,ENCODING_TIME);                                              % randomly generate delta from unifrom distribution of 0 and 1
beta_param = 0.001;                                             

%% Simulating Retrieval
% simulating encoding
m = 1;
delta_store = zeros(1,10);
for time = 1:ENCODING_TIME
    world_m = world_m + delta(time);
    world = normrnd(world_m, world_var);
    % any item I want to encode in memory, I encode in association with the
    % state of the world at that time.
    if(m<(N_ITEMS+1))
        if(time==schedule(m,1))
            delta_store(m) = delta(time);
            encoding(m,:) = [world m];                                      % encode into the encoding vector
            m =  m + 1;
        end;  
    end;
end;

%% applying EM to above stored delta values when an encoding is formed
d = 1;
k = 2;
n = length(delta_store);
[z1, model, llh] = mixGaussEm(delta_store, k);       % function to apply EM

mix_ratio = model.w;                                % learned parameters
mu = model.mu;
sig = model.Sigma;

%% Now generating delta from mixed distribution according to learned parameters
cov_matrix = 1;
cov_matrix(:,:,1) = sig(:,:,1);
cov_matrix(:,:,2) = sig(:,:,2);
gmm = gmdistribution([mu(1); mu(2)],cov_matrix, mix_ratio);                
delta_new = random(gmm,1); 

%%
% simulating retrieval using SAM, but with a bijective image-item mapping
out = zeros(1,TEST_TIME);
while(time<ENCODING_TIME+TEST_TIME)
% the state of the world is the retrieval cue
    world_m = world_m + delta_new;                                          % using new deltas generated from learned parameters
    world = normrnd(world_m, world_var);                                    % model world evolution
    delta_new = random(gmm,1);
    
    soa = zeros(1,N_ITEMS);
    for m = 1:N_ITEMS
        soa(m) = encoding(m,:)*transpose([world m]);                        % finding association strengths
    end;
    soa = soa/norm(soa);                                                    % normalize
    out(time-ENCODING_TIME+1) = find(drawFromADist(soa));
    time = time + 1;       
end;

success = length(unique(out));                                              % success is number of unique retrievals
fprintf('No. of Correct Retrievals: %d/10\n', success)
% humans can retrieve about 7 items effectively from memory. get this model
% to behave like humans

%% THIS GIVE BEST RESULTS OUT OF ALL !!!!!