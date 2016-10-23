
# Bij aanroep quotes om de key_variable zetten
get_max_key <- function(df_in, key_variable) {
    if (nrow(df_in) == 0) 
        max_key <- 0
    else 
        max_key <- max(df_in[key_variable])
    
    max_key
}