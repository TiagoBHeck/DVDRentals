{{ config(
  schema='staging',
  materialized='table',
  tags=['stg_rental']
) }}


WITH _source AS(
  SELECT * FROM {{ source('postgres', 'rental') }}
),

stg_source as (

    select
        -- ids
        rental_id as rentalId,
        customer_id as customerId,
        inventory_id as inventoryId,
        staff_id as staffId,                    

        -- dates
        rental_date as rentalDate,
        return_date as returnDate,
        last_update as lastUpdate,

        -- timestamps
        current_timestamp as created_at

    from _source

)

select * from stg_source