opmaken_DylosLog_metingen <- function(maxkey_bestaand, 
                                      df_ruw, logbestand_id){
    
    if (is.null(df_ruw)){
        df_return <- NULL
    } else {
        logmeting_id    <- (maxkey_bestaand + 1) : (maxkey_bestaand + nrow(df_ruw)) 
        logmeting_geldig <-TRUE
        import_datumtijd<- Sys.time()
        
        df_return <- data.frame(logbestand_id,
                     logmeting_id,
                     logmeting_geldig, 
                     df_ruw, import_datumtijd, 
                     stringsAsFactors=FALSE)
    }
    
    df_return
}