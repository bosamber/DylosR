maak_dagplot <- function (plot_datum, plot_data){

    ## Maak een chron-time variabele aan (loopt van 0 tot 1)
    plot_data$chron_tijd <- times(paste0(plot_data$meting_tijdstip, ':00'))
    
    table(plot_data$meting_datum)
    ## Zet titel voor boven de dagplot klaar
    plot_titel    <- paste('fijnstofmeting', plot_datum)
    plot_subtitel <- paste('grafiek gemaakt op ', Sys.time(), 
                           '; metingen uitgevoerd met een Dylos DC1700')
    
    ## Zet de assen voor de dagplot klaar
    # x-as: tickmarks en labels
    x_tick  <- seq(from = 0, to = 1, by = (1/24))
    x_label    <- character()
    for (uur in 0:24) {
        x_label <- append(x_label, paste(formatC(uur, width=2, flag='0'), ':00', sep=''))
    }
    # y-as: tickmarks en labels
    y_tick     <- numeric()
    y_label    <- character()
    for (aantal in seq(0, 8000, by=1000)){
        y_tick <- append(y_tick, aantal)
        y_label<- append(y_label, as.character(aantal))
    }

    ## maak plot met gedefinieerde assen, lijnen en legenda
    # Maak eerst een lege plot
    plot(0, 
         type = 'n', xaxt = "n", yaxt = "n",
         main = plot_titel,
         sub  = plot_subtitel,
         xlim = c(0,   1), xlab = "",
         ylim = c(0, 8000), 
         ylab = "aantal deeltjes per 0.01ft³", las = 1
    )
    # Zet dan de assen erbij  
    axis(side = 1, at = x_tick, labels = x_label, las = 2)
    axis(side = 2, at = y_tick, labels = y_label, las = 2)
    
    # Voeg de lijngrafieken toe 
    lines(plot_data$chron_tijd, plot_data$Small_01ft3, type = "l", 
           col = "red",   cex = 0.5)
    lines(plot_data$chron_tijd, plot_data$Large_01ft3, type = "l", 
          col = "black", cex = 2)
    
    # Voeg de legenda toe 
    legend(0.8,8000, title="deeltjesgrootte", 
           legend=c("> 0,5 µm", "> 2,5 µm"), col=c("red","black"),
           cex=1, lty = 1)
    
}
    