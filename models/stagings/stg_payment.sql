{{ config(
  schema='staging',
  materialized='table',
  tags=['stg_payment']
) }}


WITH _source AS(
  SELECT * FROM {{ source('postgres', 'payment') }}
),


stg_source as (

    select
        -- ids        
        payment_id as PaymentId,
        customer_id as CustomerId,
        staff_id as StaffId,       
        rental_id as RentalId,

        -- float
        amount as Amount,

        -- date 
        payment_date as PaymentDate,
        
        -- timestamps
        current_timestamp as created_at

    from _source

)

select * from stg_source