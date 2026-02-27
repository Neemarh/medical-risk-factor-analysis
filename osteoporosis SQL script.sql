SELECT *
FROM osteoporosis;

-- Check data quality
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Id) AS unique_patients,
    MIN(Age) AS min_age,
    MAX(Age) AS max_age,
    AVG(Age) AS avg_age
FROM osteoporosis;

-- Check missing values
SELECT 
    COUNT(*) - COUNT(Gender) AS missing_gender,
    COUNT(*) - COUNT(Osteoporosis) AS missing_target
FROM osteoporosis;

SELECT 
    COUNT(*) AS total_patients,
    SUM(Osteoporosis) AS osteoporosis_cases,
    ROUND(AVG(Osteoporosis) * 100, 2) AS prevalence_percent
FROM osteoporosis;

SELECT 
    CASE 
        WHEN Age < 30 THEN '<30'
        WHEN Age BETWEEN 30 AND 50 THEN '30-50'
        WHEN Age BETWEEN 51 AND 70 THEN '51-70'
        ELSE '70+'
    END AS age_group,
    COUNT(*) AS patient_count,
    SUM(Osteoporosis) AS cases,
    ROUND(AVG(Osteoporosis) * 100, 1) AS prevalence
FROM osteoporosis
GROUP BY age_group
ORDER BY 
    CASE age_group
        WHEN '<30' THEN 1
        WHEN '30-50' THEN 2
        WHEN '51-70' THEN 3
        ELSE 4
    END;
    
    SELECT 
    Gender,
    `Body Weight`,
    `Calcium Intake`,
    `Vitamin D Intake`,
    `Physical Activity`,
    Smoking,
    `Prior Fractures`,
    Medications,
    COUNT(*) AS n_patients,
    SUM(Osteoporosis) AS n_cases,
    ROUND(AVG(Osteoporosis) * 100, 1) AS risk_percent
FROM osteoporosis
WHERE Age < 50
GROUP BY Gender, `Body Weight`, `Calcium Intake`, `Vitamin D Intake`,
         `Physical Activity`, Smoking, `Prior Fractures`, Medications
HAVING COUNT(*) >= 5   -- filter for statistical relevance
ORDER BY risk_percent DESC
LIMIT 20;

SELECT 
    CASE WHEN Age < 50 THEN 'Under 50' ELSE '50 and over' END AS age_cat,
    CASE 
        WHEN Medications LIKE '%Corticosteroids%' THEN 'Corticosteroid user'
        ELSE 'Non‑user'
    END AS med_status,
    COUNT(*) AS total,
    SUM(Osteoporosis) AS cases,
    ROUND(AVG(Osteoporosis) * 100, 1) AS prevalence
FROM osteoporosis
GROUP BY age_cat, med_status
ORDER BY age_cat, med_status;

SELECT  Age,
    Gender,
    `Physical Activity`,
    `Calcium Intake`,
    `Body Weight`,
    COUNT(*) AS n,
    AVG(Osteoporosis) * 100 AS pct_osteoporosis
FROM osteoporosis
WHERE Age < 50
GROUP BY `Physical Activity`, `Calcium Intake`, `Body Weight`
HAVING `Physical Activity` = 'Sedentary'
   AND `Calcium Intake` = 'Low'
   AND `Body Weight` = 'Underweight';