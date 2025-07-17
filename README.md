Project 1
# 📊 Job Market Data Analytics in Norway🏔️

## 🔴 Introduccion:

This project explores the job market for Data Analysts in Norway, using data collected from a job postings database. The goal is to understand what makes a position highly paid and what skills are most valuable or in-demand in this field. Below, we answer five key questions:

- Question 1: What are the 15 top-paying jobs for 'Data Analyst' in Norway?
- Question 2: What skills are required for the 15 top-paying jobs?
- Question 3: What are the most in-demand skills for 'Data Analyst' in Norway?
- Question 4: What are the top skills based on salary?
- Question 5: What are the most optimal skills to learn?

🛢️ SQL queries? Check them here [PROJECT_SQL_FILES](PROJECT_SQL)


## 📚 Background:
This project was completed as part of the SQL Portfolio Project from Luke Barousse’s SQL course  https://lukeb.co/sql. 

- 🎯 The goal was to apply real-world SQL skills to analyze job postings data and extract actionable insights relevant to the role of a Data Analyst in Norway. 
- 📊 The analysis includes salary trends, required and in-demand skills, and a breakdown of the most valuable competencies to focus on for career growth.

## 🔧 Tools Used:  

- **SQL** – To extract, manipulate, and analyze data from the job postings database.

- **PostgreSQL** – As the relational database management system for running and testing queries.

- **Visual Studio Code** – For writing and organizing SQL scripts in a clean and efficient environment.

- **GitHub** – To document, version, and share the project as part of my portfolio.

## 📈 The Analysis

In this project, I analyzed job postings for Data Analyst roles in Norway using SQL. The goal was to identify the top-paying positions, the key skills required for those jobs, and determine which skills are most in-demand and best paid. By combining salary data with skill frequency, I was also able to highlight the most optimal skills to learn for maximizing opportunities in the Norwegian data job market.

### Question 1️⃣: 

- What are the 15 top-paying job for 'Data Analyst' in Norway?

```sql
SELECT 
job_id,
job_title_short,
job_location,
job_via,
job_schedule_type,
salary_year_avg,
company_dim.name AS Company_name,
job_posted_date

FROM job_postings_fact

LEFT JOIN company_dim ON
job_postings_fact.company_id = company_dim.company_id


WHERE 
job_title_short = 'Data Analyst' AND
job_country = 'Norway' AND
salary_year_avg IS NOT NULL

ORDER BY
salary_year_avg DESC

LIMIT 15;
```

⭐ Here is the breakdown of the **TOP ANALYST** for the position **Data Analyst** roles in **Norway**:

- **The top-paying Data Analyst position in Norway offered an annual salary of 98,500 USD**, posted by Unacast in Oslo. Most high-paying roles were full-time and concentrated in Oslo, with companies like Statkraft and CGG appearing multiple times. 

- This suggests that **Oslo is a central hub for data analytics roles in Norway**, with competitive salaries in the sector.

- In comparison, **Data Scientist** roles offer **significantly higher salaries than Data Analyst positions in Norway. The top-paying Data Scientist jobs reach up to 157,500 USD annually, while the highest salary for a Data Analyst role is 98,500 USD.** This indicates a notable gap in compensation, reflecting the greater technical complexity and advanced skills typically required for Data Scientist positions.

  <img width="513" height="348" alt="image" src="https://github.com/user-attachments/assets/8e404cce-882a-4ce8-9689-6b6ec501445a" />



### Question 2️⃣: 

- What skills are required for the  15 top-paying for 'Data Analyst' in Norway?

```sql
WITH top_paying_job AS (

    SELECT 
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
    company_dim.name AS Company_name,
    job_posted_date

    FROM job_postings_fact

    LEFT JOIN company_dim ON
    job_postings_fact.company_id = company_dim.company_id


    WHERE 
    job_title_short ='Data Analyst' AND
    job_country = 'Norway' AND
    salary_year_avg IS NOT NULL

    ORDER BY
    salary_year_avg DESC

    LIMIT 15
)

SELECT 
top_paying_job.*,
skills

FROM top_paying_job

INNER JOIN skills_job_dim
ON top_paying_job.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

ORDER BY salary_year_avg DESC
LIMIT 15;
```

⭐ Here is the breakdown of the **SKILLS REQUIERED** for the position **Data Analyst** roles in **Norway**:

What skills are required for the  15 top-paying for 'Data Analyst' in Norway?


- **Python and SQL** are the most frequently required skills among the highest-paying roles.

- Tools like **Excel, Power BI**, and platforms such as GCP, BigQuery, and Databricks are also commonly requested.

- Some companies (like Unacast) list less common skills such as Go and Matplotlib, which may indicate more technically advanced environments.

    <img width="1980" height="1180" alt="Q2" src="https://github.com/user-attachments/assets/dd9cc53a-cd8d-4d05-b4d4-565cd5fd725c" />


### Question 3️⃣:

- What are the most in-demand skills for 'Data Analyst' in Norway?

```sql
SELECT 
skills,
COUNT (skills_job_dim.job_id) AS demand_count

from 
job_postings_fact 

INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

where 
job_postings_fact.job_work_from_home = true AND
job_postings_fact.job_title_short = 'Data Analyst' AND
job_postings_fact.job_country = 'Norway'

GROUP BY skills

ORDER BY demand_count DESC
LIMIT 5;
```

⭐ Here is the breakdown of the **MOST IN DEMAND SKILLS** for the position **Data Analyst** roles in **Norway**:

- **Python** (8) – Most requested skill for data analysis and automation.

- **SQL** (7) – Essential for querying databases.

- **Go** (7) – Popular in backend and data processing tasks.

- **Power BI** (5) – Key tool for data visualization.
- **R** (5) – Used for advanced statistical analysis.

### Question 4️⃣:

- - What are the top skills based on salary for'Data Analyst' in Norway?

```sql
SELECT 
skills,
ROUND(AVG (salary_year_avg),0) AS average_salary

from 
job_postings_fact 

INNER JOIN skills_job_dim 
ON job_postings_fact.job_id = skills_job_dim.job_id

INNER JOIN skills_dim
ON skills_job_dim.skill_id = skills_dim.skill_id

where 
job_postings_fact.job_work_from_home = true AND
job_postings_fact.job_title_short = 'Data Analyst' 
AND job_postings_fact.job_country = 'Norway' 
-- AND job_postings_fact.salary_year_avg IS NOT NULL

GROUP BY skills

ORDER BY average_salary DESC
LIMIT 10;
```

⭐ Here is the breakdown of the **top skills based on salary** for the position **Data Analyst** roles in **Norway**:

- Alteryx – High-paying tool for data preparation and automation.

- BigQuery – In-demand for scalable data analysis in the cloud.

- DAX – Used for advanced calculations in Power BI.

- Excel – Still essential, especially when paired with modern tools.

- Git – Valuable for version control and collaboration.

- Go – Known for backend and data-heavy applications.

- JavaScript – Useful for data visualization and dashboards.

- Power BI – Popular tool with strong salary potential.

- PowerShell – Handy for automation and data management tasks.

- Airflow – Valued for orchestrating data pipelines.

### Question 5️⃣:

What are the most optimal skills to learn?

```sql
WITH skills_demand AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT (skills_job_dim.job_id) AS demand_count,
    job_country

    from 
    job_postings_fact 

    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id

    INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id

    where 
    --job_country IN ('Norway', 'Sweden') AND
    job_postings_fact.job_country = 'Norway' AND
    job_postings_fact.job_work_from_home = true AND
    job_postings_fact.job_title_short = 'Data Analyst'
    

    GROUP BY 
    skills_dim.skill_id, 
    skills_dim.skills,
    job_postings_fact.job_country

), average_salary AS(
    SELECT 
    skills_job_dim.skill_id,
    skills,
    ROUND(AVG (salary_year_avg),0) AS avg_salary

    from 
    job_postings_fact 

    INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id

    INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id

    where 

    -- job_country IN ('Norway', 'Sweden') AND
    job_postings_fact.job_country = 'Norway' AND
    job_postings_fact.job_work_from_home = true AND
    job_postings_fact.job_title_short = 'Data Analyst'
    
    -- AND job_postings_fact.salary_year_avg IS NOT NULL

    GROUP BY 
    skills_job_dim.skill_id, 
    skills_dim.skills,
    job_postings_fact.job_country

)

SELECT
skills_demand.skill_id,
skills_demand.skills,
demand_count,
avg_salary,
job_country

FROM skills_demand

INNER JOIN average_salary 
ON skills_demand.skill_id = average_salary.skill_id

ORDER BY
demand_count DESC,
avg_salary DESC

LIMIT 20
```
⭐ Here is the breakdown of the **most optimal skills to learn** for the position **Data Analyst** roles in **Norway**:

- Python, SQL, Go – High in demand and fundamental for most analyst roles.

- Power BI, Tableau, R – Visualization and statistical tools frequently requested by employers.

- Excel, DAX, VBA – Classic tools still valued in many organizations.

- Git, Airflow, Pyspark, Snowflake – More advanced or technical tools that signal strong data engineering and analytics capabilities.

- SAS, SPSS, Alteryx – Specialized tools often used in industries like finance or research.

📌 Focusing on the most in-demand tools like Python, SQL, and Power BI offers great career potential. Adding advanced tools (e.g., Airflow or Snowflake) can set you apart in the Norwegian job market.


## 🧐 What I learn:

This project helped me strengthen my skills in SQL data analysis and gave me hands-on experience working with real-world job market data. Some key learnings include:

- Using **CTEs** (Common Table Expressions) to organize complex queries, especially for filtering and ranking the top-paying jobs.

- **JOIN** operations (e.g., INNER JOIN, LEFT JOIN) were essential to combine job data with skills and company information across multiple tables.

- Aggregation functions like **COUNT() and AVG()** were crucial for measuring skill demand and calculating average salaries.

- Filtering and sorting with **WHERE, ORDER BY, and LIMIT** helped isolate the most relevant jobs (e.g., top 15 Data Analyst roles in Norway).

- **GROUP BY** and subqueries enabled skill-level analysis by demand and salary.

## ⭐ Conclusions:

- Data Analysts in Norway are in high demand, especially those with strong technical skills like Python, SQL, and Power BI. However, their salaries are generally lower compared to Data Scientists, highlighting a potential area for career growth or upskilling.

- The most valuable skills combine high demand and salary potential. Learning tools such as Python, Power BI, and cloud platforms like BigQuery or GCP can position professionals for better-paying roles and increased job opportunities in the Norwegian tech market.
