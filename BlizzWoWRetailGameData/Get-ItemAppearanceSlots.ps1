function Get-ItemAppearanceSlots
{
  <#
      .SYNOPSIS
      Retrieves item appearance slots available in World of Warcraft.

      .DESCRIPTION
      The function fetches a list of item appearance slots using the World of Warcraft API. An optional switch is available to return raw JSON data.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-ItemAppearanceSlots
      Retrieves a formatted list of item appearance slots.

      .EXAMPLE
      Get-ItemAppearanceSlots -Raw
      Retrieves the raw JSON response of item appearance slots.

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
    $URL = '{0}data/wow/item-appearance/slot/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization
  
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
          $SlotURLs = $result | Select-Object -ExpandProperty slots | Select-Object -ExpandProperty key | Select-Object -ExpandProperty href
          $pattern = '/([^/?]+)\?'
          foreach($SlotURL in $SlotURLs)
          {
            if($SlotURL -match $pattern) 
            {
              $matches[1]
            }
          }
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
