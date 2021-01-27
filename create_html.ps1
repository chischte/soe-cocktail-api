<#
  .SYNOPSIS
  Powershell script to create an HTML to display the drink recipes from the database
  .NOTES
  File Name      : create_html.ps1
  Author         : Michael Wettstein
  .DESCRIPTION
  None
  .PARAMETER
  None
  .EXAMPLE
  None
  .NOTES
  EnhancedHTML2 module has to be installed
  The pagination does only work on internet explorer
  .LINK
  None
#> 

BEGIN {
    Import-Module EnhancedHTML2

#region CSS stylesheet
$style = @"
    body {
        color:#333333;
        font-family:Calibri,Tahoma;
        font-size: 12pt;
    }

    h1 {
        text-align:center;
    }

    h2 {
        border-top:1px solid #666666;
    }

    th {
        font-weight:bold;
        color:#eeeeee;
        background-color:#333333;
        cursor:pointer;
    }

    .odd  { background-color:#ffffff; }

    .even { background-color:#dddddd; }

    .pagination {
      display: inline-block;
    }

    .paginate_enabled_next, .paginate_enabled_previous {
        cursor:pointer; 
        border:1px solid #222222; 
        background-color:#dddddd; 
        padding:2px; 
        margin:4px;
        border-radius:2px;
        font-size: 18pt;
    }

    .paginate_disabled_previous, .paginate_disabled_next {
        color:#666666; 
        cursor:pointer;
        background-color:#dddddd; 
        padding:2px; 
        margin:4px;
        border-radius:2px;
    }

    .dataTables_info { margin-bottom:4px; }

    .sectionheader { cursor:pointer; }

    .sectionheader:hover { color:red; }

    .grid { width:100% }

    .red {
        color:red;
        font-weight:bold;
    }
"@

#endregion

# Setup data source
$servername="DESKTOP-HHEUIUI\SQLEXPRESS"
$dataSource  =  $servername
$database = "cocktail_db"

$path = ".\"
$OutputFile_new = $path + "drinks_report" + '.html' # File location

# Create a string variable with all connection details 
$connectionDetails = "Provider=sqloledb; " + "Data Source=$dataSource; " + "Initial Catalog=$database; " + "Integrated Security=SSPI;"

# Get data from sql view
$sql_server_info = "select strDrink as '01_DrinkName'
,strIngredient1 as '02_Ingredient1' , strMeasure1 as '03_Measure1'
,strIngredient2 as '04_Ingredient2' , strMeasure2 as '05_Measure2'
,strIngredient3 as '06_Ingredient3' , strMeasure3 as '07_Measure3'
,strIngredient4 as '08_Ingredient4' , strMeasure4 as '09_Measure4'
,strIngredient5 as '10_Ingredient5' , strMeasure5 as '11_Measure5'
,strGlass as '12_DrinkGlass'
,strInstructions as '13_Instructions'
from vwDrinks"

# Connect to the data source using the connection details 
$connection = New-Object System.Data.OleDb.OleDbConnection $connectionDetails
$command1 = New-Object System.Data.OleDb.OleDbCommand $sql_server_info,$connection
$connection.Open() # Open the connection

# Get the results into an object, close the connection
$dataAdapter = New-Object System.Data.OleDb.OleDbDataAdapter $command1
$dataSet1 = New-Object System.Data.DataSet
$dataAdapter.Fill($dataSet1)
$connection.Close()

# Return all of the rows and pipe it into the ConvertTo-HTML cmdlet, and then pipe that into the output file
$params = @{'As'='Table';
            'PreContent'='<h2>&diams; Drinks</h2>';
            'MakeTableDynamic'=$true;
            'TableCssClass'='grid'}

$frag=$dataSet1.Tables | Select-Object -Expand Rows 

$html_pr = $frag |  ConvertTo-EnhancedHTMLFragment @params 

# Merge the stylesheet with data and generate the html file
$params = @{'CssStyleSheet'=$style;
            'Title'="Drinks Database";
            'PreContent'="<h1>Drinks Database</h1>";          
            'HTMLFragments'=@($html_pr);
            }

ConvertTo-EnhancedHTML @params | Out-File $OutputFile_new

Invoke-Expression $OutputFile_new
}