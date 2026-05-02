-- Pull all columns from the Bronze source
with source as (
    select * from {{ source('bronze', 'raw_claims') }}
),

-- Clean, cast, and standardize every column
cleaned as (
    select
        -- Policy identifiers
        cast(policy_number as string) as policy_number,
        cast(months_as_customer as int) as months_as_customer,
        cast(age as int) as customer_age,

        -- Policy details
        upper(trim(policy_state)) as policy_state,
        trim(policy_csl) as policy_csl,
        cast(policy_deductable as int) as policy_deductible,
        cast(policy_annual_premium as double) as policy_annual_premium,
        cast(umbrella_limit as int) as umbrella_limit,

        -- Customer demographics
        trim(insured_sex) as insured_sex,
        trim(insured_education_level) as insured_education_level,
        trim(insured_occupation) as insured_occupation,
        trim(insured_relationship) as insured_relationship,
        cast(`capital-gains` as int) as capital_gains,
        cast(`capital-loss` as int) as capital_loss,

        -- Incident details
        cast(incident_date as date) as incident_date,
        trim(incident_type) as incident_type,
        trim(collision_type) as collision_type,
        trim(incident_severity) as incident_severity,
        trim(authorities_contacted) as authorities_contacted,
        upper(trim(incident_state)) as incident_state,
        trim(incident_city) as incident_city,
        cast(number_of_vehicles_involved as int) as number_of_vehicles_involved,
        trim(property_damage) as property_damage,
        cast(bodily_injuries as int) as bodily_injuries,
        cast(witnesses as int) as witnesses,
        trim(police_report_available) as police_report_available,

        -- Claim amounts
        cast(total_claim_amount as double) as total_claim_amount,
        cast(injury_claim as double) as injury_claim,
        cast(property_claim as double) as property_claim,
        cast(vehicle_claim as double) as vehicle_claim,

        -- Vehicle info
        trim(auto_make) as auto_make,
        trim(auto_model) as auto_model,
        cast(auto_year as int) as auto_year,

        -- Convert Y/N fraud flag to boolean
        case
            when upper(trim(fraud_reported)) = 'Y' then true
            else false
        end as is_fraud,

        -- Preserve Bronze metadata
        _ingested_at,
        _source_file
    from source
)

select * from cleaned