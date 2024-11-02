function Set-WoWApiAccessToken
{
  <#
      .SYNOPSIS
      Retrieves and sets the World of Warcraft API access token.

      .DESCRIPTION
      The `Set-WoWApiAccessToken` function retrieves an OAuth 2.0 access token from Blizzard's Battle.net API using the provided client credentials (`ClientId` and `ClientSecret`). 
      This token is required for authenticating API requests to Blizzard's World of Warcraft API. The function stores the access token header in the global variable `WoWApiAuthHeader`.

      .PARAMETER ClientId
      The client ID issued by Blizzard when registering an application for API access. This is required to authenticate and retrieve the access token.

      .PARAMETER ClientSecret
      The client secret issued by Blizzard when registering an application for API access. This is required to authenticate and retrieve the access token.

      .EXAMPLE
      Set-WoWApiAccessToken -ClientId 'Strandmaus-client-id' -ClientSecret 'Strandmaus-client-secret'

      Retrieves the access token using the specified client ID and client secret, and stores it in the global variable `$Global:WoWApiAuthHeader`.

      .NOTES
      - Ensure that you have valid client credentials from Blizzard's API.
      - The access token header is stored globally, allowing it to be used in subsequent API requests.

      .OUTPUTS
      The function does not output anything on success, but returns an error message if the request fails.

      .ERRORS
      If the request fails, the function will return a string indicating the HTTP status code and message.
  #>

  param
  (
    [Parameter(Mandatory, Position = 0, HelpMessage = 'The client ID issued by Blizzard for API access.')]
    [ValidateNotNullOrEmpty()]
    [String]
    $ClientId,
    
    [Parameter(Mandatory, Position = 1, HelpMessage = 'The client secret issued by Blizzard for API access.')]
    [ValidateNotNullOrEmpty()]
    [String]
    $ClientSecret
  )
  
  $credPlain = '{0}:{1}' -f $ClientId, $ClientSecret
  $utf8Encoding = [Text.UTF8Encoding]::new()
  $credBytes = $utf8Encoding.GetBytes($credPlain)
  $base64auth = [Convert]::ToBase64String($credBytes)

  $RequestData = @{
    Method          = 'POST'
    Uri             = 'https://oauth.battle.net/token'
    ContentType     = 'application/x-www-form-urlencoded'
    Body            = 'grant_type=client_credentials'
    Headers         = @{
      Authorization = ('Basic {0}' -f $base64auth)
    }
    UseBasicParsing = $true
  }
  
  try 
  {
    $result = Invoke-RestMethod @RequestData
    if($result) 
    {
      $Global:WoWApiAuthHeader = @{
        Authorization = 'Bearer ' + $result.access_token
      }
      $Global:WoWAccessToken = $result.access_token
    }
  }
  catch 
  {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $status = $_.Exception.Response.StatusCode
    return ('Bad status code ({0}) {1}' -f $statusCode, $status)
  }
}