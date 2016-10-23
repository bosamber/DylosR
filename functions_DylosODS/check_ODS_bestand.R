check_ODS_bestand <- function(ods_bestand){
    rc_function <- NA # omdat de uitkomst van deze functie nog niet bekend is 
    
    # Kijk of het ODS bestand bestaat
    if (file.exists(ods_bestand)) {
        # Als het ODS-bestand wel aanwezig is, controleer dan of  
        # beide vereiste dataframes erin zitten
        load(ods_bestand)
        if (exists('DylosLog_bestand') && exists('DylosLog_meting') 
            && is.data.frame(get('DylosLog_bestand'))
            && is.data.frame(get('DylosLog_meting')) ){  
            # Schrijf een melding naar de log
            cat('Dit is geen initial load. ODS-bestand', Dylos_ods, 'gevonden en ')
            cat('gecontroleerd\n')
            rc_function <- 0
        } else {
            # Schrijf een foutmelding in de log en zet een foutcode.
            cat('ERROR: Het ODS bestand is wel gevonden, maar bevat niet de juiste dataframes.\n')
            cat('ERROR: Controleer', Dylos_ods, '\nERROR: Programma wordt afgebroken. \n')
            rc_function <- 8 
        }
    } else {
        # Maak het ODS bestand aan
        maak_ODS_bestand(ods_bestand)
        cat('Dit is een initial load. ODS-bestand is aangemaakt.', Dylos_ods, '\n')
        rc_function <- 4
    }

    return(rc_function)
}