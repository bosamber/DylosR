#=============================================================================#
### DylosODS Configuratie

## bestandslocaties van data, code en applicatielog
# directories
log_dir          <- '~/Logs/Dylos/'                     # applicatie log
app_dir          <- '~/Applications/DylosR/'            # applicatie code
data_dir         <- '~/Data/Dylos/'                     # data, hoofddirectory

Dyloslog_dir     <- paste0(data_dir,'DylosLogs/')       # Dylos logs: downloads
ingelezenlog_dir <- paste0(Dyloslog_dir,'ingelezen/')   # Dylos logs: verwerkt
ods_dir          <- paste0(data_dir,'DylosODS/')        # ODS (historie)
dm_dir           <- paste0(data_dir,'DylosDM/')         # DM (tbv rapporten)
export_dir       <- paste0(data_dir,'DylosExport/')     # uitvoer
plot_dir         <- paste0(export_dir,'grafieken/')     # uitvoer: grafieken
expcsv_dir       <- paste0(export_dir,'csv/')           # uitvoer: csv

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
