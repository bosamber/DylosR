# Functie om 1 record te vergelijken
# NB Heeft een even aantal waardes nodig
# NB De 1e helft van de waardes wordt vergeleken met de 2e helft
vergelijk_waardes <- function(compare_values){
    
    # Bepaal het aantal kolommen dat is meegegeven
    aantal_kolommen <- length(compare_values) 
    
    # Is het aantal kolommen een even aantal? Zo nee, breek af.
    if (aantal_kolommen %% 2 != 0) {
        cat('ERROR: Oneven aantal kolommen aanwezig voor vergelijking.\n')
        resultaat <- NA
    } else {
        resultaat <- all(compare_values[1:(aantal_kolommen/2)] ==
                      compare_values[((aantal_kolommen/2)+1):aantal_kolommen])
    }
    return(resultaat)
}
