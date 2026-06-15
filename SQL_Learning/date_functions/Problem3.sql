SELECT
    company_dim.name AS company_name,
    COUNT(job_id) AS total_job_postings
FROM
    job_postings_fact
    INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_health_insurance IS TRUE AND
    EXTRACT(QUARTER FROM job_posted_date) = 2
GROUP BY
    company_dim.name
HAVING
    COUNT(job_postings_fact.job_id) > 0
ORDER BY
    total_job_postings DESC;