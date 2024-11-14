SELECT
    customer_id,
    product_id,
    contract_id,
    CAST(contract_price AS NUMERIC) as contract_price,
    CAST(min_order_quantity AS NUMERIC) as min_order_quantity,
    start_date,
    end_date,
    pricing_tier,
    -- Add validity check
    CASE 
        WHEN CURRENT_DATE() BETWEEN start_date AND end_date THEN 'Active'
        WHEN CURRENT_DATE() < start_date THEN 'Future'
        ELSE 'Expired'
    END as contract_status
FROM {{ ref('raw_contract_pricing') }}