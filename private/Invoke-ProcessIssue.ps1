function Invoke-ProcessIssue
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        $Request
    )

    Write-Host -Object ('Processing issue #{0} in the repository ''{1}''' -f $Request.Body.issue.number, $Request.Body.repository.name)

    switch ($Request.Body.action)
    {
        'opened'
        {
            # TODO: This should be removed.
            Write-UnknownPayload -Request $Request
        }

        default
        {
            Write-UnknownPayload -Request $Request
        }
    }
}
