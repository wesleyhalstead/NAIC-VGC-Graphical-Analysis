### Packages
library(tidyverse)

### Read data

restrictedDuos <- as_tibble(read.csv('data/restrictedDuos.csv'))

restrictedDuos <- filter(restrictedDuos, playerName != '')
restrictedDuos$restrictedDuo[restrictedDuos$restrictedDuo == ''] <- "NONE"

sort(table(restrictedDuos$restrictedDuo), decreasing = T)

## Create table of most common duos
t1 <- sort(table(restrictedDuos$restrictedDuo), decreasing = T)


## Pie chart
pie(t1,
    labels = names(t1)[1:9])


## Producing dotchart of usage rates
nt1 <- names(rev(t1))

pdf(file = 'plots/dotchart_usage.pdf',
    height = 11,
    width = 8.5,
    pointsize = 12)
{
dotchart(as.numeric(rev(t1)),
         labels = nt1,
         cex = 0.65, pt.cex = 1,
         pch = 1)
abline(v = (0:5)*50, lty = 2,  col = rgb(1,0,0, alpha = 0.6),
       lwd = 1.5)
abline(v = (0:4)*50+25, lty = 2, col = rgb(1,0,0, alpha = 0.2),
       lwd = 1.5)
}
dev.off()

## Producing dotchart of placement
restrictedDuosPlacement <- restrictedDuos %>% group_by(restrictedDuo) %>% summarise(avgPlacement = mean(X),
                                                                                    medPlacement = median(X),
                                                                                    highestPlacement = min(X)) %>%
  arrange((avgPlacement))

{
dotchart(x= rev(pull(restrictedDuosPlacement, avgPlacement)),
         labels =  rev(pull(restrictedDuosPlacement, restrictedDuo)),
         cex = 0.65, pt.cex = 1,
         pch = 1)
abline(v = (1:5)*200, lty = 2,  col = rgb(1,0,0, alpha = 0.6),
       lwd = 1.5)
abline(v = (1:5)*200+100, lty = 2, col = rgb(1,0,0, alpha = 0.2),
       lwd = 1.5)
  }

restrictedDuosPlacement <- restrictedDuosPlacement %>% arrange((medPlacement))
{
  dotchart(x= rev(pull(restrictedDuosPlacement, medPlacement)),
           labels =  rev(pull(restrictedDuosPlacement, restrictedDuo)),
           cex = 0.65, pt.cex = 1,
           pch = 1)
  abline(v = (1:5)*200, lty = 2,  col = rgb(1,0,0, alpha = 0.6),
         lwd = 1.5)
  abline(v = (1:5)*200+100, lty = 2, col = rgb(1,0,0, alpha = 0.2),
         lwd = 1.5)
}

restrictedDuosPlacement <- restrictedDuosPlacement %>% arrange((highestPlacement))

{
  dotchart(x= rev(pull(restrictedDuosPlacement, highestPlacement)),
           labels =  rev(pull(restrictedDuosPlacement, restrictedDuo)),
           cex = 0.65, pt.cex = 1,
           pch = 1)
  abline(v = (0:5)*200, lty = 2,  col = rgb(1,0,0, alpha = 0.6),
         lwd = 1.5)
  abline(v = (0:5)*200+100, lty = 2, col = rgb(1,0,0, alpha = 0.2),
         lwd = 1.5)
}


### Trying to produce multiple placement summaries on same plot
temp1 <- restrictedDuosPlacement %>% pivot_longer(
  !restrictedDuo
)

sortingOrder <- rep(restrictedDuosPlacement$highestPlacement, each = 3)

library(lattice)

pdf(file = 'plots/dotchart_placement.pdf',
    height = 11,
    width = 8.5,
    pointsize = 12)
{
dotplot(reorder(restrictedDuo,-sortingOrder)~value, data=temp1,
        groups = name,
        pch = 20,
        scale=list(y=list(cex=.5)
        ),
        key=list(x=.99,y=0.99,corner=c(1,1), cex = 0.5,
                 transparent = F,
                 border = T,
                 text = list(c('Highest Placement','Median Placement','Mean Placement')),
                 points = list(pch= 20,20,20, cex = .75,
                               col = palette.colors(palette = "Okabe-Ito")[c(2, 6, 4)])
                 )
        )
}
dev.off()
