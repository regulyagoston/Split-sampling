classdef splitsampling < handle
    %% Class for sub-sampling methods   
    properties
        % Type of creating the split sample boundaries
        type
        % Number of split samples 
        S
        % Number of choice values
        M
        % Lower bound for class boundaries
        a_l
        % Upper bound for class boundaries
        a_u
        % Censored (t/f)
        censored = false;
        % Perception
        perception = false;
        % Use only DTO
        onlyDTO = false;
        % Use replacement of NDTOs
        replacement = true;
        % Uses lower or upper values
        use_val = 'mid';
    end
    
    properties
        % Boundary values for each split samples
        c_s 
    end
    properties %( Access = private )
        seed = 1000;
        added_nan = 0;
        % Number of X grid
        L = 50;
    end
    properties %( Access = private )
        % Boundary values for working sample
        c_b
        % Mid values for split samples
        z_s
        % Mid values for working sample
        z_b
        % Perception Bias
        B_s
    end
    
    
    
    methods
        function obj = splitsampling( type , S , M , a_l , a_u , use_val )
            if nargin < 6
                obj.use_val = 'mid';
            end
            obj.type = type;
            obj.S = S;
            obj.M = M;
            obj.a_l = a_l;
            obj.a_u = a_u;
            obj.use_val = use_val;
        end
        
        %% Type of sub-sampling method
        function set.type( obj , val )
            if ~ischar( val )
                error( 'Type of split sample methods must be a char' );
            elseif ~any( strcmpi( val , { 'simple','magnifying', 'shifting', 'custom' } ) )
                error( [ 'Type of split samples methods must be one of the following: \n' , ...
                        'simple: using only one questionnaire, S must be equal to 1 \n' , ...
                        'magnifying: magnifies into small bin parts within subsamples \n',...
                        'shifting: shifts the boundaries across the support \n',...
                        'custom: custom set split sample boundaries'] )
            else
                obj.type = val;
            end            
        end
        function set.use_val( obj , val )
            if ~ischar( val )
                error( 'Type of used values as the observations must be a char' );
            elseif ~any( strcmpi( val , { 'mid','low', 'high' } ) )
                error( [ 'Type of used values as the observations must be one of the following: \n' , ...
                        'mid: using the mid values of the interval \n' , ...
                        'low: uses the lower boundary point \n',...
                        'high: uses the higher boundary point'] )
            else
                obj.use_val = val;
            end            
        end
        function set.S( obj , val )
           if ~isnumeric( val ) && numel( val ) ~= 1 && val < 0 && mod( val , 0 ) ~= 1
               error('Number of split samples must be a positive integer')
           else
               obj.S = val;
           end
        end
        function set.M( obj , val )
           if ~isnumeric( val ) && numel( val ) ~= 1 && val < 0 && mod( val , 0 ) ~= 1
               error('Number of choice values must be a positive integer')
           else
               obj.M = val;
           end
        end
        function set.a_l( obj , val )
           if ~isnumeric( val ) && numel( val ) ~= 1
               error('Lowest choice boundary must be a a numerical value')
           else
               obj.a_l = val;
           end
        end
        function set.a_u( obj , val )
           if ~isnumeric( val ) && numel( val ) ~= 1
               error('Highest choice boundary must be a a numerical value')
           else
               obj.a_u = val;
           end
        end
        function set.censored( obj , val )
            if ~islogical( val )
                error('Censoring parameter must be a logical!')
            else
                obj.censored = val;
            end
        end
        function set.perception( obj , val )
            if ~islogical( val )
                error('Perception parameter must be a logical!')
            else
                obj.perception = val;
            end
        end
        function set.onlyDTO( obj , val )
            if ~islogical( val )
                error('Only DTO parameter must be a logical!')
            else
                obj.onlyDTO = val;
            end
        end
        function set.replacement( obj , val )
            if ~islogical( val )
                error('Replacement parameter must be a logical!')
            else
                obj.replacement = val;
            end
        end
        
    end
    
    
    methods
        %% Functions of the object
        set_boundaries_midpoints( obj );
        [ X_s , id_s ] = discretize_rv( obj , X );
        [ artX , dto_id ] = create_artificial_distribution( obj , X_s );
        [ Xs , Xd , IDs , ID_DTO ] = disc_procedure( obj , X );
        X_ws = conditional_working_sample( obj, X_s , artX , id_s , double_cond );
        
        %% Estimations
        [ b , nObs , nUq ] = estLHS( obj , X_n , Yd_n , DTO_n );
        [ b , nObs , nUq ] = estRHS( objX , Y_n , Xs_n , Xd_n , Id_n , DTO_n );
    end
    
    
    
    
end