%% Dicretize a given random variable
%
% Input:
%   obj - subsampling object
%   X   - NxK vector
%
% Output
%   X_s  - S x N_s x K matrix of discretized values, where N_s = N/S
%   id_s - S x N_s x K matrix of identification values for sub-sample S

function [ X_s , id_s ] = discretize_rv( obj , X )

if isempty( obj.c_s )
    error('No boundary points are given for questionnaires!')
end

N = numel( X );
% Create S partition of the data
N_s = ceil( N ./ obj.S );
X_s = NaN( obj.S , N_s );
% Reshape original random variable X first add NaNs to be able to reshape
obj.added_nan = ( N_s .* obj.S ) - N;
Xr = [ X ; NaN( obj.added_nan , 1 ) ];
Xr = reshape( Xr , obj.S , N_s );
id_s = repmat( ( 1 : obj.S )' , [ 1 , N_s ] );

mid_values = obj.z_s;

for s = 1 : obj.S
    if obj.perception
        Xr_s = Xr( s , : ) + obj.B_s( s );
    else
        Xr_s = Xr( s , : );
    end
    n_z = numel( mid_values( s , : ) );
    for n = 2 : ( n_z + 1 )
        log_ID = obj.c_s( s , n - 1 ) <= Xr_s & obj.c_s( s , n ) >= Xr_s;
        X_s( s , log_ID ) = mid_values( s , n - 1 );
    end
end

if sum( isnan( X_s( : ) ) ) > obj.added_nan
%    warning('Some observations are outside of the domain of the survey! We replace those with NaN in the data!')
end


end