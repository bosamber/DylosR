zoek_identiek_LogBestand <- function(ods_logselectie,
                                     logbestand_mtime, header_regels){
    rc_function <- NA
    
    vergelijkingsvariabelen <- c('software_versie', 
                                 'hardware_versie', 
                                 'download_datumtijd_txt',
                                 'meeteenheid_txt')
    
    for (regel in 1:nrow(ods_logselectie)){
        variabelen_identiek <- 
            # identical niet gebruiken, die vergelijkt ook row.names
            isTRUE(all.equal(ods_logselectie[regel, vergelijkingsvariabelen], 
                      header_regels, 
                      check.attributes = FALSE))
        mtime_identiek <- (ods_logselectie[regel, 'logbestand_mtime'] == 
                               logbestand_mtime)
        if (variabelen_identiek && mtime_identiek) {
            if (ods_logselectie[regel, 'import_status'] == 'data ingelezen') {
                cat('Dylos logbestand', ods_logselectie[regel, 'logbestand_naam'])
                cat('is al ingelezen.\n')
                rc_function <- 0
            }
            else {
                cat('Dylos logbestand', ods_logselectie[regel, 'logbestand_naam'])
                cat(' wel geregistreerd, maar nog niet ingelezen.\n')
                rc_function <- 1
            }
            logbestand_id <- ods_logselectie[regel, 'logbestand_id']
            # niet verder zoeken, bestand mag maar 1x voorkomen
            break
        } # einde variabelen identiek en mtime identiek
        
    } # einde regels DylosLog_bestand doorzoeken
    
    # Als geen identiek bestand gevonden, dan
    if (!(variabelen_identiek && mtime_identiek)){
        logbestand_id <- 0
        rc_function   <- 2
    }
#     cat('variabelen_identiek', variabelen_identiek, '\n')
#     cat('mtime_identiek', mtime_identiek, '\n')
#     cat('logbestand_id', logbestand_id, '\n')
#     
    list(rc_function, logbestand_id)
}


