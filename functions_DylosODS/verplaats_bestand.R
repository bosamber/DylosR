
verplaats_bestand <- function(bestandsnaam, dir_van, dir_naar){
    rc_function <- NA
    
    # Kijk of het bestand aanwezig is op de oorspronkelijke locatie
    if (file.exists(paste0(dir_van, bestandsnaam))) {
        # Kijk of de nieuwe locatie wel bestaat
        if ( dir.exists(dir_naar)) {
            # Controleer of het bestand al aanwezig is in die directory
            # Niet automatisch overschrijven, maar datumtijd toevoegen
            if (file.exists(paste0(dir_naar, bestandsnaam))) {
                bestandsnaam_nw <- paste0(bestandsnaam,
                                          format(Sys.time(), "%Y%m%d%H%M%S"))
                cat('WARNING: Bestand', bestandsnaam, 'bestaat al in', dir_naar, '\n')
                cat('WARNING: Bestand hernoemd naar.', bestandsnaam_nw, '\n')
                rc_function <- 4
            } else {
                bestandsnaam_nw <- bestandsnaam
                rc_function <- 0
            }
   
            # Verplaats bestand van oorspronkelijke naar nieuwe locatie
            file.rename(paste0(dir_van, bestandsnaam),
                        paste0(dir_naar, bestandsnaam_nw))
            cat('Bestand', bestandsnaam, ' verplaatst naar', dir_naar, '\n')
        } else {
            cat('ERROR: Directory ', dir_naar, 'bestaat niet. \n')
            rc_function <- 8
        }   
        
    } else {
        cat('ERROR: Bestand ', paste0(dir_van, bestandsnaam), 'bestaat niet. \n')
        rc_function <- 8
    }
    
    rc_function
}

