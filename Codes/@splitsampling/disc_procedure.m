%% Discretization procedure
% Input:
%   obj - sumbsampling object
%   X   - NxK vector of r.v.
%
% Output:
%   Xs - NxK vector 
%       Discretized r.v.
%   Xd - NxK vector 
%       Artificially created r.v.
%   IDs - NxK vector for identification for sub-sample s 
%       s=1 is 1, s=2 is 2 and so on
%   ID_DTO - NxK logical
%       true if Xd is a DTO

function [ Xs , Xd , IDs , ID_DTO ] = disc_procedure( obj , X )

mN = size( X , 1 );
% 1) Discretization and id for sub-samples
[ X_s , id_s ] = discretize_rv( obj , X );

% 2) Underlying distribution and id for DTO
[ x_dagger , dto_idX ] = create_artificial_distribution( obj , X_s );

% Convert data for estimate with multiple N-s  and get rid of added NaNs
Xs  = X_s(:);
Xs  = Xs( 1 : mN, : );
Xd  = x_dagger(:);
Xd  = Xd( 1 : mN, : );
IDs = id_s(:);
IDs = IDs( 1 : mN );
ID_DTO = dto_idX( : );
ID_DTO = ID_DTO( 1 : mN );

% Xs  = X_s( 1 : mN, : )';
% Xd  = x_dagger( 1 : mN, : )';
% IDs = id_s( 1 : mN, : )';
% ID_DTO = dto_idX( 1 : mN, : )';


end