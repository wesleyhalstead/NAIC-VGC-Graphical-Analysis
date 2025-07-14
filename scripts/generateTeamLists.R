### Data Cleaning Part 1-- goal is to extract each restricted duo along with the name of the individual who played them
### Resulting data frame should have columns: playerName, restrictedDuo

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

## Did some teams did not use 2 restricted Pokemon?
sort(rowSums(!is.na(restrictedTeamsDF)))
which(rowSums(!is.na(restrictedTeamsDF))!=3)
## Yes! The teams placing 993, 1071, 1086, 1103, 1108, 1112, 1128, 1129 all did not use the full number of allowed restricted Pokemon.
## Two of these teams did not bring ANY restricted Pokemon


# String Concatenation to get duo names. The order of the restricted Pokemon is done alphabetically.
restrictedTeamsDF <- mutate(rowwise(restrictedTeamsDF), restrictedDuo = paste0(sort(c(X2,X3,X4,X5,X6,X7)),collapse = ' & '))


## Create new df with just playerName and restrictedDuo
restrictedDuosDF <- select(restrictedTeamsDF, X1, restrictedDuo)
restrictedDuosDF <- rename(restrictedDuosDF, playerName = X1)

## Save the df as a new csv
write.csv(restrictedDuosDF, file  = 'data/restrictedDuos.csv')
