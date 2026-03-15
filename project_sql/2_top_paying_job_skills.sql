/*
 Question: What skills are required for the top-paying data analyst jobs?
 - use the top 10 highest-paying Data Analyst jobs from first query
 -- add the specific skills required for these roles
 - Why? It provides a detailed look at which higt-paying jobs demand certain skills,
 helping job seekers understand which skills to develop that align with top salaries
 */
with top_paying_job as (
    select job_id,
        job_title,
        name as company_name,
        salary_year_avg
    from job_postings_fact
        left join company_dim using (company_id)
    where job_title_short = 'Data Analyst'
        and salary_year_avg is not null
        and job_location = 'Anywhere'
    order by salary_year_avg DESC
    limit 10
)
select top_paying_job.*,
    skills as skill_name
from top_paying_job
    inner join skills_job_dim using(job_id)
    inner join skills_dim using (skill_id)
order by salary_year_avg DESC