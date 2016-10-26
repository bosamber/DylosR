omzetten_naar_01foot3 <- function(x){
    # Bepaal in welke meeteenheid de meting is vastgelegd (laatste variabele)
    if (x[2] == 'Particles per cubic foot')
        vermenigvuldig = .01
    else
        vermenigvuldig = 1
    
    # # Gooi de meeteenheid weg (laatste variabele)
    y <- as.numeric(x[1])
    
    # vermenigvuldig de overige waardes
    resultaat <- vermenigvuldig * y
    
    return(resultaat)
}
