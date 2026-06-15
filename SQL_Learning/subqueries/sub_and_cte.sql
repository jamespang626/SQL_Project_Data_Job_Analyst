SELECT*
FROM ( 
    SELECT *
    from job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 1
) AS january_jobs;

WITH january_jobs AS (
    SELECT *
    from job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 1
)
SELECT *
FROM january_jobs;

