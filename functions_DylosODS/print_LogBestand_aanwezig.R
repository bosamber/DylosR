print_LogBestand_aanwezig <- function (naam_aanwezig, ods_logbestand){
    print(ods_logbestand[naam_aanwezig,
                         c('logbestand_id','logbestand_naam','logbestand_mtime',
                           'import_datumtijd','import_status')])
}
