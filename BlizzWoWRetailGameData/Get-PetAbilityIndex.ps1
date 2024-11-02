function Get-PetAbilityIndex
{
  <#
      .SYNOPSIS
      Retrieves the index of pet abilities in World of Warcraft.
  
      .DESCRIPTION
      The function fetches a list of all available pet abilities from the World of Warcraft API. It requires an active API connection and valid credentials set in the global variables.
      The output can be formatted or returned in raw JSON format depending on the user's choice.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-PetAbilityIndex
      Retrieves a formatted list of all pet abilities in World of Warcraft.
  
      .EXAMPLE
      Get-PetAbilityIndex -Raw
      Retrieves the raw JSON response of all pet abilities in World of Warcraft.
  
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
    $URL = '{0}data/wow/pet-ability/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
    
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'abilities')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty abilities |
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
