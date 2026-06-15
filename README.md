# SQL Project: Data Analyst Job Market Analysis 📊

## 📌 Introduction

This project analyzes 2023 data analyst job postings using SQL to identify trends in salaries, skills, and job demand.

The goal of this project is to answer practical job-market questions, including which data analyst roles paid the most, which skills were most in demand, and which skills were associated with higher salaries in 2023.

🔗 **Check out the SQL queries:** [project_sql folder](project_sql)

---

## 🎯 Background

As a recent Economics graduate looking for my first job, I noticed that many business, finance, and data-related roles ask for previous experience, even when they are listed as entry-level. This made the job search challenging because I was trying to break into the field without professional analyst experience yet.

While reading job descriptions on LinkedIn and Indeed, I started noticing that SQL appeared often in analyst-related roles. At first, I did not know what SQL was, but I realized it was an important skill to learn if I wanted to become a stronger candidate.

I decided to learn SQL from the beginning and build this project as a way to practice real analysis, better understand the job market, and show employers my ability to learn technical skills independently.

This project focuses on answering five main questions:

1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn for a data analyst looking to maximize job market value?

---

## 🛠️ Tools I Used

* **SQL**: The main language used to explore and analyze the job posting data.
* **SQLite**: I first learned SQL using SQLite because it is simple, lightweight, and good for practicing the basics.
* **PostgreSQL**: After learning the basics, I moved to PostgreSQL to practice using a more advanced database system.
* **Visual Studio Code**: I used VS Code to write, organize, and manage my SQL files.
* **Git & GitHub**: I used Git for version control and GitHub to store and share my project.
* **Markdown**: I used Markdown to write and format this README.

---

## 🔍 The Analysis

### 1. Top-Paying Data Analyst Jobs 💰

This query identifies the top 10 highest-paying data analyst roles in San Francisco and San Jose. I focused on these two locations because they are major job markets in the Bay Area and are relevant to the types of roles I am interested in.

This query selects job details such as job title, location, schedule type, average yearly salary, posting date, and company name. I used a `LEFT JOIN` to connect the job posting table with the company table so each job posting could show the company name.

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

---

### 2. Skills Required for Top-Paying Data Analyst Jobs 🧠

This query builds on the first query by finding the skills required for the top 10 highest-paying data analyst jobs in San Francisco and San Jose.

I used a `WITH` statement to create a temporary result called `top_paying_jobs`, which stores the top-paying data analyst jobs first. Then, I joined that result with the skills tables to see which skills were listed for each high-paying job.

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

---

### 3. Top In-Demand Skills for Data Analyst Jobs 📈

This query identifies the top 5 most requested skills for data analyst job postings in San Francisco and San Jose.

I joined the job postings table with the skills tables so each job posting could be connected to its listed skills. Then, I used `COUNT()` to count how many times each skill appeared, grouped the results by skill, and sorted them from highest to lowest demand.

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

---

### 4. Top-Paying Skills for Data Analyst Jobs 💵

This query identifies the top 25 skills associated with the highest average salaries for data analyst jobs in San Francisco and San Jose.

I joined the job postings table with the skills tables, filtered for data analyst roles with salary data, and grouped the results by skill. Then, I used `AVG()` to calculate the average salary for each skill and `ROUND()` to make the salary values easier to read.

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

---

### 5. Optimal Skills to Learn for Data Analyst Jobs 🚀

This query identifies skills that are both in demand and associated with higher average salaries for data analyst jobs in San Francisco and San Jose.

I used two CTEs to separate the logic into smaller steps. The first CTE, `skills_demand`, counts how often each skill appears in job postings. The second CTE, `average_salary`, calculates the average salary connected to each skill. Then, I joined both results together to compare demand and salary side by side.

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

---

## 🧩 What I Learned

Through this project, I learned three main things:

### 1. How to use SQL to answer real questions

I practiced writing queries that answered job-market questions instead of only doing basic exercises. This helped me understand how SQL can be used to turn raw data into useful insights.

### 2. How to connect and summarize data from multiple tables

I used `JOIN` to combine job postings, companies, and skills together. I also used `COUNT()`, `AVG()`, `GROUP BY`, and `ORDER BY` to find patterns in demand, salary, and skills.

### 3. How to think more carefully about data analysis

I learned that one number does not always tell the full story. For example, a skill may have a high average salary, but it may not be very useful to focus on if it only appears in a few job postings. This is why I compared both skill demand and average salary in the final query.

---

## ✅ Conclusion

### Insights

From the 2023 job posting data, this project showed that data analyst roles in San Francisco and San Jose valued a mix of technical and analytical skills. Some skills appeared often across job postings, while other skills were connected to higher average salaries.

One important takeaway is that salary alone does not tell the full story. A skill may be linked to a high average salary, but if it appears in only a few postings, it may not be the most practical skill to focus on first. By comparing both demand and salary, I was able to identify skills that were more useful to prioritize.

### Closing Thoughts

This project helped me practice SQL in a real-world context instead of only doing basic exercises. It also helped me better understand what employers were looking for in data analyst roles in 2023.

As a recent Economics graduate looking for my first analyst role, this project gave me hands-on experience with SQL, PostgreSQL, VS Code, Git, GitHub, and Markdown. It also gave me a clearer direction for continuing to build my skills in SQL, Excel, and Power BI.
