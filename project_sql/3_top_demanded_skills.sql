/*
    Question: What are the most in-demand skills for data analyst?
    - Join job postings to inner join table similar to query 2
    - Indentify the top 5 in-demand skills for a data analyst.
    - Focus on all job postings.
    - Why? Retrieves the top 5 skills with the highest demand in the job market,
    Providing insights into the most valuable skills for job seekers
*/


select skills, count(skills) as count_skills
from job_postings_fact
    inner join skills_job_dim using(job_id)
    inner join skills_dim using (skill_id)
where job_postings_fact.job_title_short = 'Data Analyst'
group by skills
order by count_skills desc
limit 5