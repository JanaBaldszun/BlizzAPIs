function Test-WoWApiConnection
{
  if(
    $Global:WoWRegion -eq $null -or
    $Global:WoWLocalization -eq $null -or
    $Global:WoWBaseURL -eq $null -or
    $Global:WoWAccessToken -eq $null
  )
  {
    throw 'The connection variables for the WoWApi were not set. Please execute the commands "Set-WoWRegion" and "Set-WoWApiAccessToken".'
  }
  else
  {
    return $true
  }
}