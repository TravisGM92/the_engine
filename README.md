# README

## Set-up

1. First make sure your computer is running the correct Rails and Ruby versions (Rails: 5.2.4.3, Ruby: 2.5.3). If you aren't running the correct versions, visit [this page and follow the instructions](https://github.com/turingschool-examples/task_manager_rails/blob/master/rails_uninstall.md).

## Project Purpose

The main purpose of this project was to develop an application that exposed it's own API. We had to first import a series of CSV files, then process them into our database. The tables we created were; merchants, customers, items, invoice items, invoices, and transactions. We then had to establish relationships between all of the tables. Merchants have items and invoices, and through invoices, has invoice items which gives access to customers, etc.

### API Endpoints

1. One specific item ("/api/v1/items/179")
2. All items in the database ("/api/v1/items")
3. CRUD items (post, get, patch and destroy-- "/api/v1/items")
4. CRUD merchants (post, get, patch and destroy-- "/api/v1/merchants")
5. All merchants in the database ("/api/v1/merchants")
6. Get all items for one specific merchant ("/api/v1/merchants/(merchant id)/items")
7. Find what merchant an item belongs to ("/api/v1/items/(item id)/merchant")
8. Search the database with any of the attributes belonging to merchants or items  and get back either a list of objects that match the query or one object that matches the query ("/api/vi/merchants/find_all?name=ill") OR ("/api/v1/items/find?name=haru").
9. And lastly, search the database for specific calculations.
  - merchants with the most revenue
  - merchants who have sold the most items
  - total revenue of ALL merchants within a specific date range
