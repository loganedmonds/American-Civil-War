
## TODO:

**GLOBAL PROBLEMS**:
  
  **geocoding**
  
  *We can use the Google Maps API through ggmap::geocode()*
  -- approx. location based upon city/county
-- write.csv() to create new df with battle column?
  
  **verify geocoding**
  -- check lat/long against limits of contiguous U.S.
-- possibly check each state against limits of state lat/long?
  
  **Weird Character Encodings**
  -- '\x92', '\023', '\u0092', '<U+FFFD>'
-- What do these mean and can they be fixed in
read_csv() function args?
  -- UTC enconded?
  
  **How to split character list/matrix?**
  -- str_split not working as anticipated
-- would like to have each commander a seperate element
in each individual list
-- SO?
  -- Jenny Bryan?
  
  **VAR SPECIFIC PROBLEMS**:
  
  **battle**
  -- Check for duplicates: duplicated() and unique() functions

**other_names**
  -- Determine number of other names contained in each row
*str_count(other_names, ",") + 1*
  each other name is seperated by a comma, so the number of commas
plus one will give us the number of other names

-- Split character vector into list with 4+ columns
-- Split based upon ','
-- What to do with 232 character string? ~ 11 'other names'

**location_1**
  -- PROBLEM: Can we geocode at county level with R?
  
  *Google Maps API and ggmap::geocode() in the clutch*
  
  -- Only 29 values are not counties/parishes (i.e. Petersburg, VA)
non_county <- 
  civil_war %>% 
  select(location_1) %>% 
  filter(!str_detect(location_1,"County|Parish"))

-- Many of the non-county level values are duplicated
non_county %>% 
  filter(duplicated(.))

-- Remove White Space (i.e. Tampa , FL)
str_detect(civil_war$location_1, "[:space:],[:space:]")

-- Recode values that can not be extracted from Google Maps API 
through ggmap::geocode() 
* 'Unknown, OK' = 'Yale, OK' (Battle of Round Mountain)
* 'Unknown, OK' = 'Pontotoc County, OK' (Middle Boggy Depot Battle)
* 'Pointe Coupe<e9> Parish, LA' = 'Pointe Coupee Parish, LA'   

**location2:4**
  -- Drop these vars?
  -- OR geocode as well?
  
  **campaign Regex**
  -- Remove (Month - Month Year) from end of string
-- Comment on Regex --> For future self!
  
