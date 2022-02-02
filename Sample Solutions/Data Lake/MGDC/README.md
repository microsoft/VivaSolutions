# Microsoft Graph Data Connect Data Lake Solution
**Note**: A detailed end-to-end instruction will be added here. In the meantime, the following step by step will help you leverage the existing Microsoft Graph Data Connect documentation and tutorials to create the pipeline.

This walkthrough describes how you can load and copy data from your Office 365 organization (Microsoft Graph) into your Azure storage using Microsoft Graph data connect and then how to extract attributes and ultimately enriched attributes and knowledge. Microsoft Graph data connect traditionally provides Office 365 data to your Azure storage in JSON lines but this walk-though flattens the data and makes it available as entity tables, which are represented as CSVs. In addition to flat CSVs, the solution export data with the Common Data Model structure. Follow Microsoft docementatio [here](https://docs.microsoft.com/en-us/common-data-model/) to learn more about the Common Data Model.

In this walkthrough you will:

- Provision required resources in your Azure environment to store and process your Office 365 data
- Use an Azure Data Factory or Synapse to move your Office 365 data through Microsoft Graph data connect into Azure Data Lake Gen2 storage in your environment in JSON lines
- Use Azure Synapse Spark Pool or Databricks to run a PySpark script to convert the Office 365 data from JSON lines into flat CSV or CDM entities

## Pre-requistes
To utilize this walkthrough, you must have Microsoft Graph data connect enabled in your Office 365 organization and have an Azure subscription under the same Azure Active Directory tenant as your Office 365 subscription. Use the steps in [Exercise 1](https://github.com/microsoftgraph/msgraph-training-dataconnect/blob/master/Lab.md#exercise-1-setup-office-365-tenant-and-enable-microsoft-graph-data-connect) of our Microsoft Graph data connect training module to enable and configure Microsoft Graph data connect in your environment alongside an Azure subscription.

## Provision required resources
To complete the conversion, a few resources must be created/provisioned in your Azure environment, specifically:

- An app registration to enable Microsoft Graph data connect to extract your Office 365 data into your Azure storage. Follow the steps under "Create an Azure AD Application" in [Exercise 2](https://github.com/microsoftgraph/msgraph-training-dataconnect/blob/master/Lab.md#exercise-2-extract-office-365-data-with-microsoft-graph-data-connect) of our training module to provision the resource. Note down the application ID, tenant ID, and application key as they will be used later in the walkthrough. Ensure the app registration has Storage Blob Data Contributor access to the Azure Data Lake Storage Gen2 account to be created next.
- An Azure Data Lake Storage Gen2 (ADLSg2) account to store the JSON lines outputted from Microsoft Graph data connect. This Storage account can be any new or existing account or the default storage linked to Synapse (if using Synapse pipelines)
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

Follow instructions in [Build your first Microsoft Graph Data Connect application](https://docs.microsoft.com/en-us/graph/data-connect-quickstart?tabs=Microsoft365)
