function Get-RecipeMedia
{
  param(
    [Parameter(Mandatory, Position = 0)][String]$ID,
    [Parameter(Position = 1)][Switch]$Raw
  )

  if(Test-WoWApiConnection)
  {
    $EndpointPath = ('data/wow/media/recipe/{0}' -f $ID)
    $Namespace = -join('?namespace=static-', $Global:WoWRegion, '&locale=', $Global:WoWLocalization, '&')
    $URL = -join($Global:WoWBaseURL, $EndpointPath, $Namespace, 'access_token=', $Global:WoWAccessToken)    
  
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -TimeoutSec 5
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
