function Set-UpdatesDate
{
  <#
      .SYNOPSIS
      Inserts or updates the update date of a specified file in the database.
  
      .DESCRIPTION
      This function adds an entry for a given file name to the 'updates' table in the database.
      If the entry already exists, it updates the date with the current timestamp.
  
      .PARAMETER ConnectionName
      The name of the SQL connection. This parameter is mandatory and must not be empty.
  
      .PARAMETER Filename
      The name of the file to update in the 'updates' table. This parameter is mandatory and must not be empty.
  
      .EXAMPLE
      Set-UpdatesDate -ConnectionName 'StrandmausDB' -Filename 'AzsharaLog.txt'
      Inserts or updates the entry for the file 'AzsharaLog.txt' in the database 'StrandmausDB'.
  
      .NOTES
      This function requires an established SQL connection with a given name.
      This function depends on the SimplySql module.
      The connection can be established with the following command:
      Open-MySqlConnection -Credential $MySQLCreds -ConnectionName $ConnectionName -Server localhost -Database wow
  
  #>

  param
  (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The name of the SQL connection.')]
    [ValidateNotNullOrEmpty()]
    [string]$ConnectionName,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The name of the file to update in the database.')]
    [ValidateNotNullOrEmpty()]
    [string]$Filename
  )

  $Date = Get-Date -Format 'yyyy.MM.dd HH:mm:ss'
  $Query = "INSERT INTO updates (datei, datum) VALUES ('$Filename', '$Date') ON DUPLICATE KEY UPDATE datum = '$Date';"
  $null = Invoke-SqlUpdate -ConnectionName $ConnectionName -Query $Query
}  
