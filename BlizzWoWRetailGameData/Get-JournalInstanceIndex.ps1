function Get-JournalInstanceIndex 
{
  <#
      .SYNOPSIS
      Retrieves the journal instance index from World of Warcraft.

      .DESCRIPTION
      This function fetches the journal instance index from the World of Warcraft API. It provides the option to return a raw JSON response or a formatted list of instances.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-JournalInstanceIndex
      Retrieves a formatted list of journal instances from World of Warcraft.

      .EXAMPLE
      Get-JournalInstanceIndex -Raw
      Retrieves the raw JSON response of journal instances from World of Warcraft.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param (
    [Parameter(Position = 0, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection) 
  {
    $URL = '{0}data/wow/journal-instance/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
    
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'instances') 
      {
        if($Raw) 
        {
          return $result
        }
        else 
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'
          return $result |
          Select-Object -ExpandProperty instances |
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
