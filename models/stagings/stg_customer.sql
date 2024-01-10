{{ config(
  schema='staging',
  materialized='table',
  tags=['stg_customer']
) }}


WITH _source AS(
  SELECT * FROM {{ source('postgres', 'customer') }}
),


stg_source as (

    select
        -- ids        
        customer_id as customerId,
        store_id as storeId,
        address_id as addressId,   

        -- strings
        first_name as FirstName,
        last_name as LastName,
        email as "E-mail",

        -- flags
        active as Active,

        -- boolean
        activebool as ActiveBool,                 

        -- dates
        create_date as createDate,        
        last_update as lastUpdate,

        -- timestamps
        current_timestamp as created_at

    from _source

)

select * from stg_source