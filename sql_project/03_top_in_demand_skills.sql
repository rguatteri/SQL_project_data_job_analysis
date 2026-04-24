/*
This query finds the most in-demand skills for data analyst and business analyst roles in France and Canada by:
- Using INNER JOIN similarly to what is done in '02_top_paying_skills.sql';
- Identifying the top 5 in-demand skills for data analysts and business analysts.
This provides job seekers (like me) with insights into the most valuable skills;
I.e., the skills having the highest demand in the French and Canadian job markets for data analyst and business analyst roles.
N.B. Since this query does NOT focus on the salary, the 'job_postings_fact.salary_year_avg IS NOT NULL' filter is omitted from the WHERE clause.
*/

SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
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
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT
    5