use customer_churn_dataset;
select * from customer_churn;

-- 1. Identify the total number of customer  and churn rate --

select count(distinct customer_id) as total_customer,
sum(case when churn_status = 'yes' then 1 else 0 end) as churned_customer,
(sum(case when churn_status = 'yes' then 1 else 0 end) / count(distinct customer_id)) * 100 as churn_rate
from customer_churn;

-- 2. Find the average age of churned customers --

select avg(age) as average_churned_age
from customer_churn
where churn_status = 'yes';

-- 3. Discover the most common contract types among churned customers --

select contract_type, count(*) contract_count
 from customer_churn
where churn_status = 'yes'
group by contract_type
order by contract_count;

-- 4. Identify customers with high total charges who have churned --

select customer_id, total_charges, churn_status 
from customer_churn
where  churn_status = 'yes'
	and total_charges >(select avg(total_charges)  from customer_churn) 
order by total_charges desc;

-- 5. Calculate the total charges distribution for churned and non-churned customers --

select churn_status,
	(select sum(total_charges) from customer_churn where churn_status = 'yes') as churned,
    (select sum(total_charges) from customer_churn where churn_status = 'no') as non_churned
from customer_churn
group by churn_status;

-- 6. Calculate the average monthly charges for different contract types among churned customers --

select contract_type, avg(monthly_charges) as average_monthly_charges
from customer_churn
where churn_status = 'yes' # and contract_type != 'Yearly'
group by contract_type; 

-- 7. Identify customers who have both online security and online backup services and have not churned --

select customer_id, online_backup, online_security, churn_status
from customer_churn
where online_security = 'yes' and online_backup = 'yes' and churn_status = 'no';

-- 8. Identify the average total charges for customers grouped by gender and marital status --

select gender, marital_status, avg(total_charges) as avg_total_charges
from customer_churn
group by gender, marital_status
order by gender;

-- 9. Analyze the distribution of monthly charges among churned customers --

select customer_id, monthly_charges, churn_status 
from customer_churn 
where churn_status = 'yes';

-- 10.	Calculate the average monthly charges for different age groups among churned customers --

select case 
	when age between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 45 then '36-45'
	when age between 46 and 55 then '46-55'
	when age between 56 and 65 then '56-65'
	else'65+' 
end as age_group,
avg(monthly_charges) as average_monthly_charges
from customer_churn
where churn_status = 'yes'
group by age_group;

-- 11. Find the customers who have churned and are not using online services, and their average total charges --

select customer_id, avg(total_charges) as avg_total
from customer_churn
where churn_status = 'yes' 
	and online_security = 'no'
    and online_backup ='no'
    and tech_support = 'no'
group by customer_id;

-- 12. Create a view to find the customers with the highest monthly charges in each contract type --

create view highest_monthly_charges as 
select contract_type, customer_id, 
max(monthly_charges) as highest_monthly_charges
from customer_churn
group by contract_type;

-- 13.	Stored Procedure to Calculate Churn Rate --

DELIMITER //

create procedure CalculateChurnRateCalculateChurnRateSimple1()
begin
	declare total_customers int;
    declare churned_customers int;
    declare churn_rate decimal(10,2);

    -- Get total number of customers
    select count(*) into total_customers from customer_churn;

    -- Get number of churned customers
    select count(*) into churned_customers from customer_churn where churn_status = 'yes';

    -- Calculate churn rate
    if total_customers > 0 then
        set churn_rate = (churned_customers / total_customers) * 100;
    else
        set churn_rate = 0;
    end if;

    -- Display churn rate
    select churn_rate as 'Churn Rate (%)';
end//

DELIMITER ;

-- 14.	Identify the customers who have churned and used the most online services --

select customer_id, churn_status, online_security, online_backup
from customer_churn
where churn_status = 'yes'
	and online_security = 'yes'
    and online_backup = 'yes'
    and streaming_movies = 'yes'
    and streaming_tv = 'yes';
