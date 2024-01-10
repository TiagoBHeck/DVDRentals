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
