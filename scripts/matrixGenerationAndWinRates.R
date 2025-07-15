####### Generate adjacency matrix for each player and use this to then create one for each restricted duo

### Read data
library(rjson)
library(tidyverse)

### Read json data
tournamentData <- fromJSON(file = "data/NAIC_VGC_Data.json")
### Read csv data
restrictedDuos <- read.csv(file = 'data/restrictedDuos.csv')
###Remove missing teams
# restrictedDuos <- restrictedDuos[restrictedDuos$playerName != '',]
### Add in NONE for teams with no restricteds
restrictedDuos$restrictedDuo[restrictedDuos$restrictedDuo == ''] <- 'NONE'
### Duos list
duosList <- unique(restrictedDuos$restrictedDuo)


### Create empty adjacency matrix
### Adjacency matrix will ge generated such that a_{i,j} is the numer of wins that duo i has over duo j
adjMat <- matrix(0,nrow = 86,ncol = 86)
rownames(adjMat) <- duosList
colnames(adjMat) <- duosList


### Filing in values on matrix
### Cycle through json data to fill in wins


for(i in restrictedDuos$playerName[restrictedDuos$playerName!='']){
  tempDuoI <- restrictedDuos$restrictedDuo[restrictedDuos$playerName == i]
  l <- which(sapply(tournamentData, function(x) (x$name == i)))
  lostNames <- tournamentData[[l]]$rounds[sapply(tournamentData[[l]]$rounds, function(x) (x$result == 'W'))] %>%
    sapply(function(x) (x$name))
  lostDuos <- table(restrictedDuos$restrictedDuo[restrictedDuos$playerName %in% lostNames])
  adjMat[tempDuoI,names(lostDuos)] <- adjMat[tempDuoI,names(lostDuos)] + lostDuos
}


### From this we can calculate win percentages
nWins <- rowSums(adjMat)
nLosses <- colSums(adjMat)
winPercent <- nWins/(nWins+nLosses)
winPercent <- sort(winPercent)


### Plotting Win Percentages
pdf(file = 'plots/dotchart_winrate.pdf',
    height = 11,
    width = 8.5,
    pointsize = 12)
{
dotchart(x = winPercent,
         labels = names(winPercent),
         cex = 0.65, pt.cex = 1,
         pch = 20, lcolor = rgb(0,0,0,0),,xlab = 'Win Rate')
title(main = list(
  'Win Rate of Restricted Duos',
  cex = .8))
grid(nx = NULL, ny = 87)
points(winPercent, seq_along(winPercent), pch = 20)
}
dev.off()

## Simultaneous confidence intervals w/ Bonferroni correction
## Only use teams with at least 10 wins and 10 losses
## Pre-Processing
winPercent2 <- nWins/(nWins+nLosses)
nMatches <- (nWins+nLosses)[(nWins > 10) & (nWins > 10)]
winPercent2 <- winPercent2[(nWins > 10) & (nWins > 10)]
nMatches <- nMatches[order(winPercent2)]
winPercent2 <- sort(winPercent2)

## Interval calculation
alpha <- 1 - .95/length(winPercent2)
zStar <- qnorm(alpha)
upperBound <- pmin(winPercent2 + zStar*sqrt(winPercent2*(1-winPercent2)/(nMatches)), 1)
lowerBound <- pmax(winPercent2 - zStar*sqrt(winPercent2*(1-winPercent2)/(nMatches)),0)


## Plotting
pdf(file = 'plots/dotchart_winrateinterval.pdf',
    height = 11,
    width = 8.5,
    pointsize = 12)
{
dotchart(x = winPercent2,
         labels = names(winPercent2),
         cex = 0.65, pt.cex = 1,
         pch = 20, lcolor = rgb(0,0,0,0),
         xlim = c(min(lowerBound),max(upperBound)),xlab = 'Win Rate')
title(main = list(
  '95% Pairwise Confidence Intervals for the Win Rate of Restriced Duos\nfor Teams with at Least 10 Wins and 10 Losses',
  cex = 0.8))
grid(nx = NULL, ny = length(winPercent2)+1)

temp <- lapply(seq_along(upperBound), function(x) lines(c(upperBound[x],upperBound[x]),c(x-0.2,x+0.2), col = rgb(0,0,0,0.3)))       
temp <- lapply(seq_along(lowerBound), function(x) lines(c(lowerBound[x],lowerBound[x]),c(x-0.2,x+0.2), col = rgb(0,0,0,0.3)))       
temp <- lapply(seq_along(lowerBound), function(x) lines(c(lowerBound[x],upperBound[x]),c(x,x), col = rgb(0,0,0,0.3)))

points(winPercent2, seq_along(winPercent2), pch = 20)
}
dev.off()
