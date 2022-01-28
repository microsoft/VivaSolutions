# Microsoft Graph Data Connect Data Lake Solution
**Note**: A detailed end-to-end instruction will be added here. In the meantime, the following step by step will help you leverage the existing Microsoft Graph Data Connect documentation and tutorials to create the pipeline.

This walkthrough describes how you can load and copy data from your Office 365 organization (Microsoft Graph) into your Azure storage using Microsoft Graph data connect and then how to extract attributes and ultimately enriched attributes and knowledge. Microsoft Graph data connect traditionally provides Office 365 data to your Azure storage in JSON lines but this walk-though flattens the data and makes it available as entity tables, which are represented as CSVs. In addition to flat CSVs, the solution export data with the Common Data Model structure. Follow Microsoft docementatio [here](https://docs.microsoft.com/en-us/common-data-model/) to learn more about the Common Data Model.

In this walkthrough you will:

- Provision required resources in your Azure environment to store and process your Office 365 data
- Use an Azure Data Factory or Synapse to move your Office 365 data through Microsoft Graph data connect into Azure Data Lake Gen2 storage in your environment in JSON lines
- Use Azure Synapse Spark Pool or Databricks to run a PySpark script to convert the Office 365 data from JSON lines into flat CSV or CDM entities

## Pre-requistes
To utilize this walkthrough, you must have Microsoft Graph data connect enabled in your Office 365 organization and have an Azure subscription under the same Azure Active Directory tenant as your Office 365 subscription. Use the steps in [Exercise 1](https://github.com/microsoftgraph/msgraph-training-dataconnect/blob/master/Lab.md#exercise-1-setup-office-365-tenant-and-enable-microsoft-graph-data-connect) of our Microsoft Graph data connect training module to enable and configure Microsoft Graph data connect in your environment alongside an Azure subscription.

Follow instructions in [Build your first Microsoft Graph Data Connect application](https://docs.microsoft.com/en-us/graph/data-connect-quickstart?tabs=Microsoft365)
