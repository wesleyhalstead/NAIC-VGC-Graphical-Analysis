library(tidyverse)

load('data/adjMat.RData')

customHeatmap <- function(m){
  
  par(mai = c(3,2,3,0.5))

  m[m<5] <- NaN
  m1 <- t(m/(m+t(m)))
  diag(m1) <- NaN
  colIndex <- round((m1-min(m1, na.rm = T))/max(m1 - min(m1, na.rm = T), na.rm = T)*199 + 1)
  mapCols <- (hcl.colors(200, 'Temps',rev = T))[colIndex]
  mapCols[is.nan(m1)] <- '#00000000'
  
  plot.new()

  plot.window(xlim = c(0,max(row(m))+2), ylim = c(0,max(col(m))), asp = 1)
  
  rect(row(m)-1,col(m)-1,row(m),col(m),
       border = T)
  
  m2 <- m + t(m)
  diag(m2) <- NaN
  r1 <- (as.numeric((3/4)*sqrt(m2 - min(m2,na.rm = T))/sqrt(max(m2,na.rm = T)- min(m2,na.rm = T))) + 0.25)/2
  symbols(row(m)-0.5,ncol(m)+1-col(m)-0.5,circles = r1, inches = F, add = T,
          bg = mapCols)
  
  labels1 <- sub('&','&\n', rownames(m))
  
  mtext(rev(labels1), 2, at=1:ncol(m)-0.5, line = -0.5, cex = 0.75,las = 2, font = 2)
  mtext(labels1, 1, at=1:ncol(m)-0.5, line = -0.5, cex = 0.75, las = 2, font = 2)

  legend_image <- as.raster(matrix(hcl.colors(200, 'Temps', rev = F), ncol=1))
  rasterImage(legend_image, ncol(m) + 0.5, nrow(m)/2 -2, ncol(m) + 1, nrow(m)/2+2)
  text(x=rep(ncol(m) + 1.25,4), y=3.7*(0:4)/4 - 3.7/2 + nrow(m)/2 , labels = as.character((0:4)/4),
       adj = 0)
  
  par(mai = c(3,2.225,3,1.65))
  title(main = "Head-to-Head Win Rates\n of Popular Restricted Duos", line = 1)
}
{
pdf('plots/heatmap.pdf', 8.5,11)
customHeatmap(adjMat[1:10,1:10])
dev.off()
browseURL('plots/heatmap.pdf')
}


##########################################
##########################################
##########################################

customHeatmap <- function(m){
  
  par(mai = c(3,2,3,0.5))
  
  m[m<5] <- NaN
  m1 <- t(m/(m+t(m)))
  diag(m1) <- NaN
  colIndex <- round((m1-min(m1, na.rm = T))/max(m1 - min(m1, na.rm = T), na.rm = T)*199 + 1)
  mapCols <- (hcl.colors(200,'Temps',rev = T))[colIndex]
  mapCols[is.nan(m1)] <- '#00000000'
  borderCols <- rep('#00000000', ncol(m)*nrow(m))
  borderCols[is.nan(m1)] <- '#00000000'
  
  plot.new()
  
  plot.window(xlim = c(0,max(row(m))+2), ylim = c(0,max(col(m))), asp = 1)
  
  rect(row(m)-1,ncol(m)-col(m),row(m),ncol(m)+1-col(m),
       border = '#ffffff',
       col = mapCols)

  labels1 <- sub('&','&\n', rownames(m))
  
  mtext(rev(labels1), 2, at=1:ncol(m)-0.5, line = -0.5, cex = 0.75,las = 2, font = 2)
  mtext(labels1, 1, at=1:ncol(m)-0.5, line = -0.5, cex = 0.75, las = 2, font = 2)

  legend_image <- as.raster(matrix(hcl.colors(200, 'Temps', rev = F), ncol=1))
  rasterImage(legend_image, ncol(m) + 0.5, nrow(m)/2 -2, ncol(m) + 1, nrow(m)/2+2)
  text(x=rep(ncol(m) + 1.25,4), y=3.7*(0:4)/4 - 3.7/2 + nrow(m)/2 , labels = as.character((0:4)/4),
       adj = 0)
  
  par(mai = c(3,2.225,3,1.65))
  title(main = "Head-to-Head Win Rates\n of Popular Restricted Duos", line = 1)
  
  # text(row(m)-0.5,ncol(m)-col(m)+0.5,
  #      sub(NaN, '',round(m1,2)),
  #      cex = 0.75)
}
{
  pdf('plots/heatmapNoUsage.pdf', 8.5,11)
  customHeatmap(adjMat[1:10,1:10])
  dev.off()
  browseURL('plots/heatmapNoUsage.pdf')
}

{
  png('plots/heatmapNoUsage.png', 8.5,11,unit = 'in', res = 200)
  customHeatmap(adjMat[1:10,1:10])
  dev.off()
}

