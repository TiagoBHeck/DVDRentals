{{ config(
  schema='intermediate',
  materialized='table',
  tags=['int_rental_inventory_payment_customer']
) }}


WITH _rentals AS(
  SELECT * FROM {{ ref('stg_rentals') }}
),

_inventory AS(
  SELECT * FROM {{ ref('stg_inventory') }}  
),

_payments AS(
  SELECT * FROM {{ ref('stg_payment') }}
),

_customers AS(
  SELECT * FROM {{ ref('stg_customer')}}
),

int_rental_inventory_payment_customer AS (
  SELECT _rentals.RentalId,
         _rentals. rentalDate,
         _rentals.returnDate,
         _inventory.FilmId,
         _payments.Amount, 
         _payments.PaymentDate,
         _customers.FirstName,
         _customers.LastName
    FROM _rentals
    INNER JOIN _inventory ON (_rentals.inventoryId = _inventory.inventoryId)
    INNER JOIN _payments ON (_rentals.RentalId = _payments.RentalId)
    INNER JOIN _customers ON (_rentals.customerId = _customers.customerId)
)

SELECT * FROM int_rental_inventory_payment_customer