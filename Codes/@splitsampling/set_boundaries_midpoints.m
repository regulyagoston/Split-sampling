%% Create Sub-Sample questionnaires (boundary points)

function set_boundaries_midpoints( obj )

switch obj.type
    case 'simple'
        if obj.S ~= 1
            error('Using simple questionnaire requires to set S=1')
        end
        % Working sample's boundary points
        c_b = linspace( obj.a_l ,obj.a_u , obj.M + 1 );
        % Sub-sample's boundary points
        c_s = c_b;
        
    case 'magnifying'
        %% First create the working sample's boundary points
        % Number of classes in the working sample
        B = obj.S * ( obj.M - 2 ) + 2;
        % Width of the classes in the sub-samples
        h = ( obj.a_u - obj.a_l ) / B;
        % Working sample's boundary points
        c_b = obj.a_l : h : obj.a_u;
        
        %% Second place them into sub-samples (this is needed for exact matching...)
        % Matrix for sub-samples
        c_s = NaN( obj.S , obj.M + 1 );
        % First and last boundary points are always the end of the domain
        c_s( : , 1 )   = c_b( 1 );
        c_s( : , end ) = c_b( end );
        % Initialize the for loop
        ct = 2;
        for s = 1 : obj.S
            for m = 1 : ( obj.M - 1 )
                c_s( s , 1 + m ) = c_b( ct );
                ct = ct + 1;
            end
            ct = ct - 1;
        end
        %1;
    case 'shifting'
        %% First create the working sample's boundary points
        % Note in the shifting case we add an extra interval! - This is for
        % S=1 to match M=obj.M
        obj.M = obj.M + 1;
        % Number of classes in the working sample
        B = obj.S * ( obj.M - 1 );
        % Width of the shift
        h = ( obj.a_u - obj.a_l ) / B;
        % Working sample's boundary points
        c_b = obj.a_l : h : obj.a_u;
        
        %% Second place them into sub-samples (this is needed for exact matching...)
        % Matrix for sub-samples
        c_s = NaN( obj.S , obj.M + 1 );
        % First and last boundary points are always the end of the domain
        c_s( : , 1 )   = c_b( 1 );
        c_s( : , end ) = c_b( end );
        % The first sub-sample is special
        c_s( 1 , 2 : end ) = c_b( 1 : obj.S : end );
        % Shift each sub-sample by h
        for s = 2 : obj.S
            c_s( s , 2 : end - 1 ) = c_b( s : obj.S : end - obj.S + s );
        end
        %1;
    otherwise
        error( ['No such sub-sampling method as' , obj.type '\n', 'Use magnifying or shifting methods.' ] )
end

%% Mid-value points
% Working-sample
switch obj.use_val
    case 'mid'
        obj.z_b = ( c_b( 1 : end - 1 ) + c_b( 2 : end ) ) ./ 2;
        % Sub-sample
        obj.z_s = NaN( obj.S , obj.M );
        for s = 1 : obj.S
            obj.z_s( s , : ) = ( c_s( s , 1 : end - 1 ) + c_s( s , 2 : end ) ) ./ 2;
        end
    case 'low'
        obj.z_b = c_b( 1 : end - 1 );
        % Sub-sample
        obj.z_s = NaN( obj.S , obj.M );
        for s = 1 : obj.S
            obj.z_s( s , : ) = c_s( s , 1 : end - 1 );
        end
    case 'high'
        obj.z_b = c_b( 2 : end );
        % Sub-sample
        obj.z_s = NaN( obj.S , obj.M );
        for s = 1 : obj.S
            obj.z_s( s , : ) = c_s( s , 2 : end );
        end
    otherwise
        error('No such values method to use as observations')
end

%% If censored correct the boundary points
if obj.censored
    c_s( : , 1 )   = -Inf;
    c_s( : , end ) =  Inf;
end

%% If there is Perception Bias add a value for that
if obj.perception
    % Uniform random variables up to 0.0x
    varB = 0.4;
    rng( obj.seed );
    obj.B_s = round( rand( [ 1 , obj.S ] ) * varB - ( varB / 2 ) , 2 );
    % Set the first to 0
    obj.B_s( 1 ) = 0;
end

obj.c_s = c_s;
obj.c_b = c_b;

end