You can use this solution to extract data from Graph API using a PowerShell script as a CSV output and then leverage this data along with customer provided meeting rooms metadata to generate reports through Power BI to end-users.

The key features of this solution are 

1.Script that generates Meeting room events in a structured format.
2.Instructions and guidelines on loading meetings data and other user provided data 
3.Power BI template with define metrics 
4.Power BI Insights that can be leveraged to take strategic decisions to License Teams Meeting rooms.

Use Cases:

The scenarios where users can benefit leveraging this solution are 

	• Currently Organizations don’t have a programmed approach to identify the usage stats on a given conference/meeting room.

	• Leaders have to heavily depend on facilities or service teams to get additional information and with only limited set of attributes which can also take long cycles to get the data from multiple sources.

	• For organization who are looking to adopt Inclusive meetings and build smart collaboration spaces ,this solution will provide data pointers to prioritize on rooms adoption.

Prerequisites:

• Azure admin – You need Azure admin privileges to create and register the app in Azure. You also need to ask the Azure global admin to grant you permissions to connect your new app to the Azure data store.
• IT admin needs  to run PowerShell script with the ClientID and  ​Client Secret of the registered APP
• Latest version of PBI is required to populate the dashboards.

Implementation Steps:

Step 1 :

App Registration in Azure AD :

Login into Azure AD  and Register an app and provide the app name 


Select Microsoft graph and grant Application permissions  for the following API's .
Calendars.Read
Calendars.readwrite
Directory.read.all
Place.read.all


           

Admin permissions are required to Grant admin consent.



 In Azure Active Directory > your newly registered analytics app, select Certificates & secrets, and then do one of the following.

For Key authentication, select New client secret, and then in Add a client secret, enter a description, select when it expires, and then select Add. In Client secrets, select the new secret, and then select the Copy icon to copy it.




Step 2 : 

Get the following details from the registered app in step1 

ClientID 
TenantID
ClientSecret


Feed the above values to the script available here 


Step 3 : saving data 

Step 4 : leveraging the data in PBI 
![image](https://user-images.githubusercontent.com/66338670/168206431-bfa5265e-3043-4465-9706-2c6dc5edfcf1.png)
