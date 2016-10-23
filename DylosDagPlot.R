# Maakt per dag waarvoor metingen aanwezig zijn een plot waarin
# de aantallen Small en Large zijn afgezet tegen de tijd

# Verwijder objecten uit vorige run
rm(list = ls())
# Clear console
cat("\014")  

# Bewaar directory vanwaar dit programma is aangeroepen
oude_werkdirectory <- getwd()
# Ga naar de applicatie directory van dit programma
setwd('~/Applications/Dylos')

# Zet directories en bestandslocaties klaar
source('./Dylos_config.R', echo = TRUE)
function_dir     <- paste0(app_dir, 'functions_DylosExport/')

# Schrijf log vanaf nu ook naar een extern bestand
importlog  <- paste0(log_dir, "DylosDagPlot_", format(Sys.time(), "%Y%m%d%H%M%S"), ".log")
sink(file = importlog, split = TRUE)

source(paste0(function_dir, 'maak_dagplot.R'))
#=============================================================================#
load(Dylos_dm)

dagen_aanwezig <- unique(DylosDM_metingen$meting_datum)
for (dag in dagen_aanwezig){
    dag_fmt <- (as.Date(dag, origin = "1970-01-01"))
    
    # Maak bestandsnaam voor plot aan
    plot_bestand <- paste0(plot_dir, 'Dagplot_',gsub("-", "", dag_fmt), '.png')
    cat(paste0('DagPlot wordt gemaakt voor: ', dag_fmt, ' in',
               plot_bestand), '\n')
    
    # Selecteer data voor plot
    plot_data     <- DylosDM_metingen[DylosDM_metingen$meting_datum == dag,
                                      c('meting_datum', 'meting_tijdstip',
                                        'Small_ft3', 'Large_ft3')]
    
    # Zet grafische uitvoer naar extern bestand
    png(filename = plot_bestand,
        width = 620, height = 480, units = "px", pointsize = 12,
        bg = "white")
        # res = NA, ...,
        # type = c("cairo", "cairo-png", "Xlib", "quartz"), antialias)
    # Maak plot
    maak_dagplot(dag_fmt, plot_data)
    
    dev.off()
}

#=============================================================================#
setwd(oude_werkdirectory)

# Verwijder alle objecten
rm(list=ls())

# Sluit de log af
sink()