lees_1DylosLog_metingen <- function (log_bestand){
    # inlezen dataregels gedownloade log van Dylos DC1700
    df_logdata <- read.csv(log_bestand,
                         sep = ",", skip = 7, header = TRUE,
                         stringsAsFactors=FALSE)
    df_logdata
}