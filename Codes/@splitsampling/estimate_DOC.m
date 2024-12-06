%% Estimate MC with DTO observations using fix N, S, M, and MC
%
% Case: Known domain

function [ b_0 , nObs , nUq ] = estimate_DOC( Y , X , N , S , objY , objX , ordered, set_id_X )

%% Get basic parameters
MC = size( Y , 2 );
% check for X - whether it is varying
MC_X = size( X , 2 );
if MC_X > 1
    mcX = 1 : MC;
else
    mcX = ones( 1 , MC );
end
% Number of N
nN = numel( N );
% Check for object and update
l_objY = isempty( objY );
if ~l_objY
    objY.S = S;
    set_boundaries_midpoints( objY );
end
l_objX = isempty( objX );
if ~l_objX
    objX.S = S;
    if set_id_X
        error('Not properly implemented!')
        %objX_l = copy_prop(objX);
        %objX_l.use_val = 'low';
        %objX_u = copy_prop(objX);
        %objX_u.use_val = 'high';
        %set_boundaries_midpoints( objX_l );
        %set_boundaries_midpoints( objX_u );
    else
        set_boundaries_midpoints( objX );
    end
    
end

% Slots
b_0  = NaN( MC , nN );
if set_id_X 
    b_0_u  = NaN( MC , nN );
end
nObs = NaN( MC , nN );
nUq  = NaN( MC , nN );

%% % Estimation procedure
% Estimation for LHS only
e_lhs = ~l_objY & l_objX;
% Estimation for RHS only
e_rhs = l_objY & ~l_objX;
% Estimation for RHS and LHS jointly
e_dhs = ~l_objY & ~l_objX;
if l_objY && l_objX
    error('No discretization is done! Simple OLS with continuous variables are estimated!')
end
%% For each monte-carlo sample
parfor mc = 1 : MC
    %% Get the relevant samples
    Ymc = Y( : , mc );
    Xmc = X( : , mcX( mc ) );
    %% Get Y variable
    if ~l_objY
        [ Ys , Yd , IDs_Y , ID_DTO_Y ] = disc_procedure( objY , Ymc );
    end
    %% Get X variable
    if ~l_objX
        %if set_id_X
        %    [ Xs_l , Xd_l , IDs_X_l , ID_DTO_X_l ] = disc_procedure( objX_l , Xmc );
        %    [ Xs_u , Xd_u , IDs_X_u , ID_DTO_X_u ] = disc_procedure( objX_u , Xmc );
        %else
            [ Xs , Xd , IDs_X , ID_DTO_X ] = disc_procedure( objX , Xmc );
        %end
    end
    if ordered( 1 )
        Yd = ordinal( Yd );
    end
    %% Estimation for each sample-size
    for n = 1 : nN
        
        % Decide estimation procedure
        if e_lhs && ~ordered( 1 )
            %% Sample for LHS
            X_n  = Xmc( 1 : N( n ) , : );
            Yd_n = Yd( 1 : N( n ) , : );
            DTO_n = ID_DTO_Y( 1 : N( n ) , : );
            [ b_0( mc , n ) , nObs( mc , n ) , nUq( mc , n ) ] = estLHS( objY , X_n , Yd_n , DTO_n );
        elseif e_lhs && ordered( 1 )
            %% Ordered choice models
            X_n  = Xmc( 1 : N( n ) , : );
            Yd_n = Yd( 1 : N( n ) , : );
            lastwarn('');
            if ordered( 2 )
                % Probit
                [ B_o , ~ , stat ] = mnrfit( X_n , Yd_n , 'model','ordinal','link','probit');
                sigma_e = 1;
            else
                % Logit
                [ B_o , ~ , stat ] = mnrfit( X_n , Yd_n ,'model','ordinal','link','logit');
                sigma_e = pi^2/3;
            end
            varX = var( X_n );
            b_0( mc , n ) = -B_o( end ) .* sqrt( varX ) ./ sqrt( B_o( end ).^2 .* stat.covb( end , end ) + sigma_e );
            [ warnMsg ] = lastwarn;
            if ~isempty(warnMsg)
                nObs( mc , n ) = 1;
            else
                nObs( mc , n ) = 0;
            end
        elseif e_rhs
            % Find the relevant sample
            Y_n  = Ymc( 1 : N( n ) , : );
            %if set_id_X
                % lower
            %    Xs_n = Xs_l( 1 : N( n ) , : );
            %    nObs( mc , n ) = N( n );
            %    nUq( mc , n ) = numel( unique( Xs_n ) )
            %    %bl = lscov( [ ones( N( n ) , 1 ) , Xs_n ] , Y_n );
            %    %b_0( mc , n ) = bl( 2 )
            %    b_0( mc, n ) = lscov( Xs_n , Y_n );
            %    % Upper
            %    %bu = lscov( [ ones( N( n ) , 1 ) , Xs_u( 1 : N( n ) , : ) ] , Y_n );
            %    %b_0_u( mc , n ) = bu( 2 );
            %    b_0_u( mc , n ) = lscov( Xs_u( 1 : N( n ) , : ) , Y_n );
            %else
                Xs_n = Xs( 1 : N( n ) , : );
                Xd_n = Xd( 1 : N( n ) , : );
                Id_n = IDs_X( 1 : N( n ) , : );
                DTO_n = ID_DTO_X( 1 : N( n ) , : );
                [ b_0( mc , n ) , nObs( mc , n ) , nUq( mc , n ) ] = estRHS( objX , Y_n , Xs_n , Xd_n , Id_n , DTO_n );
            %end
        elseif e_dhs
             %% Sample for LHS
            Xs_n = Xs( 1 : N( n ) , : );
            Xd_n = Xd( 1 : N( n ) , : );
            Id_nX = IDs_X( 1 : N( n ) , : );
            DTO_nX = ID_DTO_X( 1 : N( n ) , : );
            Ys_n = Ys( 1 : N( n ) , : );
            Yd_n = Yd( 1 : N( n ) , : );
            Id_nY = IDs_Y( 1 : N( n ) , : );
            DTO_nY = ID_DTO_Y( 1 : N( n ) , : );
            [ b_0( mc , n ) , nObs( mc , n ) , nUq( mc , n ) ] = est_both( objY , objX, Ys_n, Yd_n, Id_nY, DTO_nY, Xs_n, Xd_n, Id_nX, DTO_nX );
        end
    end

end

if set_id_X
    b_0 = [ b_0, b_0_u ];
end

end


