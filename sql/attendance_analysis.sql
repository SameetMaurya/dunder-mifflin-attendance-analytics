-- Dunder Mifflin Attendance Analysis
-- Assumed table: attendance
-- Columns: Employee, DateTime, InOut, PrevTime, Duration, Department

-- 1. Total employees
SELECT COUNT(DISTINCT Employee) AS total_employees
FROM attendance;

-- 2. Work hours by employee
SELECT Employee, Department,
       ROUND(SUM(CASE WHEN InOut = 'Out' THEN Duration ELSE 0 END), 2) AS total_work_hours
FROM attendance
GROUP BY Employee, Department
ORDER BY total_work_hours DESC;

-- 3. Work hours by department
SELECT Department,
       COUNT(DISTINCT Employee) AS employee_count,
       ROUND(SUM(CASE WHEN InOut = 'Out' THEN Duration ELSE 0 END), 2) AS total_work_hours
FROM attendance
GROUP BY Department
ORDER BY total_work_hours DESC;

-- 4. Daily work hours
SELECT CAST(DateTime AS DATE) AS work_date,
       ROUND(SUM(CASE WHEN InOut = 'Out' THEN Duration ELSE 0 END), 2) AS total_work_hours
FROM attendance
GROUP BY CAST(DateTime AS DATE)
ORDER BY work_date;

-- 5. Employee attendance days
SELECT Employee, COUNT(DISTINCT CAST(DateTime AS DATE)) AS attendance_days
FROM attendance
GROUP BY Employee
ORDER BY attendance_days DESC;

-- 6. Late arrivals (first entry after 09:00)
WITH first_entry AS (
    SELECT Employee, CAST(DateTime AS DATE) AS work_date,
           MIN(DateTime) AS first_in
    FROM attendance
    WHERE InOut = 'In'
    GROUP BY Employee, CAST(DateTime AS DATE)
)
SELECT *
FROM first_entry
WHERE CAST(first_in AS TIME) > '09:00:00'
ORDER BY first_in;
