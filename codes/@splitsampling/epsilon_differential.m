%% Calculate the epsilon differential measure for differential privacy
% Input:
%   obj - sumbsampling object
%   X   - NxK vector of discretized r.v.
%
% Output:
%   eps - measure of differential privacy >0
%   delta -- probability of data privacy leakage

function [ eps, delta ] = epsilon_differential( obj , Xs, rnd_sample )

if ( rnd_sample )
    % Take a random 1000 sample
    rng(1234);
    Xs = randsample(Xs, 1000);
end

N = size( Xs, 1 );

%% First: observed probabilities -- nominator
if ( strcmp( obj.type, 'simple' ) )
    Zs_in_Cm = NaN( N, obj.M, 1 );
    S = 1;
else 
    Zs_in_Cm = NaN( N, obj.M, obj.S );
    S = obj.S;
end

for s = 1:S
    for i = 1:obj.M
        Zs_in_Cm(:,i,s) = ( Xs == obj.z_s(s,i) ) / ( N * S );
    end
end

z_in_Cm = sum(Zs_in_Cm, 1);

%% Second: observed probabilities -- dropping one obs
z_in_Cm_p = NaN( N, obj.M, S );
for n = 1 : N
  pr_Zs_in_Cm_prime = NaN( N-1, obj.M, S );
  for s = 1:S
      for i = 1:obj.M
        if ( n > 1 && n < N )
          pr_Zs_in_Cm_prime(:,i,s) = ( Xs( [ 1:(n-1), (n+1):N ] ) == obj.z_s(s,i) ) / ( (N-1) * S );  
        elseif ( n == 1 )
          pr_Zs_in_Cm_prime(:,i,s) = ( Xs(2:N) == obj.z_s(s,i) ) / ( (N-1) * S );  
        elseif ( n == N )
          pr_Zs_in_Cm_prime(:,i,s) = ( Xs(1:(N-1)) == obj.z_s(s,i) ) / ( (N-1) * S );  
        end
      end
  end
  z_in_Cm_p( n, :, : ) = sum( pr_Zs_in_Cm_prime, 1 );
end

%% Final value
varesp_dif = repmat( z_in_Cm, N, 1 ) ./ z_in_Cm_p;

delta = sum( z_in_Cm_p == 0) / ( N * obj.M * S );
eps = max(varesp_dif( isfinite(varesp_dif) ) );

end