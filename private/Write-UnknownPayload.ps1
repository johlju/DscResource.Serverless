function Write-UnknownPayload
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        $Request
    )

    Write-Host -Object ("Unknown payload request:`r`n{0}" -f ($Request | ConvertTo-Json -Depth 10))
}
