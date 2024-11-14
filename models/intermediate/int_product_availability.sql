SELECT
    p.product_id,
    p.customer_id,
    p.contract_price,
    p.min_order_quantity,
    i.total_available_quantity,
    i.stock_statuses,
    CASE 
        WHEN i.total_available_quantity >= p.min_order_quantity THEN 'Available'
        WHEN i.total_available_quantity >= (p.min_order_quantity * 0.5) THEN 'Limited'
        ELSE 'Unavailable'
    END as availability_status,
    CASE 
        WHEN i.stock_statuses LIKE '%Low%' THEN p.contract_price * 1.05
        WHEN i.stock_statuses LIKE '%Reorder%' THEN p.contract_price * 1.10
        ELSE p.contract_price
    END as adjusted_price
FROM {{ ref('stg_contract_pricing') }} p
LEFT JOIN {{ ref('Supply_Chain_Warehouse', 'mart_inventory_availability') }} i
    ON p.product_id = i.product_id