maak_ODS_bestand <- function(ods_bestand) {
    DylosLog_bestand <- data.frame(logbestand_id=integer(),
                                   logbestand_naam=character(),
                                   logbestand_mtime=as.POSIXct(character()),
                                   softwareversie=character(),
                                   hardwareversie=character(),
                                   download_datumtijd_txt=character(),
                                   meeteenheid_txt=character(),
                                   import_datumtijd=as.POSIXct(character()),
                                   import_status=character(),
                                   stringsAsFactors=FALSE)
    DylosLog_meting <- data.frame(logbestand_id=integer(),
                                  logmeting_id=integer(),
                                  logmeting_versie=integer(),
                                  logmeting_geldig=logical(),
                                  Date.Time=character(),
                                  Small=integer(),
                                  Large=integer(),
                                  import_datumtijd=as.POSIXct(character()),
                                  stringsAsFactors=FALSE)
    
    save(DylosLog_bestand, DylosLog_meting, file = ods_bestand)
}
