/*
 Answer: What are the top skills based on salary?
 look at the average salary associated with each skill for DA postions 
 focuses on roles with specified salaries, regardless of location
 why? it reveals how diffrent skills impact salary levels for Da and helps
 idnetify the most financially rewarding skills to acquire or improve
 */
select skills as skills_name,
    round(avg(salary_year_avg), 2) as avg_salary,
    count(skills) as job_count
from job_postings_fact
    inner join skills_job_dim using(job_id)
    inner join skills_dim using (skill_id)
where job_title_short = 'Data Analyst'
    and salary_year_avg is not null
group by skills_name
order by avg_salary desc
limit 25