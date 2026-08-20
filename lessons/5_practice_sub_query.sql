select sd.skill_id,
    sd.skills,
    mjk.quantity_job
from skills_dim as sd
    left join (
        select skill_id,
            count(job_id) as quantity_job
        from skills_job_dim
        group by skill_id
    ) as mjk on sd.skill_id = mjk.skill_id
order by mjk.quantity_job desc
limit 5