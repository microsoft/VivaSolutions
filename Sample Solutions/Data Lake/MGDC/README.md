# Microsoft Graph Data Connect Data Lake Solution
**Note**: A detailed end-to-end instruction will be added here. In the meantime, the following step by step will help you leverage the existing Microsoft Graph Data Connect documentation and tutorials to create the pipeline.

This walkthrough describes how you can load and copy data from your Office 365 organization (Microsoft Graph) into your Azure storage using Microsoft Graph data connect and then how to extract attributes and ultimately enriched attributes and knowledge. Microsoft Graph data connect traditionally provides Office 365 data to your Azure storage in JSON lines but this walk-though flattens the data and makes it available as entity tables, which are represented as CSVs. In addition to flat CSVs, the solution export data with the Common Data Model structure. Follow Microsoft docementation [here](https://docs.microsoft.com/en-us/common-data-model/) to learn more about the Common Data Model.

In this walkthrough you will:

- Provision required resources in your Azure environment to store and process your Office 365 data
- Use an Azure Data Factory or Synapse to move your Office 365 data through Microsoft Graph data connect into Azure Data Lake Gen2 storage in your environment in JSON lines
- Use Azure Synapse Spark Pool or Databricks to run a PySpark script to convert the Office 365 data from JSON lines into flat CSV or CDM entities

## Pre-requistes
To utilize this walkthrough, you must have Microsoft Graph data connect enabled in your Office 365 organization and have an Azure subscription under the same Azure Active Directory tenant as your Office 365 subscription. Use the steps in [Set up your Microsoft 365 tenant and enable Microsoft Graph Data Connect](![image](https://user-images.githubusercontent.com/47372559/152107096-c56d0375-945a-4b5c-8472-3c2a612795e0.png)) of our Microsoft Graph data connect training module to enable and configure Microsoft Graph data connect in your environment alongside an Azure subscription.

## Provision required resources
To complete the conversion, a few resources must be created/provisioned in your Azure environment, specifically:

- An app registration to enable Microsoft Graph data connect to extract your Office 365 data into your Azure storage. Follow the steps in [Set up your Azure Active Directory app registration](https://docs.microsoft.com/en-us/graph/data-connect-quickstart?tabs=Microsoft365&tutorial-step=2) of our training module to provision the resource. Note down the application ID, tenant ID, and application key as they will be used later in the walkthrough. Ensure the app registration has Storage Blob Data Contributor access to the Azure Data Lake Storage Gen2 account to be created next.
- An Azure Data Lake Storage Gen2 (ADLSg2) account to store the JSON lines outputted from Microsoft Graph data connect. This Storage account can be any new or existing account or the default storage linked to Synapse (if using Synapse pipelines). Follow steps in [Set up your Azure Storage resource](https://docs.microsoft.com/en-us/graph/data-connect-quickstart?tabs=Microsoft365&tutorial-step=3) to setup proper permissions for the storage account. 
  - A file system to store the Office 365 data outputted by Microsoft Graph data connect in JSON format (called json in this walk-though and the default value in the script)
  - A file system to store the outputted CDM entities after the conversion is complete (called cdm in this walk-though and the default value in the script)
  - A file system to store the outputted CSV entities after the conversion is complete (called csv in this walk-though and the default value in the script)
- A prefered orchestration tool (Synapse/Azure Data Factory) and a preferred processing engine (Databricks or Synapse Spark Pool)
- The PySpark script to convert the MGDC JSON lines into CDM and CSV format and to store the resulting files.
  - If using Databricks as your compute engine have the Databricks notebook in the **src** directory of this repository uploaded into the Databricks instance.
  - If using Synapse, import the Synapse notebook from the **src** directory of this repository into your Synapse workspace (**Develop** -> **Notebooks** -> **import**)
- Synapse have CDM library installed by default. If using Databricks, install the CDM library via Maven.
<p align="center">
  <img src="images/DatabricksLibrary1.JPG" width="800" class="center">
  <img src="images/DatabricksLibrary2.JPG" width="800" class="center">
</p>


## Load and convert Office 365 data 
Follow the steps here to create a pipeline to export the Office 365 data into an storage account and then transfom into CDV and CSV formats.
- Within the orchestration tool of your choice (Azure Data Factory or Synapse), create a new Pipeline.
- Within the orchestration tool, you'll need to create a few linked service entities using the Azure resources provisioned earlier. 
  - **Create the ADLSg2 linked service**
    - To create the linked service to access the ADLSg2 account in **ADF/Synapse -> Manage**, select the **Azure Data Lake Storage Gen2** and create a new linked service. In the resulting blade, ensure you have set the Authentication Method to Service Principal and the Account Selection method as from an Azure subscription. Select the Azure subscription and account created earlier, as well as use the application ID and key noted earlier that has access to the account then click create. 

![ADLSg2 linked service configuration](https://github.com/OfficeDev/MS-Graph-Data-Connect/blob/master/Common-Data-Model/images/ADLSg2LS.PNG)

### Create the Office 365 data linked service
To create the linked service to allow Microsoft Graph data connect to move data into your Azure storage account, select any of the drop downs under the Office 365 tables and create a new linked service. In the resulting blade, provide the application ID and key noted earlier and select create. This linked service will automatically be used for all of the other Office 365 tables as well. 

![Office 365 linked service configuration](https://github.com/OfficeDev/MS-Graph-Data-Connect/blob/master/Common-Data-Model/images/O365LS.PNG)

### Create the HDI cluster linked service
To create the linked service connected to your HDI cluster, select the drop down under HDInsightCluster and create a new linked service. In the resulting blade, ensure Account Selection is From Azure Subscription and select the subscription containing your HDI cluster and ADLSg2 account. Select the HDI cluster you created and select ADLS Gen 2 for Azure Storage linked service. Ensure the ADLSg2 linked service created previously is selected and for file system use the file system which contains the PySpark script (jsontocdm). Enter the admin credentials to access the HDI cluster and click create

![HDI cluster linked service configuration](https://github.com/OfficeDev/MS-Graph-Data-Connect/blob/master/Common-Data-Model/images/HDILS.PNG) 

After completing the HDI cluster linked service, click Use this template on the template page and an Azure Data Factory pipeline will be created from the template. 

![ADF pipeline from template](https://github.com/OfficeDev/MS-Graph-Data-Connect/blob/master/Common-Data-Model/images/ADFpipeline.PNG)

### Executing the Azure Data Factory pipeline
The template creates a pipeline with four copy activities, one for each data type extracted through Microsoft Graph data connect (email messages, calendar events, Azure Active Directory user and manager information) and a HDInsight Spark activitym to execute the conversion logic and copy the result into the ADLSg2 account. To execute the pipeline, first publish the pipeline and then click Add Trigger -> Trigger Now. There will be a variety of pipeline run parameters required, specifically:
* OfficeDataFileSystem - The file system in the ADLSg2 account to place the Office 365 data in JSON lines. (json for this walkthrough)
* DateStartTime - The start time for what Office 365 you would like to process. The format is 2019-10-22T00:00:00Z
* DateEndTime - The end time for what Office 365 data you would like to process. The format is 2019-10-28T00:00:00Z
* StorageAccountName - The name of the ADLSg2 account
* AppID - The application ID for the app registration provisioned earlier
* AppKey - The application key for the app registration provisioned earlier
* TenantId - The tenant id for the app registration provisioned earlier
* ScriptFileSystem - The file system in the ADLSg2 account containing the PySpark script (jsontocdm for this walkthrough)
* PyScriptName - The name of the PySpark script (jsontocdm.py for this walkthrough)
* CdmDataFileSystem - The file system in the ADLSg2 account which will contain the CDM entities (cdm for this walkthrough)
* CdmModelName - Sub-directory in the CdmDataFileSystem for the CDM enitities; default to O365-data
* MessageDatasetFolder - Sub-directory in the OfficeDataFileSystem for the messages in JSON; default to message
* EventDatasetFolder - Sub-directory in the OfficeDataFileSystem for events in JSON; default to event
* UserDatasetFolder - Sub-directory in the OfficeDataFileSystem for user data in JSON; default to user
* ManagerDatasetFolder - Sub-directory in the OfficeDataFileSystem for manager user data in JSON; default to manager

![Pipeline run parameters](https://github.com/OfficeDev/MS-Graph-Data-Connect/blob/master/Common-Data-Model/images/PipelineRunParameters.PNG)

Once the parameters are fully populated, click run. You can then monitor the pipeline run in the Azure Data Factory monitor tab. You will need a global administrator (or delegate that was appointed during the pre-reqs of this walkthrough) to approve the Microsoft Graph data connect data access request through Privileged Access Management once the copy activity status is "ConsentPending". The resulting CDM entities will be available as CSVs under the cdm filesystem in the ADLSg2 account.


Follow instructions in [Build your first Microsoft Graph Data Connect application](https://docs.microsoft.com/en-us/graph/data-connect-quickstart?tabs=Microsoft365)
