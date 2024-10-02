function Set-UpdatesDate
{
  param
  (
    [Parameter(Mandatory, Position=0)][string]$ConnectionName,
    [Parameter(Mandatory, Position=1)][string]$Filename
  )
  $Date = Get-Date -Format 'yyyy.MM.dd HH:mm:ss'
  $Query = "INSERT INTO updates (datei, datum) VALUES ('$Filename', '$Date')ON DUPLICATE KEY UPDATE datum = '$Date';"
  $null = Invoke-SqlUpdate -ConnectionName $ConnectionName -Query $Query
}