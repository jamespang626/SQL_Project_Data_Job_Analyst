SELECT
  job_id,
  job_title,
  salary_year_avg,
  CASE 
    WHEN salary_year_avg >= 100000 THEN 'High salary'
    WHEN salary_year_avg >= 60000 THEN 'Standard salary'
    WHEN salary_year_avg < 60000 THEN 'Low salary'
  END AS salary_category
FROM 
	job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
    and job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;