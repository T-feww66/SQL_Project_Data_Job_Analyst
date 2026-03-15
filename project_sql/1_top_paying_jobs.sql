/*
 Question: What are the top-paying data analyst jobs? 
 - Identify the top 10 highest-paying Data Analyst roles that are available remotely.
 - Focuses on job postings with specified salaries (remove nulls).
 - Why? Highlight the top-paying opportunities for Data Analysts, offtering insight into 
 */
-- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
select job_id,
    job_title_short,
    job_title,
    name as company_name,
    job_location,
    job_schedule_type,
    job_country,
    salary_year_avg
from job_postings_fact
    left join company_dim using (company_id)
where job_title_short = 'Data Analyst'
    and salary_year_avg is not null
    and job_location = 'Anywhere'
order by salary_year_avg DESC
limit 10