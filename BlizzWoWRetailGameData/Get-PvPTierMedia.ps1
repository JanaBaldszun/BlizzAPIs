function Get-PvPTierMedia
{
  <#
      .SYNOPSIS
      Retrieves media assets for a specific PvP tier in World of Warcraft.

      .DESCRIPTION
      The function fetches media information for a given PvP tier by its ID using the World of Warcraft API. It supports returning either a formatted response or the raw JSON response.

      .PARAMETER ID
      The ID of the PvP tier. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-PvPTierMedia -ID '123'
      Retrieves the media information for the PvP tier with ID 123.

      .EXAMPLE
      Get-PvPTierMedia -ID '123' -Raw
      Retrieves the raw JSON response for the PvP tier with ID 123.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the PvP tier.')]
    [ValidateNotNullOrEmpty()]
    [String]$ID,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/media/pvp-tier/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $ID, $Global:WoWRegion, $Global:WoWLocalization
    
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'assets')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'
          
          return $result |
          Select-Object -ExpandProperty assets |
          Select-Object -ExpandProperty value
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
