# DscResource.Serverless

## Debug

Prerequisites for debug: `npm install -g azure-functions-core-tools@3`
See https://github.com/Azure/azure-functions-core-tools#installing

TO DEBUG LOCALLY PRESS F5: make sure not to have any `Set-Location` in `$profile` (or else it
will override the current directory). See issue https://github.com/microsoft/vscode-azurefunctions/issues/1260#issuecomment-489612400.

Once running. Test using http://localhost:7071/api/Relabeler?DebugFunction=true

To run against published function replace the token in the below snippet and paste it in
to a browser. Token is found in Azure portal. Make sure to replace any chars in the token
that are not allowed in an URL, like = or \ should be replaced with %3D or %2F respectively).
https://<hostname>.azurewebsites.net/api/relabeler?code=<token>&DebugFunction=true

Deploy to RG 'labopscalyx2 in the existing function hostname.
