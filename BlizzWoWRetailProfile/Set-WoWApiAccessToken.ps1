function Set-WoWApiAccessToken
{
  param
  (
    [Parameter(Mandatory)]
    [String]
    $ClientId,
    
    [Parameter(Mandatory)]
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
    Headers         = @{Authorization = ('Basic {0}' -f $base64auth)}
    UseBasicParsing = $true
  }
  
  try 
  {
    $result = Invoke-RestMethod @RequestData
    if($result) 
    {
      $Global:WoWAccessToken = $result.access_token
    }
  }
  catch 
  {
    $statusCode = $_.Exception.Response.StatusCode.value__
    $status = $_.Exception.Response.StatusCode
    return "Bad status code ($statusCode) $status"
  }
}