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
# Deploy to 'labopscalyx2 in the existing function Relabeler.
#
# TODO: Fix OAuth to send request to GitHub: https://docs.github.com/en/developers/apps/building-oauth-apps
# TODO: Use secret to encrypt (?) trigger from GitHub https://4bes.nl/2021/04/04/create-a-secure-github-webhook-to-trigger-an-azure-powershell-function/

using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host -Object "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request (just used to test connectivity of the Azure Function).
$debugFunction = $Request.Query.DebugFunction

if ($debugFunction)
{
    $body = 'Debug: This HTTP triggered function executed successfully. Request in query: {0}' -f $debugFunction
}
else
{
    Write-Host -Object ("Request:`r`n{0}" -f ($Request | ConvertTo-Json))

    Write-Host -Object ('Action Type: {0}' -f $Request.Body.action)
    Write-Host -Object ('Repository Name: {0}' -f $Request.Body.repository.name)
    Write-Host -Object ("Private Repository: {0}" -f $Request.Body.repository.private)
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
