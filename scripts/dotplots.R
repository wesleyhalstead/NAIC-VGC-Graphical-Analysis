### Watermark to be used
watermark = ''

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
####################################
nt1 <- names(rev(t1))

pdf(file = 'plots/dotchart_usage.pdf',
    height = 11,
    width = 8.5,
    pointsize = 12)
{
dotchart(as.numeric(rev(t1)),
         labels = nt1,
         cex = 0.65, pt.cex = 1,
         pch = 20)
  grid(nx = NULL, ny = NULL)
  
  points(as.numeric(rev(t1)), pch = 20, 1:86)
  
  text(200,1, adj = c(1,0),watermark,col = rgb(.8,.8,.8,.4),
       cex = 3)
}
dev.off()
#####################################

## Producing dotchart of placement summary stats -- first need to calculate them
restrictedDuosPlacement <- restrictedDuos %>% group_by(restrictedDuo) %>% summarise(avgPlacement = mean(X),
                                                                                    medPlacement = median(X),
                                                                                    highestPlacement = min(X)) %>%
  arrange((avgPlacement))

## Commenting old work out
{
"{
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
}"
}

restrictedDuosPlacement <- restrictedDuosPlacement %>% arrange((highestPlacement))

## Commenting old work out
{
"{
  dotchart(x= rev(pull(restrictedDuosPlacement, highestPlacement)),
           labels =  rev(pull(restrictedDuosPlacement, restrictedDuo)),
           cex = 0.65, pt.cex = 1,
           pch = 1)
  abline(v = (0:5)*200, lty = 2,  col = rgb(1,0,0, alpha = 0.6),
         lwd = 1.5)
  abline(v = (0:5)*200+100, lty = 2, col = rgb(1,0,0, alpha = 0.2),
         lwd = 1.5)
}"
}


#### Attempting to put multiple summaries with dotchart
#######################################################
temp1 <- as.data.frame(restrictedDuosPlacement)

pdf(file = 'plots/dotchart_placement.pdf',
    height = 11,
    width = 8.5,
    pointsize = 12)
{
dotchart(x= rev(temp1$highestPlacement),
         labels =  rev(temp1$restrictedDuo),
         cex = 0.65, pt.cex = 1,
         pch = 20, lcolor = rgb(0,0,0,0))

grid(nx = NULL, ny = 87)

points(temp1$avgPlacement,86:1, col = '#00bf7d', pch = 20)
points(temp1$medPlacement,86:1, col = '#5928ed', pch = 20)
points(temp1$highestPlacement,86:1, pch = 20)

legend('bottomleft', inset = 0.01, legend = c('Highest Placement','Median Placement','Mean Placement'),
       cex = 0.65, fill = c('black','#5928ed','#00bf7d'))

text(1100,1, adj = c(1,0),watermark,col = rgb(.8,.8,.8,.4),
     cex = 3)
}
dev.off()
#######################################################

