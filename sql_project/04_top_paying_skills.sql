/*
This query finds the 5 most financially rewarding skills for data analyst and business analyst roles in France and Canada by:
- Looking at the average salary associated with each skill for data analyst and business analyst roles;
- Filtering for French and Canadian locations;
- Focusing on job postings with specified salaries (removing nulls).
This reveals how different skills impact salary levels for data analysts and business analysts.
Moreover, it helps identifying the most financially rewarding skills to acquire or improve.
*/

SELECT
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS salary_avg
FROM
    job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_title_short IN ('Data Analyst', 'Business Analyst')
    AND
    (job_postings_fact.job_location LIKE '%France%'
    OR
    job_postings_fact.job_location LIKE '%Canada%')
    AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    salary_avg DESC
LIMIT
    5;