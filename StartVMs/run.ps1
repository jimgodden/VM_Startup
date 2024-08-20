# Format for the URL:
# HTTPS://{FunctionAppName}.azurewebsites.net/api/{HTTPTriggerName}/?ResourceGroupName={ResourceGroupName}&Action={Action}

using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

$ResourceGroupName = "Training-BGP_Lab_RG_12"

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$body = "This HTTP triggered function has been executed.`n`n"

# # Validate query parameters.

# if (Get-AzResourceGroup -Name $Request.Query.ResourceGroupName) {
#     $ResourceGroupName = $Request.Query.ResourceGroupName
# }
# else {
#     $body = $body +
# '''

# Exception: A valid Resource Group name was not provided.  
# Pass a Resource Group name in the URL after the "?ResourceGroupName=" to start or stop the Virtual Machines.

# '''
# }

# if (($Request.Query.Action -eq "Start") -or ($Request.Query.Action -eq "Stop")) {
#     $Action = $Request.Query.Action
# }
# else {
#     $body = $body +
# '''

# Exception: A valid Action was not provided.  
# Pass either Start or Stop in the URL after the "&Action=" to start or stop the Virtual Machines.

# '''
# }

# $AzVMs = Get-AzvM -ResourceGroupName $ResourceGroupName

# switch ($Action) {
#     "Start" { 
#         foreach ($AzVM in $AzVMs) {
#             Start-AzVM -ResourceGroupName $ResourceGroupName -Name $AzVM.Name -NoWait
#             $body = $body + "Starting Azure Virtual Machine `"$($AzVM.Name)`"`n"
#         }
#     }
#     "Stop" {
#         foreach ($AzVM in $AzVMs) {
#             Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $AzVM.Name -NoWait -Force
#             $body = $body + "Stopping Azure Virtual Machine `"$($AzVM.Name)`"`n"
#         }
#     }
# }

$AzVMs = Get-AzvM -ResourceGroupName $ResourceGroupName

$body = $body + "`nStarting the following Virtual Machines in Resource Group ${ResourceGroupName}:`n`n"

foreach ($AzVM in $AzVMs) {
    Start-AzVM -ResourceGroupName $ResourceGroupName -Name $AzVM.Name -NoWait
    $body = $body + "$($AzVM.Name)`n"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
