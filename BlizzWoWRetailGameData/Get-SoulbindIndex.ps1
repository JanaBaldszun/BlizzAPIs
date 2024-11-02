function Get-SoulbindIndex
{
  <#
      .SYNOPSIS
      Retrieves the soulbind index for a specified character in World of Warcraft.

      .DESCRIPTION
      The function fetches the soulbind index for a given character using the World of Warcraft API. The realm slug and character name are required parameters. An optional switch is available to return raw JSON data.

      .PARAMETER realmSlug
      The slug of the realm. This is required and must not be empty.

      .PARAMETER characterName
      The name of the character. This is required and must not be empty.

      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.

      .EXAMPLE
      Get-SoulbindIndex -realmSlug 'azshara' -characterName 'strandmaus'
      Retrieves the soulbind index for the character named Strandmaus on the Azshara realm.

      .EXAMPLE
      Get-SoulbindIndex -realmSlug 'azshara' -characterName 'strandmaus' -Raw
      Retrieves the raw JSON response of the soulbind index for the character named Strandmaus on the Azshara realm.

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
    $URL = '{0}data/wow/covenant/soulbind/index?namespace=static-{1}&locale={2}' -f $Global:WoWBaseURL, $Global:WoWRegion, $Global:WoWLocalization

    try 
    {
      $result = Invoke-RestMethod -Uri $URL -Headers $Global:WoWApiAuthHeader -TimeoutSec 5
      if($result -and $result.PSobject.Properties.name -contains 'soulbinds')
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          return $result |
          Select-Object -ExpandProperty soulbinds |
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