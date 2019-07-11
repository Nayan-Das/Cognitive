alpha = 0.3;
gamma = 0.9;

environment_design;

vec = reshape(mat,1,length(mat)^2);
V = zeros(1,length(vec));
curr = ceil(rand*length(mat)^2);

moves= legal_moves(curr,mat);

% vidObj = VideoWriter('sample.avi');
% open(vidObj);

for time = 1:1000
    R = vec(curr);
    new = moves(ceil(rand*length(moves)));
    V(curr) = V(curr) + alpha*(R + gamma*V(new) - V(curr));        
    curr = new;
    moves= legal_moves(curr,mat);
    Vmat = reshape(V,length(mat), length(mat));
    error(time) = sqrt(sum((mat(mat~=0) - Vmat(mat~=0)).^2));    
    cumR(time) = R;
%     imagesc(Vmat);
%     currFrame = getframe(gcf);
%     writeVideo(vidObj,currFrame);
end;    
 plot(error);
 plot(cumR);
  imagesc(Vmat);    
% close(vidObj);