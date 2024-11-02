function Test-WoWApiConnection
{
  <#
      .SYNOPSIS
      Tests if the World of Warcraft API connection variables are set and validates the access token using the correct OAuth endpoint.

      .DESCRIPTION
      This function checks if the necessary global variables for the World of Warcraft API connection are initialized.
      Additionally, it sends a POST request to the Battle.net OAuth API (`https://oauth.battle.net/check_token`) to validate the access token.

      The global variables required are:
      - $Global:WoWRegion: The region for the WoW API (e.g., 'us', 'eu').
      - $Global:WoWLocalization: The language for localization (e.g., 'en_US').
      - $Global:WoWBaseURL: The base URL for the WoW API.
      - $Global:WoWAccessToken: The access token for authenticating API requests.

      .EXAMPLE
      Test-WoWApiConnection
      # This will check if the WoW API connection variables are set and try to validate the access token.

      .OUTPUTS
      [Boolean] Returns $true if all necessary variables are set and the access token is valid.
      Throws an error if any required variable is missing or the token validation fails.
    
      .NOTES
      This function requires the World of Warcraft API to be accessible and valid credentials to be configured in the global variables.
    
      .LINK
      https://develop.battle.net/documentation/world-of-warcraft
  #>

  if(
    $null -eq $Global:WoWRegion -or
    $null -eq $Global:WoWLocalization -or
    $null -eq $Global:WoWBaseURL -or
    $null -eq $Global:WoWApiAuthHeader
  )
  {
    throw 'The connection variables for the WoW API were not set. Please execute the commands `Set-WoWRegion` and `Set-WoWApiAccessToken`.'
  }

  try
  {
    $tokenValidationUrl = 'https://oauth.battle.net/check_token'
    $params = @{
      token = $Global:WoWAccessToken
    }
    $response = Invoke-RestMethod -Uri $tokenValidationUrl -Method Post -ContentType 'application/x-www-form-urlencoded' -Body $params

    if($null -ne $response -and $null -ne $response.client_id)
    {
      return $true
    }
    else
    {
      throw 'API connection failed. Token validation returned no client_id or invalid response.'
    }
  }
  catch
  {
    throw 'API connection test failed: {0}' -f $_
  }
}
