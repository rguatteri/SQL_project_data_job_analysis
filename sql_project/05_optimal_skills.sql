/*
This query finds the most optimal skills to learn (i.e., those skills being in high demand and high-paying)...
... for data analyst and business analyst roles in France and Canada by:
- Identifying skills in high demand and associated with high average salaries for data analyst and business analyst roles;
- Focusing on job postings in France and Canada with specified salaries.
This reveals which target skills offer job security (high demand) and financial benefits (high salaries).
Ultimately, this provides strategic insights for career development in data analyst and business analyst positions.
*/

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
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
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) >= 10
ORDER BY
    salary_avg DESC,
    demand_count DESC
LIMIT
    10;