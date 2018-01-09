## Data Cleanup

This cleaned verison of the data includes several edits to the original **civil_war_summaries.csv** file. 

* Cleaned variable names --> removed unecessary spaces and special characters
* Character variable strings
  * Campaign names
  * Battle location names
  * Confederate and Union commander names
  * Casualties imported as character variables due to ","
* Variable coercions
  * Casualty variables to numeric
* UTC Standard Date Conventions
* Geocoding battle locations
  * ggmap Google Maps API Queries



