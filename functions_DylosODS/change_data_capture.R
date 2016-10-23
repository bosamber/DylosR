change_data_capture <- function (df_bron, df_doel, 
                                 key_vars, compare_vars, versienummer){
    
    # df_doel <- geldige_metingen
    # Alle variabelen uit het bron- en uit het doelbestand
    bron_variabelen <- colnames(df_bron)
    doel_variabelen <- colnames(df_doel)
    
    # Maak indicatoren voor aanwezigheid in bron en doelbestanden
    df_bron$cdc_bron    <- TRUE
    df_doel$cdc_doel    <- TRUE

    # Bewaar de oorspronkelijke variabelenaam van het versienummer
    varnaam_versienummer <- as.name(versienummer)
    
    # Merge op Date.Time, hernoem de variabelen uit de ingelezen bron
    df_merge <- merge(df_doel, df_bron, by = key_vars, 
                      all.x = TRUE, all.y= TRUE, suffixes = c('', '_nw'))
    
    # Vergelijk de waardes van de compare_vars
    df_merge$cdc_gelijk <- apply(df_merge[, c(compare_vars,
                                                 paste0(compare_vars, '_nw'))],
                                    MARGIN = 1, FUN=vergelijk_waardes)
    
    # Zet de NA's voor de cdc variabelen op FALSE
    df_merge$"cdc_bron"[is.na(df_merge[c("cdc_bron")])] <- FALSE
    df_merge$"cdc_doel"[is.na(df_merge[c("cdc_doel")])] <- FALSE
    df_merge$"cdc_gelijk"[is.na(df_merge[c("cdc_gelijk")])] <- FALSE
    
    # Bepaal status van elke meting
    # 'verdwenen', 'onveranderd', 'gewijzigd', 'nieuw'
    df_merge$cdc_status <- apply(df_merge[, c('cdc_bron', 'cdc_doel', 'cdc_gelijk')],
                                 MARGIN = 1, FUN=cdc_status)
    
    split_merge <- split(df_merge, df_merge$cdc_status, drop = TRUE)
    
    verdwenen   <- split_merge$verdwenen[doel_variabelen]
    onveranderd <- split_merge$onveranderd[doel_variabelen]
    afgesloten  <- split_merge$gewijzigd[doel_variabelen]
    wijziging   <- split_merge$gewijzigd[c(key_vars, paste0(compare_vars, '_nw'),
                                           versienummer)]
    if ( !is.null(wijziging) )
        colnames(wijziging) <- c(key_vars, compare_vars, varnaam_versienummer)
    
    nieuw       <- split_merge$nieuw[c(key_vars, paste0(compare_vars, '_nw'))]
    if ( !is.null(nieuw))
        colnames(nieuw) <- c(key_vars, compare_vars)
     
   return(list(verdwenen  = verdwenen,  onveranderd = onveranderd, 
               afgesloten = afgesloten, wijziging = wijziging, 
               nieuw = nieuw))
}

# test <- change_data_capture(ruwe_metingen, geldige_metingen,
#                                        'Date.Time', c('Small', 'Large'))
# # split_merge <- split(test, test$cdc_status, drop = TRUE)
