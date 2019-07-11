
This programming assignment has three components.


Part 1: 10 marks



Fill in the partially complete lines of code in the file
 temporal_context_model_empty.m to make a temporal context model of memory
 retrieval that retrieves about 7 items from an encoded list efficiently.


This should not be very challenging if you've followed the concept of the TCM in class



Part 2: 10 marks



Alongside the TCM you have implemented, you have also implemented
 assumptions about the physics of the world. Namely, you have assumed that
 the world can be represented as a set of draws from N independent Gaussians, and
 that the means of these Gaussians evolve over time linearly. Now we change this. We
 assume that the world contains context changes, and represent this fact by
 sampling the rate of drift over time (delta) in the feature means itself from a
 mixture of two Gaussians, one with a small mean to denote small changes,
 and one with a large mean to denote large changes. 



Implement this new physics of the world in the model, and design an
 encoding schedule that lets your model retrieve effectively (>7 success).
 The trivial solution is to shove all the encodings towards the back end
 of the encoding period, but doing so will increase your encoding load (proxy for study effort)

 An optimal solution would find the scheduling pattern that minimizes
% encoding load while maintaining average retrieval success across multiple
 runs at 7. See if you can find it, assuming your retrieving agent knows
 the parameters of the model that will generate his world contexts

.

Part 3: 20 marks

 Do the same thing, but this time assuming that the retrieving agent does
 not know the parameters of the world generating model, just the fact that
 the rate of drift is sampled from a bimodal distribution. Hint: you'll
 have to have the agent learn the drift distribution parameters. EM
 is your friend here. 