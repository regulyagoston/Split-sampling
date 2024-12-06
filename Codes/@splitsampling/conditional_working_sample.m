%% Creating working sample
%
% Input:
%   obj - subsampling object
%   X_s - Nx1 vector of discretized values
%   artX - Nx1 vector of artificially generated r.v.
%   id_s - Nx1 vector which contains the sub-sample's number
%   double_cond - scalar 
%       true - calculate double conditional mean for FE
%       false - calculate simple conditional mean for simple case
%
% Output:
%   X_ws - Nx1 vector of working sample values
%       gives the conditional mean based on the sub-sample's choice
%       interval


function X_ws = conditional_working_sample( obj, X_s , artX , id_s , double_cond )

% Create variable for working sample
X_ws = NaN( size( X_s ) );

% Brute force version
for s = 1 : obj.S
    % Logical for sub-sample s
    log_s = id_s == s;
    % Get the relevant artificial R.V.
    if double_cond
        % Condition on artificial Xs as well
        artX_s = artX( log_s );
    else
        artX_s = artX;
    end
    artX_s = artX_s( ~isnan( artX_s ) );
    % For each mid-value
    for m = 1 : obj.M
        log_mid = X_s == obj.z_s( s , m ) & log_s;
        % Number of observation within the class in the given sub-sample
        n_a = sum( log_mid );
        % If no observation then skip
        if n_a > 0
            % Bounds for selecting values from the artificial rv
            bounds = [ obj.c_s( s , m ) , obj.c_s( s , m + 1 ) ];
            % Values in artX_s which are within that range
            log_A = artX_s >= bounds( 1 ) & artX_s <= bounds( 2 );
            if sum( log_A ) > 0
                % Conditional sample average using the artificial rv
                cond_avg = mean( artX_s( log_A ) );
                X_ws( log_mid ) = cond_avg;
            end
        end
    end
end

end