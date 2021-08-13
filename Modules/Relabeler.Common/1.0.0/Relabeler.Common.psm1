$local:scriptName = @()

foreach ($scriptFile in @(Get-ChildItem -Path "$PSScriptRoot/public" -Recurse -Include '*.ps1' -ErrorAction 'Stop'))
{
    . $scriptFile

    $local:scriptName += $scriptFile.BaseName

    Write-Verbose -Message ('Dot-sourcing file ''{0}''' -f $scriptFile.BaseName)
}

Write-Verbose -Message ('Exporting members ''{0}''' -f ($local:scriptName -join ', '))

Export-ModuleMember -Function $local:scriptName
