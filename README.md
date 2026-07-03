# 🧑‍💻 SQL Data Analyst Job Market Project

This project uses SQL to analyze **Data Analyst job postings from 2023–2025**, focusing on salary trends, skill demand, and high-value skills in the job market.

The goal of this project is to practice real-world SQL analysis by answering business-style questions about which Data Analyst roles pay the most, which skills appear most often, and which skills provide the best balance between salary and demand.

---

## 📌 Project Overview

| Area | Details |
|---|---|
| **Project Focus** | Data Analyst job market analysis |
| **Data Scope** | Job postings from 2023–2025 |
| **Main Tools** | SQL, PostgreSQL, VS Code, Git, GitHub |
| **Main Skills Used** | Joins, CTEs, aggregate functions, filtering, grouping, sorting |
| **Goal** | Identify salary trends, skill demand, and practical skills to prioritize |

---

## 📁 Repository Structure

| Folder / File | Description |
|---|---|
| [`project_sql/`](project_sql/) | Main SQL queries used for the project analysis |
| [`SQL_Learning/`](SQL_Learning/) | SQL practice and learning files |
| `README.md` | Project documentation |
| `.gitignore` | Files ignored by Git |

---

## 🎯 Business Questions

This project answers five main questions:

1. What are the top-paying Data Analyst jobs?
2. What skills are required for the top-paying Data Analyst jobs?
3. What skills are most in demand for Data Analyst roles?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn based on both salary and demand?

---

## 🧰 Tools Used

- SQL
- PostgreSQL
- VS Code
- Git
- GitHub
- Markdown

---

## 🧠 SQL Skills Demonstrated

- `SELECT`
- `WHERE`
- `ORDER BY`
- `LIMIT`
- `JOIN`
- `LEFT JOIN`
- `INNER JOIN`
- `GROUP BY`
- `COUNT()`
- `AVG()`
- `ROUND()`
- Common Table Expressions, also known as CTEs
- Filtering null values
- Combining salary and skill-demand analysis

---

# 📊 The Analysis

## 1️⃣ Top-Paying Data Analyst Jobs

This query identifies the top 10 highest-paying Data Analyst roles in **San Francisco** and **San Jose**.

I focused on these two locations because they are major Bay Area job markets and are relevant to the types of analyst roles I am interested in.

### What this query does

- Filters for Data Analyst roles
- Focuses on San Francisco and San Jose
- Removes job postings without salary data
- Joins job postings with company information
- Sorts jobs by average yearly salary

### SQL Query

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location LIKE '%San Jose%' OR
    job_location LIKE '%San Francisco%') AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

### Key Takeaway

This query helped identify which Data Analyst roles offered the highest salaries in the selected Bay Area markets.

---

## 2️⃣ Skills Required for Top-Paying Jobs

This query builds on the first analysis by identifying the skills required for the top-paying Data Analyst jobs.

### What this query does

- Uses a CTE to first find the top-paying jobs
- Joins the top-paying jobs with skill tables
- Shows which skills appear in high-paying job postings

### SQL Query

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        (job_location LIKE '%San Jose%' OR
        job_location LIKE '%San Francisco%') AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

### Key Takeaway

This query helped connect salary information with specific technical skills, showing what employers requested for higher-paying roles.

---

## 3️⃣ Most In-Demand Skills for Data Analyst Jobs

This query identifies the top 5 most requested skills for Data Analyst job postings in San Francisco and San Jose.

### What this query does

- Joins job postings with skill tables
- Counts how often each skill appears
- Groups results by skill
- Sorts skills by demand

### SQL Query

```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location LIKE '%San Jose%' OR
    job_location LIKE '%San Francisco%')
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

### Key Takeaway

This query helped identify which skills appeared most frequently in Data Analyst job postings.

---

## 4️⃣ Top-Paying Skills for Data Analyst Jobs

This query identifies the top 25 skills associated with the highest average salaries for Data Analyst roles.

### What this query does

- Filters for Data Analyst roles with salary data
- Joins job postings with skill tables
- Calculates the average salary for each skill
- Sorts skills by average salary

### SQL Query

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    (job_location LIKE '%San Jose%' OR
    job_location LIKE '%San Francisco%') AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    average_salary DESC
LIMIT 25;
```

### Key Takeaway

This query showed that some skills are linked with higher average salaries, but salary alone does not always mean a skill is the most practical to prioritize.

---

## 5️⃣ Optimal Skills to Learn

This query identifies skills that are both **in demand** and associated with **higher average salaries**.

Instead of only looking at salary or only looking at demand, this analysis compares both together.

### What this query does

- Creates one CTE for skill demand
- Creates another CTE for average salary by skill
- Joins both CTEs together
- Filters for skills with meaningful demand
- Sorts by demand and salary

### SQL Query

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        (job_location LIKE '%San Jose%' OR
        job_location LIKE '%San Francisco%') AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
),
average_salary AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        (job_location LIKE '%San Jose%' OR
        job_location LIKE '%San Francisco%') AND
        salary_year_avg IS NOT NULL
    GROUP BY
        skills_dim.skill_id
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    demand_count DESC,
    average_salary DESC
LIMIT 25;
```

### Key Takeaway

This was the most useful query because it compares both **market demand** and **salary value**. A skill with a high salary but low demand may not be as practical to prioritize as a skill that appears often and still has strong salary potential.

---

## 💡 Main Insights

From this project, I learned that Data Analyst job postings often require a mix of technical and analytical skills.

Important insights:

- High-paying roles often require stronger technical skills.
- Skill demand and salary should be analyzed together.
- A skill may have a high average salary but still appear in only a small number of postings.
- SQL is useful for turning raw job posting data into practical career and market insights.
- CTEs make complex analysis easier to organize and understand.

---

## 📚 What I Learned

Through this project, I practiced using SQL to answer real analytical questions instead of only completing basic exercises.

I learned how to:

- Write SQL queries for business-style questions
- Join multiple tables together
- Use aggregate functions to summarize data
- Filter and sort results for meaningful analysis
- Use CTEs to organize multi-step queries
- Compare salary and demand together
- Think more carefully about what makes a skill valuable in the job market

---

## 🎯 Portfolio Purpose

This project is part of my data analytics portfolio as I continue building skills for entry-level roles such as:

- Data Analyst
- Business Analyst
- Finance Analyst

The purpose of this repository is to show my ability to use SQL for data analysis, job market research, and insight generation.

---

## ✅ Conclusion

This project helped me practice SQL in a realistic job-market analysis context. By analyzing Data Analyst postings from 2023–2025, I was able to better understand how salary, skills, and demand connect in the analyst job market.

The biggest lesson from this project is that good analysis should look at more than one metric. Salary is important, but demand matters too. Comparing both helped me identify which skills may be more useful to prioritize as I continue building my data analytics skill set.