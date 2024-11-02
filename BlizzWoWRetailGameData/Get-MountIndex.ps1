function Get-MountIndex
{
  <#
      .SYNOPSIS
      Retrieves the mount index from the World of Warcraft API.

      .DESCRIPTION
      This function fetches a list of all available mounts using the World of Warcraft API. The function can return a formatted list or raw JSON data based on the provided parameter.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API instead of a formatted result.

      .EXAMPLE
      Get-MountIndex
      Retrieves a formatted list of all available mounts, sorted by ID.

      .EXAMPLE
      Get-MountIndex -Raw
      Retrieves the raw JSON response containing the mount index.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Position = 0, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/mount/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'mounts')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'
          return $result |
          Select-Object -ExpandProperty mounts |
          Sort-Object -Property id
        }
      }
    }
    catch 
    {
      $statusCode = $_.Exception.Response.StatusCode.value__
      $status = $_.Exception.Response.StatusCode
      Write-Verbose -Message ('Bad status code ({0}) {1}' -f $statusCode, $status)     
    }  
  }
}
