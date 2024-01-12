# DVD rentals Postgres database DBT Core project

### This DBT project was designed to address good practices for structuring projects in DBT. As a database, the Postgres example database was used - DVD rentals - one of the most used in Postgres for testing and learning with the Postgres database.

## Objective

#### The objective of this project is to structure data extraction into staging, intermediate and analytics layers, following good practices recommended in the DBT documentation. The final resulting table will be used as a data source in a Business Intelligence project in Power BI.

## About data source

#### The DVD rental database represents the business processes of a DVD rental store. It is one of the most used postgres databases for testing purposes.
#### Check the database through the link [DVD rentals database](https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/).

## Source

#### Some DVD rentals database tables are used in the DBT project source
&nbsp;
```yml
sources:
  - name: postgres
    database: DVDRental
    schema: bronze
    tables:
      - name: rental
        tags: ['rental']
      - name: customer
        tags: ['rental', 'customer']
      - name: payment
        tags: ['rental', 'payment', 'customer']
      - name: inventory
        tags: ['rental', 'store', 'inventory', 'film']
      - name: film
        tags: ['film', 'inventory', 'rental']
      - name: film_category
        tags: ['film_category', 'film']
      - name: category
        tags: ['film', 'category']
      - name: staff
        tags: ['staff', 'rental']
      - name: address
        tags: ['address', 'customer']
```

## Custom schemas

#### For this project, different schemas were defined for each layer in the models.
&nbsp;
```yml
models:
  DVDRentals:
    # Config indicated by + and applies to all files under models/
    staging:
      +materialized: table
      +schema: staging
    intermediate:
      +materialized: table
      +schema: intermediate
    analytics:
      +materialized: table
      +schema: analytics
```

### Stagings

#### According to the DBT documentation, This is the foundation of our project, where we bring all the individual components we're going to use to build our more complex and useful models into the project.

~~~~sql
{{ config(
  schema='staging',
  materialized='table',
  tags=['stg_film']
) }}


WITH _source AS(
  SELECT * FROM {{ source('postgres', 'film') }}
),

stg_source as (
    select
        -- ids        
        film_id as FilmId,
       
        -- strings
        title as Title,
        rating as Rating,   

        -- integers
        release_year as ReleaseYear,
        rental_duration as RentalDuration,
        rental_rate as RentalRate,
        length as Length,
        replacement_cost as ReplacementCost,        

        -- dates        
        last_update as lastUpdate,

        -- timestamps
        current_timestamp as created_at

    from _source
)

select * from stg_source
~~~~

### Intermediate model

#### This layer is dedicated to assembling more complex models with the emergence of business rules and other joins between staging tables.

~~~~sql
{{ config(
  schema='intermediate',
  materialized='table',
  tags=['int_film_category']
) }}


WITH _film AS(
  SELECT * FROM {{ ref('stg_film') }}
),

_film_category AS(
  SELECT * FROM {{ source('postgres', 'film_category') }}
),

_category AS(
  SELECT * FROM {{ ref('stg_category') }}
),


int_film_category AS(

  SELECT 
    _category.categoryId,
    _category.name as categoryName,
    _film.filmId as FilmId,
    _film.title as FilmTitle
    FROM _category
    INNER JOIN _film_category ON (_category.categoryId = _film_category.category_id)
    INNER JOIN _film ON (_film.filmId = _film_category.film_id)
)

SELECT * FROM int_film_category
~~~~

### Marts (Analytics this case)

#### According to the DBT documentation - This is the layer where everything comes together and we start to arrange all of our atoms (staging models) and molecules (intermediate models) into full-fledged cells that have identity and purpose.

~~~~sql
{{ config(
  schema='analytics',
  materialized='table',
  tags=['analytics', 'dashboard']
) }}


WITH _film_category AS(
  SELECT * FROM {{ ref('int_film_category') }}
),

_int_rental_inventory_payment_customer AS(
  SELECT * FROM {{ ref('int_rental_inventory_payment_customer') }}
),

rentals AS(
  SELECT _int_rental_inventory_payment_customer.rentalDate,
         CONCAT(_int_rental_inventory_payment_customer.FirstName, 
                ' ', 
                _int_rental_inventory_payment_customer.LastName) AS FullName,
         _int_rental_inventory_payment_customer.returnDate,       
         _int_rental_inventory_payment_customer.Amount, 
         _int_rental_inventory_payment_customer.PaymentDate,
         _film_category.FilmTitle,
         _film_category.categoryName      
    FROM _int_rental_inventory_payment_customer
    INNER JOIN _film_category ON (_int_rental_inventory_payment_customer.filmId = _film_category.filmId)
)

SELECT * FROM rentals
~~~~

#### The final table, Rentals, will be used in Analytics projects to evaluate the data collected and modeled according to the purpose of evaluating DVD rentals. 

#### To create customized schemas, a macro is commonly used to define the personalized name of the schema. This code is even present in the DBT documentation.
&nbsp;
~~~~sql
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}
    {%- if custom_schema_name is none -%}
        {{ default_schema }}
    {%- else -%}
        {{ custom_schema_name | trim }}
    {%- endif -%}
{%- endmacro %}
~~~~

## Documentation

#### The documentation for this DBT project visually provides how each layer is constructed and how they relate to each other. The final table provides the insight for project analytics.

&nbsp;
![alt text](images/project.png "DVD rental DBT project")

## Author
- Tiago Bratz Heck
##### Access my [LinkedIn](https://www.linkedin.com/in/tiago-bratz-heck-0b9b5696/) profile.