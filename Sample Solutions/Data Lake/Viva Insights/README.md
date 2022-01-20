# Viva Insights Data Lake Solution
This walk-through is an end-to-end solution to extract, transform and load Viva Insights data into a database and then consume by PowerBI as an end-user platform. The key features of this workload:
-	Automated pipeline to avoid manual interaction with Viva Insights query builder platform
-	Instruction and guideline on handling Viva Insights historic data
-	Utilizing an open source scripting language (Spark) to enable reusability of the script in other platforms and tools
-	Leveraging Synapse to have a seamless, easy-to-manage workspace to implement the solution

## Potential Use cases
Several scenarios can benefit from this workload through layering an advanced ETL pipeline on top of Viva Insights platform:
-	There are two native out-of-the-box approaches to use the Viva Insights’ query results: 1- Downloading the query result file manually, 2- Using Odata links with a secondary tool like PowerBI to connect to Odata link. To avoid manual downloads and using unnecessary tools, a program(script) is required to load and ingest the data.
In fact, many advanced workplace analytics use cases may require the Viva Insights data to be productionized by automatically ingesting into an existing data warehouse, combined with other data sources to have a comprehensive view of the organization.
-	BI solutions using PowerBI or other tools may not scale properly using the Odata link provided for Viva Insights queries. This walk-through with the combination of SQL Database and PowerBI (or any other tool connecting though Odata) will help with the limitation.
-	There are limitations in the time period of the Viva Insights queries. Having an additional work stream to ingest and store the historical data over time would be necessary for some organizations and some scenarios.

## Architecture

<p align="center">
  <img src="./Architecture.png" width="800" class="center">
</p>
