{{ config(
  schema='staging',
  materialized='table',
  tags=['stg_category']
) }}


WITH _source AS(
  SELECT * FROM {{ source('postgres', 'category') }}
),


stg_source as (

    select
        -- ids        
        category_id as CategoryId,
      
        -- string
        name as Name,

        -- date 
        last_update as LastDate,
        
        -- timestamps
        current_timestamp as created_at

    from _source

)

select * from stg_source