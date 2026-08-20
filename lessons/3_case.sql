select count(job_id) as count_job_by_locatiol_cateogry,
    case
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact
where job_title_short = 'Data Analyst'
group by location_category