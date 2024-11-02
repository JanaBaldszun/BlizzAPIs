function Get-GuildActivity
{
  <#
      .SYNOPSIS
      Retrieves the activity log of a specified guild in World of Warcraft.
  
      .DESCRIPTION
      The function fetches a list of activities for a given guild using the World of Warcraft API. The realm slug and guild name are required parameters. An optional switch is available to return raw JSON data.
  
      .PARAMETER realmSlug
      The slug of the realm. This is required and must not be empty.
  
      .PARAMETER nameSlug
      The name of the guild. This is required and must not be empty.
  
      .PARAMETER Raw
      Optional switch to return the raw JSON response from the API.
  
      .EXAMPLE
      Get-GuildActivity -realmSlug 'azshara' -nameSlug 'strandmaus'
      Retrieves the activity log for the guild named Strandmaus on the Azshara realm.
  
      .EXAMPLE
      Get-GuildActivity -realmSlug 'azshara' -nameSlug 'strandmaus' -Raw
      Retrieves the raw JSON response of the activity log for the guild named Strandmaus on the Azshara realm.
  
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.

      .LINK
      https://develop.battle.net/documentation/world-of-warcraft/profile-apis
  #>
  
  param (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The slug of the realm.')]
    [ValidateNotNullOrEmpty()]
    [String]$realmSlug,

    [Parameter(Mandatory, Position = 1, HelpMessage = 'The guild name.')]
    [ValidateNotNullOrEmpty()]
    [String]$nameSlug,

    [Parameter(Position = 2, HelpMessage = 'Return raw JSON data.')]
    [Switch]$Raw
  )

  $realmSlug = $realmSlug.ToLower()
  $nameSlug = $nameSlug.ToLower()
  if(Test-WoWApiConnection)
  {
    $URL = '{0}data/wow/guild/{1}/{2}/activity?namespace=profile-{3}&locale={4}' -f $Global:WoWBaseURL, $realmSlug, $nameSlug, $Global:WoWRegion, $Global:WoWLocalization
    
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
          if($result.PSObject.Properties['guild'])
          {
            $result.PSObject.Properties.Remove('guild')
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
