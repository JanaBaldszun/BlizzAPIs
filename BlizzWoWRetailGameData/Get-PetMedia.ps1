function Get-PetMedia
{
  <#
      .SYNOPSIS
      Retrieves media information for a specified pet in World of Warcraft.

      .DESCRIPTION
      This function fetches the media assets for a given pet ID from the World of Warcraft API. The pet ID is required and must not be empty. An optional switch is available to return raw JSON data.

      .PARAMETER ID
      The ID of the pet. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-PetMedia -ID '123'
      Retrieves the media assets for the pet with ID 123.

      .EXAMPLE
      Get-PetMedia -ID '456' -Raw
      Retrieves the raw JSON response for the pet with ID 456.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The ID of the pet.')]
    [ValidateNotNullOrEmpty()]
    [String]$ID,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/media/pet/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $ID, $Global:WoWRegion, $Global:WoWLocalization
    
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
