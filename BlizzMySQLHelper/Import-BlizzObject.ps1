function Import-BlizzObject
{
  <#
      .SYNOPSIS
      Imports a Blizzard object into a specified MySQL table.
  
      .DESCRIPTION
      This function inserts or updates a record in a MySQL table using the given object properties. The object data is formatted for SQL insertion, with NULL values appropriately handled. If a record with a matching primary key already exists, the function updates the existing record.
  
      .PARAMETER Table
      The name of the MySQL table where the data should be inserted. This is required and must not be empty.
  
      .PARAMETER Object
      The PowerShell object containing the properties to be inserted into the table. This is required and must not be empty.
  
      .PARAMETER ConnectionName
      The name of the database connection to use for the query. This is required and must not be empty.
  
      .EXAMPLE
      Import-BlizzObject -Table 'characters' -Object $CharacterObject -ConnectionName 'MyDatabase'
      Imports a character object into the 'characters' table in the MySQL database 'MyDatabase'.
  
      .EXAMPLE
      $CharacterObject = [PSCustomObject]@{ Name = 'Strandmaus'; Realm = 'Azshara'; Level = 60 }
      Import-BlizzObject -Table 'characters' -Object $CharacterObject -ConnectionName 'MyDatabase'
      Inserts or updates the character named Strandmaus on the Azshara realm in the 'characters' table.
  
      .NOTES
      This function assumes that the Open-MySqlConnection cmdlet is used to establish the database connection.
      Example for setting the connection:
      Open-MySqlConnection -Credential $MySQLCreds -ConnectionName $ConnectionName -Server localhost -Database wow
    
      This function has a dependency on the SimplySql module.
  
  #>

  param
  (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The name of the MySQL table.')]
    [ValidateNotNullOrEmpty()]
    [string]$Table,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The PowerShell object to be inserted.')]
    [ValidateNotNullOrEmpty()]
    [psobject]$Object,

    [Parameter(Mandatory, Position = 2, HelpMessage = 'The database connection name.')]
    [ValidateNotNullOrEmpty()]
    [string]$ConnectionName
  ) 

  foreach($Property in $Object.PSObject.Properties)
  {
    if($null -eq $Property.Value)
    {
      $Property.Value = 'NULL'
    }
  }

  $columns = $Object.PSObject.Properties | Select-Object -ExpandProperty Name
  $values = $Object.PSObject.Properties | Select-Object -ExpandProperty Value

  $values = $values | ForEach-Object -Process { -join('"', $_, '"') }
  $hash = @{}
  $Object.psobject.properties | Where-Object -FilterScript { $_.value -ne 'NULL' } | ForEach-Object -Process { $hash[$_.Name] = -join('"', $_.Value, '"') }
  $Object.psobject.properties | Where-Object -FilterScript { $_.value -eq 'NULL' } | ForEach-Object -Process { $hash[$_.Name] = $_.Value }

  $Query = ('INSERT INTO {0} ({1}) VALUES ({2}) ON DUPLICATE KEY UPDATE {3}' -f ($Table), ($columns -join ','), ($values -join ','), ($hash.GetEnumerator().ForEach{('{0}={1}' -f $_.Name, $_.Value)} -join ','))
  $null = Invoke-SqlUpdate -ConnectionName $ConnectionName -Query $Query
}
