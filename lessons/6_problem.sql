/*
 find the count of the number of remote job postings per skill
 - display the top 5 skills by their demand in remote job
 - include skill id, name and count of job posting requiring the skill
 */
-- TINH TONG SO JOB CUA TUNG SKILL ID
with remote_job_postings as (
    select skill_id,
        count(*) as count_job
    from job_postings_fact
        inner join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    where job_work_from_home = TRUE and job_title_short = 'Data Analyst'
    group by skill_id
)
select skills_dim.skill_id,
    skills as name,
    count_job
from remote_job_postings
    inner join skills_dim on remote_job_postings.skill_id = skills_dim.skill_id
order by count_job desc
limit 5