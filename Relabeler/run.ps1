# Prereq for debug: npm install -g azure-functions-core-tools@3
# See https://github.com/Azure/azure-functions-core-tools#installing
#
# TO DEBUG LOCALLY PRESS F5: make sure not to have any Set-Location in $profile (or else it
# will override the current directory).
# See issue https://github.com/microsoft/vscode-azurefunctions/issues/1260#issuecomment-489612400.
#
# Once running. Test using http://localhost:7071/api/Relabeler?DebugFunction=johan
#
# To run against published function replace the token in the below snippet and paste it in
# to a browser. Token is found in Azure portal. Make sure to replace any chars in the token
# that are not allowed in an URL, like = or \ should be replaced with %3D or %2F respectively).
# https://<hostname>.azurewebsites.net/api/relabeler?code=<token>&DebugFunction=johan
#
# Deploy to 'labopscalyx2 in the existing function hostname.
#
# Azure Functions PowerShell developer guide: https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-powershell?tabs=portal
# Azure Functions HTTP trigger: https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?tabs=powershell#example
# TODO: Fix OAuth to send request to GitHub: https://docs.github.com/en/developers/apps/building-oauth-apps
# TODO: Use secret to encrypt (?) trigger from GitHub https://4bes.nl/2021/04/04/create-a-secure-github-webhook-to-trigger-an-azure-powershell-function/
# TODO: Use a Storage queue to send the trigger to the function: https://docs.microsoft.com/en-us/azure/azure-functions/functions-add-output-binding-storage-queue-vs-code?pivots=programming-language-powershell
# TODO: Connect to other services: https://docs.microsoft.com/en-us/azure/azure-functions/add-bindings-existing-function?tabs=powershell
# TODO: Read up on durable function: https://docs.microsoft.com/en-us/azure/azure-functions/durable/quickstart-powershell-vscode
# TODO: Fix auto deploy: https://docs.microsoft.com/en-us/azure/azure-functions/create-first-function-cli-powershell?tabs=azure-cli%2Cbrowser
<#
    .SYNOPSIS
        Triggers the function hostname.

    .DESCRIPTION
        This function is triggered by a GitHub webhook.

    .PARAMETER Request
        The request object of type [Microsoft.Azure.Functions.PowerShellWorker.HttpRequestContext].

    .PARAMETER TriggerMetadata
        The metadata object of type [System.Collections.Hashtable].

    .OUTPUTS
        [Microsoft.Azure.Functions.PowerShellWorker.HttpRequestContext]
#>
using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host -Object "PowerShell HTTP trigger function processed a request."

$body = $null

# Interact with query parameters or the body of the request (just used to test connectivity of the Azure Function).
$debugFunction = $Request.Query.DebugFunction

if ($debugFunction)
{
    $body = 'Debug: This HTTP triggered function executed successfully. Request in query: {0}' -f $debugFunction
}
else
{
    switch ($Request.Headers.'x-github-event')
    {
        'issues'
        {
            Invoke-ProcessIssue -Request $Request
        }

        default
        {
            Write-UnknownPayload -Request $Request
        }
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
