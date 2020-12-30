<#
  .SYNOPSIS
  Powershell script to get json drink recips from the API and write them to the SQL
  .NOTES
  File Name      : get_recipes.ps1
  Author         : Michael Wettstein
  .DESCRIPTION
  None
  .PARAMETER
  None
  .EXAMPLE
  None
  .NOTES
  None
  .LINK
  None
#> 

#region Database configuration
$servername = "DESKTOP-HHEUIUI\SQLEXPRESS"
$dataSource = $servername
$database = "cocktail_db"
#endregion

#region write api data to sql table
Function Add-APIData ($server, $database, $text) {
    $scon = New-Object System.Data.SqlClient.SqlConnection
    $scon.ConnectionString = "SERVER=$server;DATABASE=$database;Integrated Security=true"

    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $scon
    $cmd.CommandText = $text
    $cmd.CommandTimeout = 0

    $scon.Open()
    $cmd.ExecuteNonQuery()
    $scon.Close()
    $cmd.Dispose()
    $scon.Dispose()
}

# To get all recipes, the powershell script generates an url search request for every letter of the alpabet. 

$array = @('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')
$add = @()
foreach ($item in $array) {
    $url = 'https://www.thecocktaildb.com/api/json/v1/1/search.php?f=' + $item
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing

    $result = $response | ConvertFrom-Json  | select -expand drinks #| Select * #| ConvertTo-Json 

    ## Insert script to write the API data to the database
    foreach ($r in $result) {
        $add += "INSERT INTO stagging(idDrink,strDrink,strDrinkAlternate,strIngredient1,strMeasure1,strIngredient2,strMeasure2,strIngredient3,strMeasure3,strIngredient4,strMeasure4,
                                    strIngredient5,strMeasure5,strGlass,strInstructions) 
        VALUES ('" + $r.idDrink + "','" + $r.strDrink.replace("'", "") + "','" + $r.strDrinkAlternate + "','" + $r.strIngredient1 + "','" + $r.strMeasure1 + "','" + $r.strIngredient2 + "','" + $r.strMeasure2 + "',
        '" + $r.strIngredient3 + "','" + $r.strMeasure3 + "','" + $r.strIngredient4 + "','" + $r.strMeasure4 + "','" + $r.strIngredient5 + "','" + $r.strMeasure5 + "',
        '" + $r.strGlass + "','" + $r.strInstructions.replace("'", "") + "')" + $nl       
    }
}
Add-APIData -server $servername -database $database -text $add
#endregion