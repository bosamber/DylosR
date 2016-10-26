# Verwijder objecten uit vorige run
rm(list=ls())
# Clear console
cat("\014")  

# Bewaar directory vanwaar dit programma is aangeroepen
oude_werkdirectory <- getwd()
# Ga naar de applicatie directory van dit programma
setwd('~/Applications/DylosR')

# Zet directories en bestandslocaties klaar
source('./Dylos_config.R', echo = TRUE)
function_dir     <- paste0(app_dir, 'functions_DylosODS/')

# Schrijf log vanaf nu ook naar een extern bestand
importlog  <- paste0(log_dir,"DylosODS_",format(Sys.time(), "%Y%m%d%H%M%S"), ".log")
sink(file = importlog, split = TRUE)


## Lees benodigde functies in
# Algemene functies
source(paste0(function_dir,'zoek_aanwezige_bestanden.R'))
source(paste0(function_dir,'get_max_key.R'))
source(paste0(function_dir,'verplaats_bestand.R'))
source(paste0(function_dir,'maak_ODS_bestand.R'))
source(paste0(function_dir,'check_ODS_bestand.R'))

# Hoofdfuncties voor verwerking
source(paste0(function_dir,'verwerk_1DylosLog_bestand.R'))

# Subfuncties voor verwerking
source(paste0(function_dir,'verwerk_1DylosLog_header.R'))
source(paste0(function_dir,'lees_1DylosLog_header.R'))
source(paste0(function_dir,'toevoegen_LogBestand.R'))
source(paste0(function_dir,'print_LogBestand_aanwezig.R'))
source(paste0(function_dir,'zoek_identiek_LogBestand.R'))

source(paste0(function_dir,'verwerk_1DylosLog_metingen.R'))
source(paste0(function_dir,'lees_1DylosLog_metingen.R'))
source(paste0(function_dir,'change_data_capture.R'))
source(paste0(function_dir,'vergelijk_waardes.R'))
source(paste0(function_dir,'cdc_status.R'))
source(paste0(function_dir,'opmaken_DylosLog_metingen.R'))

## De kanarie
continue_program <- TRUE
loopje <- 0

while (continue_program) {
    loopje <- loopje + 1
    cat('loopje:', loopje, '\n')
    
    ## Kijk of en welke DylosLog-bestanden in de download directory staan.
    aanwezige_logbestanden <- zoek_aanwezige_bestanden(Dyloslog_dir, log_pattern)
    
    if (aanwezige_logbestanden[[1]] == 0 ) {
        log_bestanden <- aanwezige_logbestanden[[2]]
    } else {
        cat('WARNING: Geen Dylos logbestanden aanwezig. Programma wordt afgebroken.\n')
        continue_program <- FALSE
        break
    }
    
    ## Kijk of de ODS bestanden aanwezig zijn.
    # Zo nee, dan worden ze aangemaakt. 
    rc_check_initial_load  <- check_ODS_bestand(Dylos_ods)
    if (rc_check_initial_load > 4){
        continue_program <- FALSE
        break
    }
    
    ## begin met verwerken van bestanden
    # Herhaal verwerking per bestand
    for (bestandsnaam in log_bestanden[1]) {
        bestandsnaam <- log_bestanden[1]
        # Verwerk het Dylos logbestand
        rc_verwerkt_logbestand <- verwerk_1DylosLog_bestand(Dyloslog_dir, ingelezenlog_dir,
                                                            bestandsnaam, Dylos_ods)
        
        if (is.na(rc_verwerkt_logbestand)) {
            cat('ERROR: Verwerking Dylos logbestand', bestandsnaam, 'niet voltooid.\n')
            cat('ERROR: Programma wordt gestopt.\n')
            continue_program <- FALSE
            break
        } else if ( rc_verwerkt_logbestand != 0){
            cat('ERROR: Verwerking Dylos logbestand', bestandsnaam, 'niet gelukt.\n')
            cat('ERROR: Programma wordt gestopt.\n')
            continue_program <- FALSE
            break
        }
    }
    
    continue_program <- FALSE
    # if (loopje > 5) continue_program <- FALSE
}

setwd(oude_werkdirectory)

# Verwijder alle objecten
rm(list=ls())

# Sluit de log af
sink()

