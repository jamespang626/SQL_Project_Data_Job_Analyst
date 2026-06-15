CREATE TABLE data_science_job(
    job_id INT PRIMARY KEY,
    job_title TEXT,
    company_name TEXT,
    post_date DATE
);

ALTER TABLE data_science_job
ADD COLUMN company_name TEXT;

INSERT INTO data_science_job (
    job_id,
    job_title,
    company_name,
    post_date)
VALUES (1,
        'Data Scientist',
        'Tech Innovations',
        'January 1, 2023'),
        (2,
        'Machine Learning Engineer',
        'Data Driven Co',
        'January 15, 2023'),
        (3,
        'AI Specialist',
        'Future Tech',
        'February 1, 2023');

SELECT * FROM data_science_job;

ALTER TABLE data_science_job
ADD COLUMN remote BOOLEAN;

ALTER TABLE data_science_job
RENAME COLUMN post_date TO posted_on;

ALTER TABLE data_science_job
ALTER COLUMN remote SET DEFAULT FALSE;

INSERT INTO data_science_job (
    job_id,
    job_title,
    company_name,
    posted_on,
    remote)
VALUES (4,
        'Data Scientist',
        'Google',
        '2023-02-05',
        FALSE);

ALTER TABLE data_science_job
DROP COLUMN company_name;

UPDATE data_science_job
SET remote = TRUE
WHERE job_id = 2;

DROP TABLE data_science_job;