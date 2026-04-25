/*
This query finds job postings for data analyst and business analyst roles in France and Canada by:
- Identifying the available data analyst and business analyst job postings;
- Filtering for French and Canadian locations;
- Focusing on job postings with specified salaries (removing nulls);
*/

SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    job_postings_fact.job_location,
    job_postings_fact.job_schedule_type,
    job_postings_fact.salary_year_avg,
    job_postings_fact.job_posted_date,
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
    job_postings_fact.salary_year_avg;

/*
In the data set I analyzed, there seems to be 84 job postings for data analyst and business analyst roles in France and Canada with specified salaries.
Specifically, there seems to be 51 and 27 job postings for data analyst roles in France and Canada, respectively.
Conversely, there seems to be just 3 job postings for business analyst roles both in France and Canada.
Role-specific and location-specific insights can be obtained by filtering for a single role and/or location in the WHERE clause.
N.B. Removing the 'job_postings_fact.salary_year_avg IS NOT NULL' filter from the WHERE clause returns over 16800 such job postings (!).
*/