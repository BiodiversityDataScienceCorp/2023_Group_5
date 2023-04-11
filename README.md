# *Gopherus morafkai* Species Status Assessment

![Photo of Sonoran Desert Tortoise ](https://www.arizonahighways.com/sites/default/files/2022-06/0722_Nature_tortoise.jpg) 

## Overview

-   Lily McMullen
-   Nick Oliver
-   Olivia Spagnuolo
-   Whitney Maxfield

Creating Species Occurrence Maps and Species Distribution Models for Species Status Assessment of *Gopherus morafkai*

*Data accessed 4/4/2023*

# Dependencies

The following R packages are required: 
- dismo 
- tidyverse 
- rJava 
- maps 
- spocc

# Structure

**How to put our code into your R studio:**

You can either use an R desktop program in which case we recommend you download our project. 
Or, if you are using the online platform posit.cloud, you can follow these steps: 
1. Go to our main GitHub page https://github.com/BiodiversityDataScienceCorp/2023_Group_5
2. Click the green code button. 
3. Copy the URL under HTTPS. 
4. In your posit.cloud workspace, click "New Project", which will bring you to a drop down menu. 
5. Click "New project from Git Repository"
6. Paste the link you copied and click "Ok". 
7. You will now have our project in your R workspace and can edit it freely. 


*note* increase Ram within R to at least 5 before running

**Within scripts:** 
1. run script titled "dataaquisitioncleaning.R" 
2. run script titled "occurrencemap.R" 
3. run script titled "currentsdm.R" 
4. run script titled "futuresdm.R"

All packages needed are loaded first in "dataaquisitioncleaning.R" meaning there is no need to re-run all packages within each script.

**moving script from github to R**

Forking Process: <https://docs.github.com/en/get-started/quickstart/fork-a-repo>
