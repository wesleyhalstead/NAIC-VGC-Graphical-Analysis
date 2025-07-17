## Graph Generation

## Load adjacency matrix & igraph package
load('data/adjMat.RData')
diag(adjMat) <- 0
library(igraph)

## Create Graph Object -- this needs some work
g <- graph_from_adjacency_matrix(adjMat,
                                 weighted = TRUE,
                                 mode = 'directed')
#E(g)$width <- scale(E(g)$weight)[,1] + 1 - min(scale(E(g)$weight)[,1])
E(g)$width <- 20*E(g)$weight/111
E(g)$weight <- 1
V(g)$name <- unname(sapply(V(g)$name, function(x) str_replace(x,'&','\n')))
V(g)$color <- '#00bf7d'
E(g)$color <- rgb(.7,.7,.7,.4)

{
pdf('plots/mega_graph.pdf', width = 25, height = 25)
plot(g,vertex.size=4, edge.curved = 0.4,
     edge.width=E(g)$width,
     edge.arrow.size = E(g)$width/10,
     layout=layout_on_sphere(g))
dev.off()
browseURL('plots/mega_graph.pdf')
}


### Using qgraph
library(qgraph)

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

load('data/adjMat.RData')
diag(adjMat) <- 0

{pdf(file = 'plots/network_graph.pdf',
    height = 8.5,
    width = 8.5)

qgraph(adjMat,
       layout = 'spring',
       labels = labels1,
       directed=TRUE,
       bidirectional=FALSE,
       label.color = 'black',
       label.font = 2,
       edge.color = '#00bf7d',
       color = 'white',
       repulsion = 0.5,
       vsize = c(2.5,8))
dev.off()

browseURL('plots/network_graph.pdf')
}

## centrality w/ qgraph
Q <- qgraph(adjMat,labels = labels1)
c1 <- centrality(Q)
sort(c1$Closeness)
sort(c1$Betweenness)


## Centrality Measures
load('data/adjMat.RData')
g <- graph_from_adjacency_matrix(adjMat,
                                 weighted = T,
                                 mode = 'directed')
Eig1 <- eigen_centrality(g,directed = T)$vector

bet1 <- betweenness(g)
tail(sort(bet1))
