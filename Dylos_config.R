#=============================================================================#
### DylosODS Configuratie

## bestandslocaties van data, code en applicatielog
# directories
log_dir          <- '~/Logs/Dylos/'                     # applicatie log
app_dir          <- '~/Applications/DylosR/'

Dyloslog_dir     <- '~/Data/Dylos/DylosLogs/'           # gedownloade Dylos logs
ingelezenlog_dir <- '~/Data/Dylos/DylosLogs/ingelezen/' # ingelezen Dylos logs
ods_dir          <- '~/Data/Dylos/DylosODS/'            # ODS (ingelezen historie)
dm_dir           <- '~/Data/Dylos/DylosDM/'             # DM (rapporten)
plot_dir         <- '~/Data/Dylos/grafieken/'           # Grafieken

# bestanden
Dylos_ods        <- paste0(ods_dir,'DylosODS.Rdata')    # ODS (ingelezen historie)
Dylos_dm         <- paste0(dm_dir,  'DylosDM.Rdata')    # DM (voor rapporten)
log_pattern      <- "^DylosLog_[[:digit:]]{8}.txt$"     # bestandsnaam Dylos logs

# De Dylos bevatte ook oudere metingen (testruns of van andere mensen?)
# Om te bewaren selecteer ik vanaf de begindatumtijd van mijn metingen
begindatumtijd  <- "2016-10-01 14:00"

# Package chron is nodig om datumtijd netjes grafisch weer te geven
library(chron)

#=============================================================================#
