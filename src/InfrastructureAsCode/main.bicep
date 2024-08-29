name: Azure Bicep

on:
  workflow_dispatch

env:
  targetEnv: dev

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pages: write
      id-token: write
    steps:
    # Checkout code
    - uses: actions/checkout@main

      # Log into Azure
    - uses: azure/login@v2.1.1
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        enable-AzPSSession: true

      # Deploy ARM template
    - name: Run ARM deploy
      uses: azure/arm-deploy@v1
      with:
        subscriptionId: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        resourceGroupName: ${{ secrets.AZURE_RG }}
        template: ./src/InfrastructureAsCode/main.bicep
        parameters: environment=${{ env.targetEnv }}
