-- CTE skills demand
with skills_demand as (
    select skill_id,
        skills,
        count(skills) as count_skills
    from job_postings_fact
        inner join skills_job_dim using(job_id)
        inner join skills_dim using (skill_id)
    where job_postings_fact.job_title_short = 'Data Analyst'
        and salary_year_avg is not null
        and job_work_from_home = True
    group by skill_id,
        skills
) -- CTE average salary year
,
average_salary as (
    select skill_id,
        skills as skills_name,
        round(avg(salary_year_avg), 2) as avg_salary
    from job_postings_fact
        inner join skills_job_dim using(job_id)
        inner join skills_dim using (skill_id)
    where job_title_short = 'Data Analyst'
        and salary_year_avg is not null
    group by skill_id,
        skills
)
select skills_demand.skill_id,
    skills_demand.skills,
    count_skills,
    avg_salary
from skills_demand
    INNER JOIN average_salary using(skill_id)
order by count_skills desc,
    avg_salary desc