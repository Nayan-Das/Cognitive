
% I am asking you to make a program that can solve MCQ problems using
% Normalized Google Distance, your ability to turn exam questions into
% reasonable search terms, and your creativity and ingenuity. 

% I've already given you code to calculate NGD between any two search
% strings. Don't change the 2 second timeout I've put into the web pulls, unless you 
% really know what you're doing.

% build your program logic on top of this. your program will be evaluated
% for both precision and recall on the General Awareness section of the SSC
% prelim exam. Specifically, this one http://sscportal.in/cgl/tier-1/papers/general-awareness-31-aug-2016-morning-shift

% the basic outline of what you have to do should be clear: you have to use
% NGD of a question string from each of the answer strings and hope that
% the one that is closest is the right answer. But there are many ways in
% which you can improve this basic solver, e.g. by tweaking the NGD formula
% itself, by setting answer thresholds on NGD based on training the solver
% on other exam problems, optimizing for accuracy. I'm not going to grade
% you just on getting high precision and recall, but also on how thoughtful and
% resourceful your approach is. Big bonus marks for adding a parser to the
% front end to convert natural language questions into good search strings.

% in addition to code, please also submit the specific search strings used
% for each of the 25 problems, and your solver's answer for each of the
% questions.

