

function b_rec = recover_underlying( b0 , s_kk , var_bb , sigma2y )

b_rec = -b0 .* s_kk ./ repmat( sqrt( b0' * var_bb * b0 + sigma2y ) , [ numel( b0 ) , 1 ] );


end