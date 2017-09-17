#####################################################
##funcao de previsão de pastagens - series temporais
#####################################################

# A funcao past_prev retorna a chance (%) de um período sazonal (23 observacoes) ser uma pastagem
# pacotes: forecast; mFilter

gamApply <-function(x){ #y=serie ; lon=longitude  ; lat=latitude
  load("/data/PROCESSAMENTO/SENTINEL/QUALIDADE_PASTAGEM/GitHub/time_series_analysis/src/R/gamClassificator/gamModel.RData")
  y <- x[-c(1:2)]
  lon = x[1]
  lat = x[2]
  
  x<-ts(y,start = 1,frequency = 23)  
 
  x_stl<-stl(x,s.window = 6,robust=TRUE)
  
  x_saz<-x_stl$time.series[,1]
  x_ten<-x_stl$time.series[,2]
  x_err<-x_stl$time.series[,3]
  
  x_saz_hp<-mFilter::hpfilter(x_saz,5)$trend
  
  
  s0<-which.min(x_saz[1:23])
  xn<-length(x)
  xn0<-length(x[s0:xn])
  sn<-floor(xn0/23)
  tr<-seq(s0,s0+sn*23,23)
  
  m_saz<-matrix(x_saz[s0:((s0+sn*23)-1)],nr=23)
  m_ten<-matrix(x_ten[s0:((s0+sn*23)-1)],nr=23)
  m_err<-matrix(x_err[s0:((s0+sn*23)-1)],nr=23)
  
  geral_ten_mean<-apply(m_ten,2,mean)
  geral_saz_sd<-apply(m_saz,2,sd)
  geral_err_eqm<-apply(m_err,2,function(x){mean(x^2)})
  
  new_data<-data.frame(geral_ten_mean,
                       geral_saz_sd,
                       geral_err_eqm,
                       lat_geral=rep(lat,sn),
                       lon_geral=rep(lon,sn))
  
  prob<-100*round(predict(mod_gam_full,new_data,type="response"),2)
  return(prob)
}
