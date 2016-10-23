verwerk_1DylosLog_metingen <- function(log_dir, ingelezenlog_dir,
                           bestandsnaam, ods_logmetingen,
                           logbestand_id){
    rc_function <- NA
    
    # Maak volledige bestandsnaam aan
    log_bestand <- paste0(log_dir, bestandsnaam)
    
    # Lees de metingen uit het Dylos logbestand
    ruwe_metingen <- data.frame(lees_1DylosLog_metingen(log_bestand),
                                stringsAsFactors = FALSE)
    
    # Haal de geldige metingen op uit het ODS bestand
    # ods_logmetingen <- DylosLog_meting
    geldige_metingen <- ods_logmetingen[ods_logmetingen$logmeting_geldig == TRUE, ]
    
    if (nrow(ruwe_metingen) == 0){
        # Controleer of er metingen zijn ingelezen
        cat('ERROR: Leeg Dylos logbestand', bestandsnaam, '\n')
        rc_function <- 8
    } else if (anyDuplicated(ruwe_metingen['Date.Time']) > 0 ) {
        # Controleer of elke ingelezen meting uniek is
        cat('ERROR: Dubbele metingen gevonden in ingelezen bestand', log_bestand)
        rc_function <- 8
    } else if (nrow(geldige_metingen) == 0) {
        cat('Begin toch een initial load:\n', colnames(ruwe_metingen), '\n')
        
        # Kijk of de ODS geldige metingen bevat
        # Zo nee, dan is dit een initial load
        cat('Dit is een toch een initial load.\n')
        # Zet de initiele waarden voor de variabelen klaar
        logmeting_id    <- as.numeric(rownames(ruwe_metingen))
        logmeting_versie<- 1
        logmeting_geldig<- TRUE
        import_datumtijd<- Sys.time()
        ods_logmetingen <- data.frame(logbestand_id,
                                      logmeting_id,
                                      logmeting_versie=1, 
                                      logmeting_geldig=TRUE,
                                      ruwe_metingen, 
                                      import_datumtijd, 
                                      stringsAsFactors=FALSE)
        cat('Einde toch een initial load:\n', colnames(ods_logmetingen))
        
        rc_function <- 0
    } else if (anyDuplicated(geldige_metingen['Date.Time']) > 0 ) { 
        # De ODS bevat al geldige metingen en er zijn metingen ingelezen
        # Controleer of de geldige metingen uit de ODS uniek zijn
        cat('ERROR: Dubbele geldige metingen gevonden in ODS bestand', log_bestand)
        rc_function <- 8
    } else {
        # Zowel ingelezen metingen als geldige metingen zijn uniek
        # Voer een change data capture uit
        # ruwe_metingen[10, ]$Small <- 100
        cat('Change Data Capture wordt uitgevoerd voor', bestandsnaam, '\n')
        resultaat_cdc <- change_data_capture(ruwe_metingen, geldige_metingen,
                                             'Date.Time', c('Small', 'Large'),
                                             'logmeting_versie')
        
        # Voer wijzigingen uit op het resultaat zodat elke cdc uitkomst
        # alle variabelen bevat voor de ODS laag, met de juiste waardes

        # Sluit de oude metingversies af 
        if (!is.null(resultaat_cdc$wijziging)) {
            resultaat_cdc$afgesloten['logmeting_geldig'] <- FALSE
        }
    
        # Geef de nieuwe metingversies een nummer dat 1 hoger is dan de vorige
        # en zet de andere meta-variabelen klaar
        if (!is.null(resultaat_cdc$wijziging)) {
            resultaat_cdc$wijziging['logmeting_versie'] <- 
                resultaat_cdc$wijziging['logmeting_versie'] + 1
            resultaat_cdc$wijziging <- opmaken_DylosLog_metingen(
                get_max_key(ods_logmetingen, 'logmeting_id'),
                resultaat_cdc$wijziging,
                logbestand_id)
        }
       

        if (!is.null(resultaat_cdc$wijziging)) {
            max_logmeting_id <- get_max_key(resultaat_cdc$wijziging, 'logmeting_id')
        }
        else {
            max_logmeting_id <- get_max_key(ods_logmetingen, 'logmeting_id')
        }
        
        if (!is.null(resultaat_cdc$nieuw)) {
            # Geef de nieuwe metingen versienummer 1 
            # en zet de andere meta-variabelen klaar
            resultaat_cdc$nieuw['logmeting_versie'] <- 1
            resultaat_cdc$nieuw <- opmaken_DylosLog_metingen(
                max_logmeting_id,
                resultaat_cdc$nieuw,
                logbestand_id)
        }
            
        cat('Einde klaarzetten cdc onderdelen.\n')
        # Plak alle delen van de bijgewerkte geldige metingen onder de 
        # onveranderde niet-geldige metingen
        ods_logmetingen <- rbind(
            ods_logmetingen[ods_logmetingen$logmeting_geldig == FALSE, ],
            resultaat_cdc$verdwenen,
            resultaat_cdc$onveranderd,
            resultaat_cdc$afgesloten,
            resultaat_cdc$wijziging,
            resultaat_cdc$nieuw,
            stringsAsFactors = FALSE
        )
        cat('Einde aan elkaar plakken cdc onderdelen.\n')
        
    }
    rc_function <- 0
        

    if (rc_function == 0) {
        verplaats_bestand(bestandsnaam, log_dir, ingelezenlog_dir)
        cat('Logbestand', bestandsnaam, 'verplaatst naar')
        cat(ingelezenlog_dir, '.\n')
        rc_function <- 0
    }
    #  cat('Einde verwerk Dylos metingen:\n', colnames(ods_logmetingen))
    list(rc_function, ods_logmetingen)
}

