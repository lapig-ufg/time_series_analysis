polyFilter <- function( ts, nn, grau, desvio = 0 ) {
  
  ns = length(ts)
  new_ts = forecast::na.interp(as.numeric(ts))
  
  #idx = c(-nn:-1, 1:nn )
  idx = -nn:nn
  
  X = matrix( rep(0, length(idx)*(grau+1) ), ncol = grau+1, byrow = FALSE )
  X[,1] = 1
  #x = c(1, rep( 0, grau ) )
  for( k in 2:(grau+1) ) {
    X[,k] = (idx)^k 
    #x[ k] = nn^k
  }
  
  for( i in 1:ns ) {
    idx_ts = ( abs(idx+i-1) %% ns + 1 )
    y = ts[ idx_ts ]
    LM = lm.fit( x = X, y = y)
    #new_ts[i] = (x %*% LM$coefficients)
    
    if( desvio == 0 ) {
      new_ts[i] = LM$coefficients[1]
    } else {
      sdv = sd( LM$residuals )
      if( abs(ts[i] - LM$coefficients[1] ) > desvio*sdv ) {
        new_ts[i] = LM$coefficients[1]
      }
    }
  }
  
  return( new_ts );
}