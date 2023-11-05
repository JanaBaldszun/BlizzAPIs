function Set-WoWRegion
{
  param
  (
    [Parameter(Mandatory)]
    [ValidateSet('China','Europe','Korea','North America','Taiwan')][String]
    $Region
  )

  dynamicparam
  {
    $data = @{
      'China'         = 'Chinese (Simplified)'
      'Europe'        = 'English (Great Britain)', 'French', 'German', 'Italian', 'Russian', 'Spanish (Spain)'
      'Korea'         = 'Korean'
      'North America' = 'English (United States)', 'Portuguese', 'Spanish (Mexico)'
      'Taiwan'        = 'Chinese (Traditional)'
    }
    $paramDictionary = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameterDictionary
    $attributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
    $attribute = New-Object -TypeName System.Management.Automation.ParameterAttribute
    $attribute.Mandatory = $true
    $attributeCollection.Add($attribute)
    $attribute = New-Object -TypeName System.Management.Automation.ValidateSetAttribute -ArgumentList ($data.$Region)
    $attributeCollection.Add($attribute)
    $attributeName = 'Language'
    $dynParam = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter -ArgumentList ($attributeName,[string],$attributeCollection)
    $paramDictionary.Add($attributeName, $dynParam)
    $paramDictionary
  }

  end
  {
    $regionLanguage = @{
      'Chinese (Simplified)'     = 'zh_CN'
      'Chinese (Traditional)'    = 'zh_TW'
      'English (Great Britain)	' = 'en_GB'
      'English (United States)	' = 'en_US'
      'French'                   = 'fr_FR'
      'German'                   = 'de_DE'
      'Italian	'                 = 'it_IT'
      'Korean'                   = 'ko_KR'
      'Portuguese'               = 'pt_BR'
      'Russian	'                 = 'ru_RU'
      'Spanish (Mexico)'         = 'es_MX'
      'Spanish (Spain)'          = 'es_ES'
    }

    $regionHost = @{
        'China'         = 'https://gateway.battlenet.com.cn/'
        'Europe'        = 'https://eu.api.blizzard.com/'
        'Korea'         = 'https://kr.api.blizzard.com/'
        'North America' = 'https://us.api.blizzard.com/'
        'Taiwan'        = 'https://tw.api.blizzard.com/'
    }
    
    $regionTwoLetter = @{
        'China'         = 'CN'
        'Europe'        = 'EU'
        'Korea'         = 'KR'
        'North America' = 'US'
        'Taiwan'        = 'TW'
    }

    $Global:WoWBaseURL = $regionHost.$Region
    $Global:WoWRegion = $regionTwoLetter.$Region
    $Global:WoWLocalization = $regionLanguage.$($PSBoundParameters.Language)
    
    if($PSBoundParameters.Verbose)
    {
      Write-Verbose "The global variable WoWBaseURL has been set to '$($Global:WoWBaseURL)'."
      Write-Verbose "The global variable WoWRegion has been set to '$($Global:WoWRegion)'."
      Write-Verbose "The global variable WoWLocalization has been set to '$($Global:WoWLocalization)'."
    }
  }
}