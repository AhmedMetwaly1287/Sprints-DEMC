<h1>Sprints.ai - Data Engineering Masterclass</h1>

<p><strong>This repository will include all the tasks/projects required for uploading/assessment to the Data Engineering Masterclass provided by Sprints.ai</strong></p>


<h2>1. Database Fundamentals Task</h2>

A task involving the creation of a relational schema and execution of SQL queries. The task consists the following steps:

1. Sub Task 1: Relational Schema Design:
The initial step involves using ERDPlus.com to design a relational schema for the database included in W3Schools (https://w3schools.com/sql/trysql.asp?filename=trysql_editor). Alot of effort was put into analyzing the database schema and figuring out the relationships between each table and the PKs, FKs of each table.

2. Database Implementation:
Once the relational schema is designed, the next phase is to implement it in Microsoft SQL Server. This involves translating the schema into SQL statements to create tables, define primary and foreign key relationships, and establish constraints and indexes.

4. Sub-Task 2: Identify Top 10 Employees by Number of Orders:
Execute an SQL query to find and list the top 10 employees who sold the most number of orders. The query should retrieve employee names along with the count of orders they handled, ordered in descending order by the number of orders.

5. Sub-Task 3: Identify Top 10 Employees by Quantity Sold in Beverages Section:
Craft a second SQL query to identify the top 10 employees who sold the highest quantity in the beverages section. This involves joining relevant tables to extract information on employees, orders, order details, products, and categories. The results should be filtered to include only products from the beverages section and ordered based on the quantity sold.

This task was a good demonstration of knowledge of SQL, Utilizing a well-known RDBMS such as SQL Server to create a database and define the relationships between each table.

<h2>2. Web Scrapping Task</h2>

<h3>Objective:</h3>
The task involves developing a Python script to scrape book information from a website, process the data, and save it in a structured format (CSV file). The script specifically targets the retrieval of book names, prices, availability status, and individual links. Additionally, it performs data transformation and encoding before saving the data.

<h3>Libraries Used:</h3>

Requests: This library is used for making HTTP requests to the website. It fetches the HTML content of the web pages for further processing.<br>

BeautifulSoup (from bs4): BeautifulSoup is utilized for parsing HTML and navigating through the HTML tags. It is essential for extracting specific data like book names, prices, and availability from the HTML content.

Pandas: Pandas is a powerful data manipulation and analysis tool. In this task, it's used for creating dataframes from the scraped data, transforming the data, and finally saving the processed data into a CSV file.

<h3>Detailed Task Steps:</h3>

Scraping Basic Book Information:

Fetch the HTML content of the main page of the website "https://books.toscrape.com/".
Parse the HTML to extract book names, prices, and availability information.
Clean and format the extracted data as necessary (like removing yn-used symbols from prices).

Scraping Individual Book Links:

Extract the individual links for each book from the main page.
Construct the full URLs of the book pages for further scraping.
Scraping Detailed Information from Individual Book Pages:

For each book link, fetch and parse the book's individual page.
Extract additional details about each book, such as its unique ID, from the information table on each page.

Data Processing and Transformation:

Create a Pandas dataframe to organize the data into a structured format.
Perform One Hot Encoding on the 'Stock' column to transform categorical data into a format that can be easily used for analysis or machine learning models.

Saving the Data:

Save the final processed data into a CSV file named 'result.csv'.
Ensure the data is clean and well-structured for any further analysis or usage.
Output:
The script outputs a CSV file containing detailed and structured information about books, including their ID, name, price, stock status, and individual web links. The stock status is one-hot encoded to facilitate further data analysis tasks.

This task combines web scraping, data extraction, and data transformation techniques, showing the power and flexibility of Python in handling and processing web data.








