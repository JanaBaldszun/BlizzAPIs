function Get-CovenantIndex 
{
  <#
      .SYNOPSIS
      Retrieves the index of available covenants in World of Warcraft.
  
      .DESCRIPTION
      The function fetches the list of covenants available in World of Warcraft using the Blizzard API. This can provide information on all covenants including their names and IDs.
      The function requires the API to be accessible and valid credentials to be configured in the global variables.
  
      .PARAMETER realmSlug
      The slug of the realm. This is required and must not be empty.
  
      .PARAMETER characterName
      The name of the character. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-CovenantIndex -realmSlug 'azshara' -characterName 'Strandmaus'
      Retrieves the index of available covenants for the character named Strandmaus on the Azshara realm.
  
      .EXAMPLE
      Get-CovenantIndex -realmSlug 'azshara' -characterName 'Strandmaus' -Raw
      Retrieves the raw JSON response for the covenant index of the character named Strandmaus on the Azshara realm.
  
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
    $URL = '{0}data/wow/covenant/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
    
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'covenants') 
      {
        if($Raw) 
        {
          return $result
        }
        else 
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty covenants |
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
