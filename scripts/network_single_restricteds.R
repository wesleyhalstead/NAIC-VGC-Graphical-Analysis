## Goal is to create a network analysis of restricted pokemon

########################################################################################

### Load Packages
library(rjson)
library(tidyverse)

### Read json data
tournamentData <- fromJSON(file = "data/NAIC_VGC_Data.json")
nparticipants <- length(tournamentData) 

### Generate empty dataframe
teamsDF <- data.frame(
  matrix(rep(times = nparticipants, c("","","","","","","")),nrow = nparticipants)
)



### Some teams are missing all their Pokemon, so we will loop through available ones.
## I have manually found rows without teams listed and removed them myself
for(i in (1:nparticipants)[c(-790,-845)]){
  v1 <- 
    teamsDF[i,] <- c(
      unlist(tournamentData[[i]]$name),
      head(c(unlist(unstack(stack(unlist(tournamentData[[i]]$decklist, recursive = F)))$name),NA*1:6),6)
    )
}

## Convert to tibble for some easy data manipulation
teamsDF <- as_tibble(teamsDF)


## We need a list of restricted Pokemon
restrictedPokemon <- c(
  'Mewtwo',
  'Lugia',
  'Ho-Oh',
  'Kyogre',
  'Groudon',
  'Rayquaza',
  'Dialga',
  'Palkia',
  'Giratina',
  'Reshiram',
  'Zekrom',
  'Kyurem',
  'Cosmog',
  'Cosmoem',
  'Solgaleo',
  'Lunala',
  'Necrozma',
  'Zacian',
  'Zamazenta',
  'Eternatus',
  'Calyrex',
  'Koraidon',
  'Miraidon',
  'Terapagos'
)

## Delete non-restricted Pokemon names
restrictedTeamsDF <- mutate_at(teamsDF,vars(-X1),
                               function(x) if_else(vapply(x, function(y) as.logical(max(str_detect(y,restrictedPokemon))),
                                                          logical(1)),x,NA))


restrictedTeamsDF <- mutate(rowwise(restrictedTeamsDF),
                            restrictedDuo1 = (sort(c(X2,X3,X4,X5,X6,X7))[1]),
                            restrictedDuo2 = (sort(c(X2,X3,X4,X5,X6,X7))[2]))
restrictedDuosDF <- select(restrictedTeamsDF, restrictedDuo1, restrictedDuo2)



#############################################################################
library(igraph)
library(qgraph)

## Convert DF to adjacency matrix
adjMat <- rbind(as.matrix(restrictedDuosDF),as.matrix(restrictedDuosDF[,c(2,1)]) ) %>%
  as.data.frame() %>% table() %>% matrix( ncol=ncol(.), dimnames=dimnames(.))


## Write out names
extract_initials <- function(text) {
  # Special handling: replace "Ho-oh" with "Hooh" so "Ho" is preserved
  text <- gsub("(?i)ho-oh", "Hooh", text, perl = TRUE)
  
  # Match word starts (after space/punct/start), extract 3 alphanumeric characters
  matches <- regmatches(
    text,
    gregexpr("(?i)(?:(?<=^)|(?<=[\\s[:punct:]]))[^[:punct:]\\s]*[A-Za-z0-9]{3}", text, perl = TRUE)
  )[[1]]
  
  # Remove non-alphanumerics and take first 3 characters
  cleaned <- substr(gsub("[^A-Za-z0-9]", "", matches), 1, 3)
  
  # Concatenate and remove "Ri" (case-insensitive)
  result <- paste(cleaned, collapse = "")
  gsub("(?i)rid", "", result, perl = TRUE)
}

labels1 <- row.names(adjMat) %>%
  sapply(extract_initials) %>% unname()

g <- as.igraph(q)

cluster_1 <- cluster_fast_greedy(g)


{pdf(file = 'plots/network_graph_individuals_groups.pdf',
     height = 8.5,
     width = 8.5)
q <- qgraph((adjMat),
       layout = 'groups',
       groups = cluster_1,
       labels = labels1,
       curve = 0.5,
       fade = F,
       curveAll = T,
       label.color = c('white'),
       label.font = 2,
       edge.color = '#00bf7db2',
       color = hcl.colors(5,'Temps'),
       repulsion = 1,
       legend = F,
       vsize = c(2.5,8))
dev.off()

browseURL('plots/network_graph_individuals_groups.pdf')
  }

{pdf(file = 'plots/network_graph_individuals.pdf',
     height = 8.5,
     width = 8.5)
  q <- qgraph((adjMat),
              layout = 'spring',
              groups = cluster_1,
              labels = labels1,
              curve = 0.5,
              fade = F,
              curveAll = T,
              label.color = c('white'),
              label.font = 2,
              edge.color = '#00bf7db2',
              color = hcl.colors(5,'Temps'),
              repulsion = 1,
              legend = F,
              vsize = c(2.5,8))
  dev.off()
  
  browseURL('plots/network_graph_individuals.pdf')
}

{pdf(file = 'plots/network_graph_individuals_nocluster.pdf',
     height = 8.5,
     width = 8.5)
  q <- qgraph((adjMat),
              layout = 'spring',
              labels = labels1,
              curve = 0.5,
              fade = F,
              curveAll = T,
              label.color = c('black'),
              label.font = 2,
              edge.color = '#00bf7db2',
              color = 'white',
              repulsion = .5,
              legend = F,
              vsize = c(2.5,8))
  dev.off()
  
  browseURL('plots/network_graph_individuals_nocluster.pdf')
}


Q <- qgraph(adjMat,labels = labels1)
c1 <- centrality(Q)
sort(c1$Closeness)
sort(c1$Betweenness)


#####################################
