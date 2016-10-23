zoek_aanwezige_bestanden <- function(dir_bestanden, patroon_bestandsnaam){
    rc_function <- NA
    
    aanwezige_bestanden <- sort(grep(patroon_bestandsnaam, list.files(dir_bestanden), 
                               value = TRUE))
    
    if (length(aanwezige_bestanden) > 0) {
        rc_function <- 0
        cat('Gevonden bestandenin', dir_bestanden, ':\n')
        for (i in 1:length(aanwezige_bestanden)) {
            cat(aanwezige_bestanden[i], '\n')
        }
    } else {
        rc_function <- 4
        cat('WARNING: Gezochte bestanden niet gevonden in ', dir_bestanden, '\n')
    }
    
    return(list(rc_function, aanwezige_bestanden))
}