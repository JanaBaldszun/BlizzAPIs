function Get-ItemAppearanceSlotIndex
{
  <#
      .SYNOPSIS
      Retrieves the appearance slot index for a specified item slot in World of Warcraft.

      .DESCRIPTION
      The function fetches the appearance slot index for a given item slot using the World of Warcraft API. The item slot name is a required parameter. An optional switch is available to return raw JSON data.

      .PARAMETER Slot
      The name of the item slot. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-ItemAppearanceSlotIndex -Slot 'head'
      Retrieves the appearance slot index for the 'head' item slot.

      .EXAMPLE
      Get-ItemAppearanceSlotIndex -Slot 'head' -Raw
      Retrieves the raw JSON response for the 'head' item slot.

      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
  
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/game-data-apis
  #>

  param(
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The item slot name.')]
    [ValidateNotNullOrEmpty()]
    [String]$Slot,

    [Parameter(Position = 1, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/item-appearance/slot/{1}?namespace=static-{2}&locale={3}' -f $Global:WoWBaseURL, $Slot, $Global:WoWRegion, $Global:WoWLocalization

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

          return $result | Select-Object -ExpandProperty appearances | Select-Object -ExpandProperty id
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
