verwerk_1DylosLog_bestand <- function(log_dir, ingelezenlog_dir, 
                                      bestandsnaam, 
                                      ods_bestand){
    rc_function <- NA
    
    # Maak de volledige bestandsnaam aan van dit Dylos logbestand
    log_bestand <- paste0(log_dir, bestandsnaam)
    
    # Lees het opgeslagen ODS bestand in
    load(ods_bestand) # load(Dylos_ods) rm(DylosLog_data)
    # Nu staan twee dataframes klaar: DylosLog_bestand en DylosLog_meting
    
    # Verwerk de header van het bestand
    resultaat_verwerkheader <- verwerk_1DylosLog_header(log_dir, ingelezenlog_dir,
                                                        bestandsnaam, 
                                                        DylosLog_bestand)
    if (resultaat_verwerkheader[[1]] == 0){
        logbestand_id    <- resultaat_verwerkheader[[2]]
        DylosLog_bestand <- resultaat_verwerkheader[[3]]
        
        # Bewaar de verwerkte header
        save(file = Dylos_ods, list = c('DylosLog_bestand', 'DylosLog_meting'))
        print('__Na het verwerken van de header')
        # Verwerk nu de metingen
        resultaat_verwerklog <- verwerk_1DylosLog_metingen(
                                       log_dir, ingelezenlog_dir,
                                       bestandsnaam, DylosLog_meting,
                                       logbestand_id)
        print('__Na het verwerken van de metingen')
        if (resultaat_verwerklog[[1]] == 0) {
            DylosLog_meting <- resultaat_verwerklog[[2]]
            # Werk de import_status van dit Dylos logbestand bij
            DylosLog_bestand[DylosLog_bestand$logbestand_id == logbestand_id, ]$import_status <- 
                'data ingelezen'
            # Bewaar de verwerkte metingen
            save(file = Dylos_ods, list = c('DylosLog_bestand', 'DylosLog_meting'))
            rc_function <- 0
        } else {
            cat('ERROR: Het verwerken van de metingen is fout gegaan.\n')
            rc_function <- 8
        }
        
    } else {
        cat('ERROR: Het verwerken van de header is fout gegaan.\n')
        rc_function <- 8
    }
        
    return(rc_function)
}


