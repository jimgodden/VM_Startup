using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
    $body = "This HTTP triggered function executed successfully. Pass a Resource Group name in the query string to start the Virtual Machines."
}
elseif ($name) {
    $body = "All Virtual Machines in ResourceGroup $name will be started. This HTTP triggered function executed successfully."
}

# if ($name) {
#     $body = "Hello, $name. This HTTP triggered function executed successfully."
# }

if (Get-AzResourceGroup -Name $name) {
    Start-AzVM -ResourceGroupName $name -Name "*"
}
else {
    # Associate values to output bindings by calling 'Push-OutputBinding'.
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body = $body
    })
}
