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