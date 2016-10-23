verwerk_1DylosLog_header <- function(log_dir, ingelezenlog_dir,
                                     logbestand_naam, 
                                     ods_logbestand) {
    rc_function         <- NA
    logbestand_id       <- NA
    
    # Maak de volledige bestandsnaam aan van dit Dylos logbestand
    log_bestand         <- paste0(log_dir, logbestand_naam)

    # Bepaal de datum waarop het logbestand het laatst is aangepast
    logbestand_mtime    <- file.info(log_bestand)$mtime
    
    # Lees header uit Dylos logbestand. Vang returncode af.
    resultaat_leesheader<- lees_1DylosLog_header(log_bestand)
    if (resultaat_leesheader[[1]] != 0){
        rc_function   <- 8
        cat('ERROR: Header van ', logbestand_naam, 'niet ingelezen.\n')
    } else {
        header_regels <- resultaat_leesheader[[2]]
        
        # Kijk of de naam van het ingelezen logbestand al aanwezig is in de ods
        naam_aanwezig       <- grep(logbestand_naam, 
                                    ods_logbestand$logbestand_naam)
        # print(typeof(naam_aanwezig)); print(naam_aanwezig)
        if (length(naam_aanwezig) == 0) {
            cat('Logbestand', logbestand_naam, 'nog niet aanwezig in ODS bestand \n')
            # Voeg een nieuwe regel toe aan DylosLog_bestand
            resultaat_Logtoevoegen <- toevoegen_LogBestand(logbestand_naam, logbestand_mtime, 
                                                           header_regels, ods_logbestand)
            logbestand_id  <- resultaat_Logtoevoegen[[1]]
            ods_logbestand <- resultaat_Logtoevoegen[[2]]
            
            # Schrijf melding naar log en zet returncode
            cat('Logbestand', logbestand_naam, 'toegevoegd aan ODS bestanden.\n')
            rc_function   <- 0
        } else {
            cat('Logbestand', logbestand_naam, 'al aanwezig in ODS bestand \n')
            print_LogBestand_aanwezig(naam_aanwezig, ods_logbestand)
            # Kijk voor elke aanwezige regel of het identiek is qua mtime en inhoud. 
            # Eén bestand mag maar 1x voorkomen.
            resultaat_identiekeLog <- zoek_identiek_LogBestand(
                                        ods_logbestand[naam_aanwezig, ],
                                        logbestand_mtime, header_regels)
            logbestand_id <- resultaat_identiekeLog[[2]]
            
            if (resultaat_identiekeLog[[1]] == 0) {
                # Het Dylos logbestand is al ingelezen,
                # verplaats het bestand naar de folder ingelezen
                verplaats_bestand(logbestand_naam, log_dir, ingelezenlog_dir)
                cat('Logbestand', logbestand_naam, 'verplaatst naar')
                cat(ingelezenlog_dir, '\n')
                rc_function <- 0
            } else if (resultaat_identiekeLog[[1]] == 1){
                # Het Dylos logbestand is nog niet ingelezen, moet nog verwerkt
                cat('Logbestand',logbestand_naam, 'moet nog worden verwerkt.\n')
                rc_function <- 0
            } else if (resultaat_identiekeLog[[1]] == 2){
                # Het Dylos logbestand is gewijzigd tov eerdere versie
                cat('Deze versie van Logbestand', logbestand_naam, 'nog niet ')
                cat('aanwezig in ODS bestand \n')
                # Voeg een nieuwe regel toe aan DylosLog_bestand
                resultaat_Logtoevoegen <- toevoegen_LogBestand(logbestand_naam, 
                                                               logbestand_mtime, 
                                                               header_regels, 
                                                               ods_logbestand)
                
                logbestand_id  <- resultaat_Logtoevoegen[[1]]
                ods_logbestand <- resultaat_Logtoevoegen[[2]]
                # Schrijf melding naar log
                cat('Logbestand', logbestand_naam, 'toegevoegd aan ODS bestanden.\n')
                
                rc_function <- 0
            } else {
                cat('ERROR: geen idee wat ik nu moet.\n')
                rc_function <- 8
            }
 
        }
    }

    # ods_logbestand <- rbind(ods_logbestand, nieuwe_regel, 
    #                        stringsAsFactors=FALSE)
    list(rc_function, logbestand_id, ods_logbestand)
    
}


