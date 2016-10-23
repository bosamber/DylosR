# DylosR
R code to process logs from Dylos DC1700, for personal use.

## Disclaimer
This is the raw, undocumented draft version with hardly any comments. It does not meet coding standards. Also: for functions, variables and comments I used Dutch. This version is meant for geeks who can read R and Dutch. Further documentation will be in Dutch too. Lovely language. 

### Promise
If ever I find enough time and after software patents have been deleted from all the legal systems, I may create and support a version for other humans than Dutch geeks.

## Achtergrond
De Dylos DC1700 houdt een week aan metingen bijhoudt en heeft een beperkte grafische weergave van de metingen. Omdat ik over langere periodes data wil kunnen analyseren en rapportages wil kunnen maken, heb ik in R code geschreven die verschillende downloads aan elkaar plakt (en daarbij vergelijkt wat er al aan metingen was, de ODS laag), die variabelen toevoegt om rapportage iets gemakkelijk maakt (de DM laag) en die per dag een plot maakt van de Small en Large meetwaardes afgezet tegen de tijd. Deze rapportages worden weggeschreven naar een .png-bestand.

Deze code is een ruwe versie, bedoeld voor gebruik door mijzelf. Mijn reden om de code op github te zetten is dat anderen dan kunnen controleren hoe ik de data verwerk en dat iemand met vergelijkbare kennis die dit ook wil doen niet alle code zelf hoeft te schrijven. 

Mensen die niet kunnen programmeren raad ik af om hiermee aan de slag te gaan. Een beginnerscursus Rstudio (of R), enige ervaring met dataverwerking en kennis van github zijn miinimale vereisten om dit te kunnen.

## Hoe werkt het?

Hieronder staat de wijze waarop het volgens mij zou moeten werken.

1. Maak de directories aan die in de 'Dylos_config.R' staan (of je past de directorynamen daar aan);
2. Zet de R code van deze repository in de 'app_dir', inclusief de functiedirectorie;
3. Zet een download van de Dylos DC 1700 in de 'log_dir';
4. Geef deze de naam 'DylosLog_jjjjmmdd.txt' NB. Vervang de 'jjjjmmdd' door de datum waarop je de download hebt gemaakt;
5. Open RStudio;
6. Voer DylosODS.R uit. Dit leest de Dylos log in en vergelijkt het met de aanwezige historie;
7. Voer DylosDM.R uit. Dit haalt de geldige versies uit de historie en zet variabelen klaar voor rapporten;
8. Voer Dylos DylosDagPlot.R uit. Dat maakt voor elke dag waarvan metingen in DylosDM zitten, een plot aan.

## Verbeteringen
Heb je als data programmeur concrete, gedocumenteerde suggesties voor verbeteringen, dan wil ik ze natuurlijk wel horen, maar ik heb al een hele lijst van dit-moet-beter-dingen in mijn hoofd (want enigszins perfectionist) en je bent sneller klaar als je zelf een versie maakt (zie ook: licentie). 
