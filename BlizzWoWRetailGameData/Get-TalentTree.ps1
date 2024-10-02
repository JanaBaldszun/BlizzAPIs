function Get-TalentTree
{
  param(
    [Parameter(Mandatory, Position = 0)][String]$TalentTreeID,
    [Parameter(Mandatory, Position = 1)][String]$SpecID,
    [Parameter(Position = 2)][Switch]$Raw
  )
  if(Test-WoWApiConnection)
  {
    $EndpointPath = ('data/wow/talent-tree/{0}/playable-specialization/{1}' -f $TalentTreeID, $SpecID)
    $Namespace = -join('?namespace=static-', $Global:WoWRegion, '&locale=', $Global:WoWLocalization, '&')
    $URL = -join($Global:WoWBaseURL, $EndpointPath, $Namespace, 'access_token=', $Global:WoWAccessToken)    
  
    try 
    {
      $result = Invoke-RestMethod -Uri $URL -TimeoutSec 5
      if($result) 
      {
        if($Raw)
        {
          return $result
        }
        else
        {
          Write-Verbose -Message 'This is a formatted result. To get the native result use the -Raw parameter.'

          $result.PSObject.Properties.Remove('_links')
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
