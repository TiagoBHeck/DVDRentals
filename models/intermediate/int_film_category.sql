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