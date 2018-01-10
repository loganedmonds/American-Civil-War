
# General Import and Basic Clean-Up

library(dplyr)
library(ggmap)
library(ggplot2)
library(lubridate)
library(readr)
library(stringr)
library(tidyr)
library(visdat)


civil_war <- read_csv("data/civil_war_battle_summaries.csv")

names(civil_war) <- str_to_lower(names(civil_war))

# Remove unnecessary columns
civil_war <-
  civil_war %>% 
    select( -c(`cwsac ref`, `preservation priority`, `national park unit`, 
               `start month`, `start day`, `start year`,
               `end month`, `end day`, `end year`,
               `nps site`, description, `forces engaged`, `est casualties`)) 

# Cleaning up variable names
# Replace spaces and special characters
names(civil_war) <- str_replace_all(names(civil_war), " ", "_")
names(civil_war) <- str_replace_all(names(civil_war), "\\.", "")
names(civil_war) <- str_replace_all(names(civil_war), "\\(s\\)", "s")
names(civil_war) <- str_replace_all(names(civil_war), "\\?", "")

# Select: rearranging vars into logical order
# Mutate: create POSIX date values
# Rename: # character requires ` ` escape in order to call var
civil_war <-
  civil_war %>% 
    select(battle:location_1, location_2:location_4,
           everything()) %>% 
    mutate(start_date = mdy(start_date),
           end_date = mdy(end_date)) %>% 
    rename(us_commanders = principal_us_commanders,
           cs_commanders = principal_cs_commanders,
           days_battle = `#_days_battle`,
           multiple_states = battle_in_multple_states)

## NA VALUES
# We can see that a majority of other_names and location rows are NA's
# It is likely that the number of casualties that are NA's is higher
# Many casualties are coded as "Unknown", etc.

vis_miss(civil_war)

## Strings

# Removing (Month - Month, Year) from end of string

civil_war$campaign <-
  str_replace_all(civil_war$campaign,
                  "[:space:]\\(.{0,30}\\)", "")

# Adding missing 'and'
civil_war$campaign <- 
  str_replace(civil_war$campaign, 
              ",[:space:]Ohio", ", and Ohio")

# Removing UTC miscoding
# \023 can not be encoded into R

civil_war$campaign[318] <- 
  "Richmond-Petersburg Campaign"


civil_war$location_1 <- 
  str_replace(civil_war$location_1, "[:space:],", ",")

# Remove unecessary [US] designations
# Note the use of escape characters for '[' and ']'
civil_war$us_commanders <- 
  str_replace(civil_war$us_commanders, 
              "[:space:]\\[US\\]", "")


# Repeat process for Confederate commanders
civil_war$cs_commanders <-
  str_replace(civil_war$cs_commanders, 
              "[:space:]\\[CS\\]", "")

# We need to  remove [I] for Indian commanders as well
# Or we could create 'indian_commander' var with 0/1 or "Yes"/"No"

# Split battles with two commanders into seperate vars
# Remove unecessary "and"

# civil_war$cs_commanders <- 
  # str_split(civil_war$cs_commanders, 
                  # " and ", n = 2)

# Repeat process for Union commanders
# civil_war$us_commanders <- 
  # str_split(civil_war$us_commanders,
                  # " and ", n = 2)

# Replace miscoded "Union Victory" value
# Now all results are Confederate/Union - "victory"
civil_war$results <- 
  str_replace(civil_war$results, "V", "v")

# Remove ',' that coerces NAs with as.numeric()
civil_war$total_est_casualties <- 
  str_replace(civil_war$total_est_casualties,
              ",", "")

civil_war$us_est_casualties <- 
  str_replace(civil_war$us_est_casualties, 
              ",", "")

# 'I unknown' is equivalent to 'Indian casualties unknown'

civil_war$cs_est_casualties <- 
  str_replace_all(civil_war$cs_est_casualties, ",", "")


## Factors
civil_war$state <- factor(civil_war$state,
                          levels = names(sort(table(civil_war$state))))

civil_war$results <- factor(civil_war$results)

civil_war$multiple_states <- factor(civil_war$multiple_states)

# Coerce casualties to numeric
civil_war$total_est_casualties <- as.numeric(civil_war$total_est_casualties)
civil_war$us_est_casualties <- as.numeric(civil_war$us_est_casualties)
civil_war$cs_est_casualties <- as.numeric(civil_war$cs_est_casualties)

## Geocoding

# Change 'Pointe Coup<e9> Parish, LA' to 'Pointe Coupee Parish, LA'
civil_war$location_1[str_detect(civil_war$location_1, "Pointe")] <- "Pointe Coupee Parish, LA"

# Change 'Unknown, OK' (Battle of Round Mountain) to 'Yale, OK'
civil_war$location_1[29] <- "Yale, OK"

# Change 'Unknown, OK' (Middle Boggy Depot Battle) to 'Pontotoc County, OK'
civil_war$location_1[227] <- "Pontotoc County, OK"


# Google Maps has an API query limit 
# Please be aware before running the below code

# battle_latlong <- ggmap::geocode(civil_war$location_1)

write.csv(civil_war, file = "results/civil_war_clean.csv")



