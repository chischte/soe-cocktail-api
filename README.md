********************************************************************************
COCKTAIL API
********************************************************************************
Michael Wettstein
27.01.2021 Zürich
********************************************************************************

HOW TO USE:

1) Create a database using the script "create_cocktail_db.sql"

2) Run the powersell sript "get_recipes.ps1" to fill the database with drink
   recipes from the api "https://www.thecocktaildb.com"
   
   Remarks:
 • Adjust the parameter $servername to fit your environment

3) Run the powershell script "create_html.ps1" to creat an html page
   displaying the drinks.

   Remarks:
 • The pagination of the html page does only work on
   Internet Explorer, therefore IE has to be selected as default browser.
   see also picture "set_ie_default.jpg".
 • In IE make sure active content is allowed to run files, see also
   picture "internet_explorer_settings.jpg"

********************************************************************************


