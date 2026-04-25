/*
This query finds the required skills for data analyst and business analyst roles in France and Canada by:
- Using the available data analyst and business analyst job postings identified via '01_available_jobs.sql';
- Adding the skills required for data analyst and business analyst roles.
This provides job seekers (like me) with a detailed look at which skills are required for these roles and worth developing.
*/

WITH available_jobs AS (
    SELECT
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        job_postings_fact.salary_year_avg,
        company_dim.name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim
        ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_postings_fact.job_title_short IN ('Data Analyst', 'Business Analyst')
        AND
        (job_postings_fact.job_location LIKE '%France%'
        OR
        job_postings_fact.job_location LIKE '%Canada%')
        AND
        job_postings_fact.salary_year_avg IS NOT NULL
    ORDER BY
        job_postings_fact.salary_year_avg
)

SELECT
    available_jobs.*,
    skills_dim.skills
FROM
    available_jobs
INNER JOIN skills_job_dim
    ON available_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg;

/*
For the data set I analyzed, this query returns 318 entries - one for each skill mentioned in each job posting.
Indeed job postings are likely to list multiple skills.
Moreover - after closely looking at the job_id column - this query only returns 77 out of the 84 job postings retrieved via '01_available_jobs.sql'.
Those 7 left-out job postings arguably list no skills.
*/