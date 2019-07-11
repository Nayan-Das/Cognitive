clear;
% the temporal context model assumes that the past becomes increasingly
% dissimilar to the future, so that memories become harder to retrieve the
% farther away in the past they are
%%
N_WORLD_FEATURES = 5;
N_ITEMS = 10;
ENCODING_TIME = 500;
TEST_TIME = 20;

% In this case presentation schedule is randomized using truncated normal
% distribution whose mean is 1 and variance is 0.25. This is done such that
% more items are presented at the end while maintaining low schedule load

dist = makedist('Normal','mu',1,'sigma',0.25);                             % mu controls the mean of the truncated normal distribution so that the
                                                                           % mean is taken to be near 1 and variance small to shorten the varying bounds
                                                                           % scheduling remains near the end of interval of 500.
schedule_dist = truncate(dist,0,1);                                        % cant take negative or values greater than 1
n_rvs = random(schedule_dist, 1, N_ITEMS);

%     schedule = [(491:500)' (1:N_ITEMS)'];                                % maximum schedule load can't take this combination
schedule = [sort(round(n_rvs*ENCODING_TIME))' (1:N_ITEMS)'];               % using truncated normal distribution
schedule_load = ENCODING_TIME/median(diff(schedule(:,1))); 
encoding = zeros(N_ITEMS,N_WORLD_FEATURES+1);

world_m = [1 2 1 2 3];                                                     % can generate randomly for yourself world mean
world_var = 1;                                                             % world variance

% sampling delta from a mixture distribution with equal variance of 1 and
% 0.5 as the mixing ratio
cov_matrix = 1;
cov_matrix(:,:,1) = 1;
cov_matrix(:,:,2) = 1;
gmm = gmdistribution([0; 1],cov_matrix);                                   % one mean greater than 0.5 other less than it
delta = random(gmm,1);                                         
beta_param = 0.001;                                             

%%
% simulating encoding
m = 1;
for time = 1:ENCODING_TIME
    world_m = world_m + delta;
    %     world_m = beta_param*world_m + delta;                            % not used as it will reduce world_m very fast
    world = normrnd(world_m, world_var);
    delta = random(gmm,1);
    % any item I want to encode in memory, I encode in association with the
    % state of the world at that time.
    if(m<(N_ITEMS+1))
        if(time==schedule(m,1))
            encoding(m,:) = [world m];                                     % encode into the encoding vector
            m =  m + 1;
        end;  
    end;
end;

% simulating retrieval using SAM, but with a bijective image-item mapping
out = zeros(1,TEST_TIME);
while(time<ENCODING_TIME+TEST_TIME)
% the state of the world is the retrieval cue
    world_m = world_m + delta;
    %     world_m = beta_param*world_m + delta;                            % not used as it will reduce world_m very fast
    world = normrnd(world_m, world_var);                                   % model world evolution

    soa = zeros(1,N_ITEMS);
    for m = 1:N_ITEMS
        soa(m) = encoding(m,:)*transpose([world m]);                       % finding association strengths
    end;
    soa = soa/norm(soa);                                                   % normalize
    out(time-ENCODING_TIME+1) = find(drawFromADist(soa));
    time = time + 1;       
end;

success = length(unique(out));                                             % success is number of unique retrievals
fprintf('No. of Correct Retrievals: %d/10\n', success)
% humans can retrieve about 7 items effectively from memory. get this model
% to behave like humans