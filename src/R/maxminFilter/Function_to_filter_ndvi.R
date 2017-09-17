########################################################################################
########################################################################################
FILTERNDVIPOLY <- function(x) { 
  library(forecast)
  
  ###
  ###
  #' Function poly_filt:
  polyFilter <- function( ts, nn, grau, desvio = 0 ) {
    
    ns = length(ts)
    new_ts = ts
    
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
  
  ###
  ###
  #' Function local_maxmin: Detects local maximal and minimal points with
  #' respect of a neighborhood of size nn*2 + 1.
  #' @param ts: time series
  #' @param nn: number of neighbors
  #' @return: local max and min index
  maxminOutliers <- function( ts, nn ) {
    ns = length(ts);
    lmax = c();
    lmin = c();
    
    for( i in 1:ns ) {
      to = max(1, (i-nn) )
      tf = min(ns, (i+nn) )
      
      M = max( ts[to:tf] )
      
      if( ts[i] == M ) {
        # ts[i] is a local max
        lmax = c( lmax, i )
      } else {
        m = min( ts[to:tf] )
        if( ts[i] == m) {
          # ts[i] is a local min
          lmin = c( lmin, i )
        }
      }
    }
    # rbind?
    return( list( max = lmax, min = unlist(lmin) )  );
  }
  
###
###
#Na interpolate and poly filter
  if (all(is.na(x)) == TRUE){
    c(rep(NA, length(x)),
      sum(
        is.na(x)))
    } else if (sum(is.na(x)) > 50 ){
      c(rep(NA, length(x)),
        sum(
          is.na(x)))
		  } else {
		  c(polyFilter(
		    na.interp(
		    as.numeric(x)), 3, 2),
		    sum(
		      is.na(x)))
  }
}
########################################################################################
########################################################################################