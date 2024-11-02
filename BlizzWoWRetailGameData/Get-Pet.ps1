function Get-Pet
{
  <#
      .SYNOPSIS
      Retrieves information about a specific pet in World of Warcraft.
  
      .DESCRIPTION
      This function fetches detailed information about a pet using the World of Warcraft API. The pet ID must be provided as a parameter. An optional switch is available to return the raw JSON response.
  
      .PARAMETER Id
      The unique identifier of the pet. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-Pet -Id '39'
      Retrieves information about the pet with ID 39.
  
      .EXAMPLE
      Get-Pet -Id '39' -Raw
      Retrieves the raw JSON response for the pet with ID 39.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>
  
  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The unique identifier of the pet.')]
    [ValidateNotNullOrEmpty()]
    [String]$Id,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/pet/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Id, $Global:WoWRegion, $Global:WoWLocalization
    
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result) 
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          if($result.PSObject.Properties['_links'])
          {
            $result.PSObject.Properties.Remove('_links')
          }
          return $result
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
