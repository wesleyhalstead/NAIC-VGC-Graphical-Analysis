# Exploratory Analysis of VGC Restricted Pairs at Pokemon's North America International Championship

## Introduction

Pokemon Video Game Championships (VGC) is the official competitive format for the Pokemon video game series by The Pokemon Company and the [Play! Pokemon](https://www.pokemon.com/us/play-pokemon) program. Derived from the popular Pokemon video game series, the VGC format sees individuals forming teams of six Pokemon to battle other teams in a simultaneous-turn-based contest.

Similar to popular trading card games, individuals are able to form their teams from a wide range of available characters that can be customized as players see fit. The pool of Pokemon that are available to be selected for an individual's team are determined by the current regulation format. As of 7/24/2025, the current regulation format is [Regulation I](https://scarletviolet.pokemon.com/en-us/events/regulation-i/).

Regulation I is known as a "double restricted" format-- allowing each team to include up to two (typically) more powerful restricted special Pokemon. Teams designed for play in double restricted formats are typically designed to support their duo of powerful restricted Pokemon and enable them to take advantage of their strong moves and unique abilities.

This repository aims to perform an exploratory data analysis of restricted duos, gaining insight into their performance and seeing how their teams are constructed.

## Data Cleaning

The data used here come from the masters division of the most recent Regulation I tournament, as of the time of writing, the North America International Championship 2025 (NAIC) and can be found [here](https://www.pokedata.ovh/standingsVGC/0000149/masters/)

In the file [generateTeamLists.R](scripts/generateTeamLists.R), the JSON file is parsed and formatted into a dataframe including just the name of each individual competitor, and a single name representing restricted Pokemon used on their team. In the file [matrixGenerationAndWinRates.R](scripts/matrixGenerationAndWinRates.R), we iterate over the previous dataframe to generate an adjacency matrix $A$ such that $a_{i,j}$ is the number of wins that a restricted duo $i$ has against team $j$.

Additionally, there is a "Top Cut" adjacency matrix that is generated as well in matrixGenerationAndWinRatesTOP.R](scripts/matrixGenerationAndWinRatesTOP.R). Again, this matrix indicates which duos have victories over others; however, we only look at teams that placed in the top 100 of the final standings (about the top 10%). Since these tournaments are open signups, subsetting our data may give better insight into these matchups at a higher level.

## Analysis

![Testing this out](plots/dotchart_placement.png)
