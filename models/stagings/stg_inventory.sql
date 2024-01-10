{{ config(
  schema='staging',
  materialized='table',
  tags=['stg_inventory']
) }}


WITH _source AS(
  SELECT * FROM {{ source('postgres', 'inventory') }}
),


stg_source as (

    select
        -- ids        
        inventory_id as InventoryId,
        film_id as FilmId,
        store_id as StoreId,       
        
        -- timestamps
        current_timestamp as created_at

    from _source

)

select * from stg_source