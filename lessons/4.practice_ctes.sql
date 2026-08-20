select cd.company_id,
    cd.name,
    case
        when mc.count_job < 10 then 'Small'
        when mc.count_job between 10 and 50 then 'Medium'
        else 'Large'
    end as category_company_of_job
from company_dim as cd
    left join (
        SELECT company_id,
            count(job_id) as count_job
        FROM job_postings_fact
        GROUP BY company_id
    ) as mc on cd.company_id = mc.company_id