SUBSCRIPTION_ID=f9766876-e50b-436f-9ad3-5afb7bb8cf45
SERVICE_PRINCIPAL_NAME=azurekeyvaultapp8
SERVICE_PRINCIPAL_PASSWORD=jongpassword
RESOURCE_GROUP=jongdemo8
RESOURCE_GROUP_LOCATION=westus
RESOURCE=https://vault.azure.net
KEYVAULT_NAME=jongkeyvaultdemo8
KEYVAULT_SECRET_NAME=jongsecretname
KEYVAULT_SECRET_VALUE=jongsecretvalue


# Login to Azure CLI
az login

# Set Active Subscription
az account set -s $SUBSCRIPTION_ID

# Set Tenant Id
TENANT_ID=$(az account show --query tenantId -otsv)

# Create Service Principal			   
az ad sp create-for-rbac -n $SERVICE_PRINCIPAL_NAME -p $SERVICE_PRINCIPAL_PASSWORD

# Get Service Principal AppId
SERVICE_PRINCIPAL_APP_ID=$(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query [0].appId -otsv)

# Create Resource Group
az group create --name $RESOURCE_GROUP --location $RESOURCE_GROUP_LOCATION

# Create KeyVault
az keyvault create -n $KEYVAULT_NAME -g $RESOURCE_GROUP

# Get KeyVaule URI
KEYVAULT_URI=$(az keyvault show -n $KEYVAULT_NAME --query properties.vaultUri -otsv)

# Create Secret
az keyvault secret set --name $KEYVAULT_SECRET_NAME --vault-name $KEYVAULT_NAME --value $KEYVAULT_SECRET_VALUE             

# Give Service Principal Access to KeyVault
az keyvault set-policy --name $KEYVAULT_NAME --secret-permissions get --spn http://$SERVICE_PRINCIPAL_NAME

printf "\n\nclientId:$SERVICE_PRINCIPAL_APP_ID\nclientSecret:$SERVICE_PRINCIPAL_PASSWORD\ntenantId:$TENANT_ID\nsubscriptionId:$SUBSCRIPTION_ID\nvaultUri:$KEYVAULT_URI\nsecretName:$KEYVAULT_SECRET_NAME\napiVersion:2016-10-01\nresource:$RESOURCE\n\n"