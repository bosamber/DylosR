toevoegen_LogBestand <- function(logbestand_naam, logbestand_mtime, 
                                 header_regels, ods_logbestand){
    
    logbestand_id  <- get_max_key(ods_logbestand, 'logbestand_id') + 1
    nieuwe_regel   <- cbind(logbestand_id, logbestand_naam, logbestand_mtime,
                            header_regels, 
                            import_datumtijd=Sys.time(), 
                            import_status='header_ingelezen',
                            stringsAsFactors=FALSE)
    ods_logbestand <- rbind(ods_logbestand, nieuwe_regel, 
                            stringsAsFactors=FALSE)
    list(logbestand_id, ods_logbestand)
}

