cdc_status <- function(merge_regel) {
    # print(names(merge_regel))
    # cat('merge_regel$oud', merge_regel['oud'])
    if (merge_regel['cdc_doel'] == TRUE && merge_regel['cdc_bron'] == FALSE){
        cdc_status <- 'verdwenen'
    } else if (merge_regel['cdc_doel'] == TRUE && merge_regel['cdc_bron'] == TRUE) {
        if (merge_regel['cdc_gelijk'] == TRUE) {
            cdc_status <- 'onveranderd'
        } else {
            cdc_status <- 'gewijzigd'
        }
    } else if (merge_regel['cdc_doel'] == FALSE && merge_regel['cdc_bron'] == TRUE) {
        cdc_status <- 'nieuw'
    }
    return(cdc_status)
}    