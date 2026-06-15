WITH average_salary_countries AS (
    SELECT
        job_country,
        AVG(salary_year_avg) AS average_salary
    FROM job_postings_fact
    WHERE
        salary_year_avg IS NOT NULL
    GROUP BY
        job_country
)

SELECT
    job_postings_fact.job_id,
    job_postings_fact.job_title,
    company_dim.name AS company_name,
    job_postings_fact.salary_year_avg AS salary_rate,
    CASE
        WHEN job_postings_fact.salary_year_avg > average_salary_countries.average_salary THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_category,
    EXTRACT(MONTH FROM job_postings_fact.job_posted_date) AS posting_month
FROM
    job_postings_fact
    INNER JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    INNER JOIN average_salary_countries on job_postings_fact.job_country = average_salary_countries.job_country
ORDER BY
    posting_month DESC
