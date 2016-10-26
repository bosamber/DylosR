# Maak een datamart tabel aan met alle geldig metingen
# Controleer de meeteenheid per bronbestand:
# (deeltjes per 0.01 foot^3 of deeltjes per foott^3)

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
function_dir     <- paste0(app_dir, 'functions_DylosDM/')

# Schrijf log vanaf nu ook naar een extern bestand
importlog  <- paste0(log_dir,"DylosDM_",format(Sys.time(), "%Y%m%d%H%M%S"), ".log")
sink(file = importlog, split = TRUE)

## Lees benodigde functies in
source(paste0(function_dir,'omzetten_naar_01foot3.R'))
#=============================================================================#
load(Dylos_ods)

var_nodig <- c('logbestand_id', 'logmeting_id','Date.Time',
               'Small', 'Large')
ods_geldig <- DylosLog_meting[(DylosLog_meting$logmeting_geldig == TRUE),
                              var_nodig ]

# Converteer Date.Time variabele naar hanteerbare datumtijd-formaten
ods_geldig$meting_datumtijd <- as.POSIXct(strptime(
    as.character(ods_geldig$Date.Time), 
    "%m/%d/%y %H:%M"),
    tz="CEST")

# geheugen vrijmaken door weg te gooien wat niet meer nodig is
ods_geldig$Date.Time        <- NULL 
rm(DylosLog_meting)

# Selecteer mijn eigen metingen
dm_selectie <- ods_geldig[(ods_geldig$meting_datumtijd >=
                               as.POSIXct(strptime(begindatumtijd,
                                                   format = '%Y-%m-%d %H:%M',
                                                   tz = "CEST")

                                                                                    )), ]
rm(ods_geldig)

dm_merge <- merge(dm_selectie, DylosLog_bestand[c('logbestand_id',
                                                'meeteenheid_txt')], 
                  by.x = 'logbestand_id', 
                  by.y = 'logbestand_id',
                  all.x = TRUE)

table(dm_merge$meeteenheid_txt)
rm(list=c('dm_selectie', 'DylosLog_bestand'))

# Voeg datum, tijd variabelen toe
dm_merge$meting_datum     <- as.Date(dm_merge$meting_datumtijd,
                                           format="%Y-%m-%d", 
                                           tz="CEST")
dm_merge$meting_tijdstip  <- strftime(dm_merge$meting_datumtijd, 
                                        format="%H:%M", 
                                        tz="CEST")
dm_merge$maand            <- months(dm_merge$meting_datumtijd)

# Converteer de meetwaardes van verschillende meeteenheden naar aantal per
# cubic foot
table(dm_merge$meeteenheid_txt)

dm_merge$Small_01ft3 <-apply(dm_merge[ , c('Small', 'meeteenheid_txt')],
                       FUN = omzetten_naar_01foot3, MARGIN = 1)
dm_merge$Large_01ft3 <-apply(dm_merge[ , c('Large', 'meeteenheid_txt')],
                       FUN = omzetten_naar_01foot3, MARGIN = 1)
dm_merge$pm25_01ft3  <- dm_merge$Small_01ft3 - dm_merge$Large_01ft3

# verwijder kolom die niet meer nodig is
dm_merge$meeteenheid_txt <- NULL
dm_merge$Small <- NULL
dm_merge$Large <- NULL

# Sla data frame op als DylosDM
DylosDM_metingen <- dm_merge

save(file=Dylos_dm, DylosDM_metingen )
                             
#=============================================================================#
setwd(oude_werkdirectory)

# Verwijder alle objecten
rm(list=ls())

# Sluit de log af
sink()
