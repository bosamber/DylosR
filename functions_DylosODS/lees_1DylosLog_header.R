lees_1DylosLog_header <- function(log_bestand) {
    rc_function <- NA
    
    # lees de bovenste regels van het bestand
    header_regels          <- readLines(log_bestand , n = 7)

    if (!length(header_regels) == 7){
        cat('ERROR: Header van', log_bestand, 'heeft te weinig regels.\n')
        header_df   <- data.frame()
        rc_function <- 8
    } else  {
        # zet de variabelen klaar die je na het inlezen al weet
        software_versie        <- header_regels[2]
        hardware_versie        <- header_regels[3]
        download_datumtijd_txt <- header_regels[4]
        meeteenheid_txt        <- header_regels[6]
        
        # Geef de header-variabelen terug als data.frame
        header_df   <- data.frame(software_versie, hardware_versie, 
                                  download_datumtijd_txt, meeteenheid_txt,
                                  stringsAsFactors = FALSE)
        rc_function <- 0
    }
#     rc_function <- 8
    return(list(rc_function, header_df))
}

