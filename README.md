# Introduction
📊 Let's dive into the data job market! Focusing on data analyst and business analyst job postings in France 🇫🇷 and Canada 🇨🇦, this project explores:
- 💰 Top-paying jobs;
- 🔥 In-demand skills;
- 📈 Where high demand meets high salary.

🔍 I conducted this analysis via SQL. You can check the queries I produced here: [sql_project](/sql_project/).

# Background
As a current job seeker in the data analyst and business analyst job market, this project pinpoints top-paid and in-demand skills, possibly streamlining others' work to find optimal jobs.

Data hails from Luke Barousse's [SQL Course](https://lukebarousse.com/sql). It's packed with insights on over **30,000 job postings**, including job titles, salaries, locations, and essential skills.

### The questions I wanted to answer through my SQL queries were:

1. What are the available data analyst and business analyst job opportunities in France and Canada?
2. What skills are required for these roles?
3. What skills are most in demand for data analysts and business analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** the backbone of my analysis, allowing me to query the database and unearth critical insights;
- **PostgreSQL:** the chosen database management system, ideal for handling job posting data;
- **Visual Studio Code:** my go-to for database management and executing SQL queries;
- **Git & GitHub:** essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst and business analyst job market. Here’s how I approached each question.

### 1. Available Data Analyst and Business Analyst Jobs
To identify the available roles, I filtered data analyst and business analyst positions by average yearly salary and location, focusing on job postings from France and Canada. This query highlights the available opportunities in the field.
```sql
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
```
Here's the breakdown of the available data analyst and business analyst job opportunities:
- In the data set I analyzed, there seems to be **84 job postings** for data analyst and business analyst roles in France and Canada with specified salaries;
- Specifically, there seems to be **51** and **27** job postings for **data analyst** roles in France and Canada, respectively;
- Conversely, there seems to be just **3** job postings for **business analyst** roles both in France and Canada.

> Role-specific and location-specific insights were obtained by filtering for a single role and/or location in the WHERE clause. The same goes for the queries below.

> **N.B.** Removing the 'job_postings_fact.salary_year_avg IS NOT NULL' filter from the WHERE clause returns over **16800** such job postings (!).

### 2. Skills for Available Jobs
To understand what skills are required for the available data analyst and business analyst roles in France and Canada, I joined the job postings with the skills data, providing insights into which skills are required for these roles and worth developing.
```sql
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
```
> **N.B.** For the data set I analyzed, this query returns 318 entries - one for each skill mentioned in each job posting - as job postings are likely to list multiple skills. Moreover - after closely looking at the job_id column - this query only returns 77 out of the 84 job postings retrieved via '01_available_jobs.sql', as those 7 left-out job postings arguably list no skills.

Here's the breakdown of the most required skills from job postings with specified salaries for data analyst and business analyst roles in France and Canada:
- **SQL** is leading across all scenarios; 
- **Python** closely follows;
- **Tableau** is also highly sought after.

Other skills like **Excel**, **PowerBI**, **SAS**, **Azure**, and **Spark** show varying degrees of demand.

![Required Skills](/sql_project/results/2_available_jobs_skills.png)
*Bar charts visualizing the count of the 10 most required skills for the available data analyst and business analyst roles in France and Canada. Due to the limited amount of job postings for business analyst roles with specified salaries, only the four most required skills are showed.*

### 3. In-Demand Skills
This query helped identify the five most frequently requested skills in job postings for data analyst and business analyst roles in France and Canada, **irrespective of whether the salary is specified**.

> **N.B.** Since this query does NOT focus on the salary, the 'job_postings_fact.salary_year_avg IS NOT NULL' filter is omitted from the WHERE clause.

```sql
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
    5;
```
Here's the breakdown of the most in-demand skills from job postings for data analyst and business analyst roles in France and Canada:
- **SQL** and **Excel** remain fundamental, emphasizing the need for strong foundational skills in data processing and spreadsheet manipulation;
- **Programming** and **Visualization Tools** like **Python**, **Tableau**, and **Power BI** are essential, pointing towards the increasing importance of technical skills in data storytelling and decision support.

![In-Demand Skills](/sql_project/results/3_jobs_top_skills_all.png)
*Bar charts visualizing the count of the five most required skills for the available data analyst and business analyst roles in France and Canada.*

### 4. Skills Based on Salary
This query helped identify the five most financially rewarding skills for data analyst and business analyst roles in France and Canada.

This revealed how different skills impact salary levels for data analysts and business analysts. Moreover, it helped identifying the most financially rewarding skills to acquire or improve.
```sql
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
```
Here's a breakdown of the results for top paying skills for data analyst and business analyst roles in France and Canada:
- Looking at the big picture, top salaries are driven by **DevOps/infrastructure responsibilities** (**GitLab**, **Terraform**) and **engineering skills** (**Kafka**, **C#**); expertise in low-level, high-performance programming languages such as **C** is also highly rewarded;
- **Business Analyst**: proficiency in data engineering and/or **cloud tools** (**Cassandra**, **AWS**) and **backend/system-level** programming languages (**Go**) similarly benefits business analysts' salary;
- **Data Analyst (France)**: top-paying data analyst roles in France show a strong **DevOps/infrastructure** component (**GitLab**, **Terraform**, **Docker**);
- **Data Analyst (France)**: top-paying data analyst roles in Canada require a combination of **full-stack/development** skills (**TypeScript**, **JavaScript**) and **big data / cloud analytics** expertise (**Spark**, **Hadoop**, **BigQuery**);
- Ultimately, highest-paying opportunities seems to address **hybrid technical profiles**, combining data analysis with **software engineering** and **DevOps/infrastructure** expertise.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| gitlab        |            163,782 |
| terraform     |            163,782 |
| c             |            131,500 |
| kafka         |            111,216 |
| c#            |            111,202 |

*Average salary for the top 5 paying skills for data analyst and business analyst roles in France and Canada.*

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pandas        |            111,175 |
| cassandra     |            111,175 |
| aws           |            111,175 |
| go            |            111,175 |
| kafka         |            100,138 |

*Average salary for the top 5 paying skills for business analyst roles in France and Canada.*

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| c             |            200,000 |
| gitlab        |            163,782 |
| terraform     |            163,782 |
| kafka         |            118,602 |
| docker        |            113,994 |

*Average salary for the top 5 paying skills for data analyst roles in France.*

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| typescript    |            108,416 |
| spark         |            107,479 |
| hadoop        |            107,167 |
| javascript    |            101,750 |
| bigquery      |            101,750 |

*Average salary for the top 5 paying skills for data analyst roles in Canada.*

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and high-paying.

This revealed which target skills offer job security (high demand) and financial benefits (high salaries). Ultimately, this provides strategic insights for career development in data analyst and business analyst positions.

```sql
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
```

Here's a breakdown of the most optimal skills for data analyst and business analyst roles in France and Canada:
- Looking at the big picture, there is a *core stack* dominating both demand and salary: **SQL**, **Python**, **Tableau**, and **Excel** are the most reliable, high-demand, and high-paying skills; **cloud and big data** skills (**Spark** and **Azure**) lead to higher salaries in spite of their demand being lower than core **BI tools** (**Tableau**, **Power BI**);
- **Business Analyst**: **Python** is the only skills balancing demand and salary, with higher salaries coming from technical and niche tools (**Cassandra**, **AWS**, **Kafka**, **Go**); however, these findings might be inconclusive due to the extremely small sample size;
- **Data Analyst**: **SQL**, **Python**, and **Tableau** balance demand and salary both in France and Canada, with the latter showing an almost even salary distribution across these core tools (Tableau ~92k, Python ~92k, SQL ~89k); additionally, **Azure** seems to add a salary boost in France.

> **N.B.** Only skills featured in at least 10 job postings were retained, apart from business analyst roles, as there were only six job postings for this role in the analyzed data set.

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 92       | spark      | 10           |             98,902 |
| 1        | python     | 37           |             94,045 |
| 74       | azure      | 12           |             87,664 |
| 0        | sql        | 48           |             85,175 |
| 181      | excel      | 17           |             84,523 |
| 182      | tableau    | 28           |             80,921 |
| 183      | power bi   | 14           |             79,083 |

*Most optimal skills for data analyst and business analyst roles in France and Canada. Results are sorted by decreasing average salary.*

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 63       | cassandra  | 1            |            111,175 |
| 76       | aws        | 1            |            111,175 |
| 93       | pandas     | 1            |            111,175 |
| 8        | go         | 1            |            111,175 |
| 98       | kafka      | 2            |            100,138 |
| 1        | python     | 3            |             96,758 |
| 4        | java       | 1            |             90,000 |
| 105      | gdpr       | 1            |             90,000 |
| 124      | selenium   | 1            |             90,000 |
| 215      | flow       | 1            |             90,000 |

*Most optimal skills for business analyst roles in France and Canada. Results are sorted by decreasing average salary.*

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 1        | python     | 20           |             94,724 |
| 74       | azure      | 10           |             86,095 |
| 0        | sql        | 28           |             83,666 |
| 182      | tableau    | 19           |             75,403 |

*Most optimal skills for data analyst roles in France. Results are sorted by decreasing average salary.*

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 182      | tableau    | 9            |             92,572 |
| 1        | python     | 14           |             92,494 |
| 0        | sql        | 16           |             89,285 |
| 181      | excel      | 9            |             83,563 |

*Most optimal skills for data analyst roles in Canada. Results are sorted by decreasing average salary.*

Ultimately, the most optimal profiles combine a broad base of core tools (SQL, Python, BI tools) with cloud or big data specializations:
- **Python** is the skill that best balances high demand and high salary;
- **SQL** represents an essential baseline;
- **Business intelligence tools** (**Tableau**, **Power BI**) are required for employability;
- An advanced skill (**Spark** or **Azure**) adds salary leverage.

# What I Learned

Throughout this analysis, I've mastered SQL basics via:

- **🧩 Complex Query Crafting:** mastered the art of advanced SQL, merging tables and wielding WITH clauses;
- **📊 Data Aggregation:** used GROUP BY and turned aggregate functions like COUNT() and AVG() into my data-summarizing sidekicks;
- **💡 Analytical Wizardry:** leveled up my real-world puzzle-solving skills, turning questions into actionable, insightful SQL queries.

# Conclusions

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst and Business Analyst Jobs**: the highest-paying jobs for data analysts and business analysts in France and Canada offer a wide range of salaries;
2. **Skills for Top-Paying Jobs**: high-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary;
3. **Most In-Demand Skills**: SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers;
4. **Skills with Higher Salaries**: specialized skills are associated with the highest average salaries, indicating a premium on niche expertise;
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.

### Closing Thoughts

This project enhanced my SQL skills and provided valuable insights into the data analyst and business analyst job markets in France and Canada. The findings from the analysis serve as a guide to prioritizing skill development and job search efforts. Aspiring data analysts can better position themselves in a competitive job market by focusing on high-demand, high-salary skills. This exploration highlights the importance of continuous learning and adaptation to emerging trends in the field of data analytics.
