-- Combines rows where location and date match in both tables

SELECT dea.location, dea.date, dea.total_cases, vac.new_vaccinations
FROM krupa..CovidD dea
JOIN krupa..CovidVaa vac
  ON dea.location = vac.location
  AND dea.date = vac.date

-- Includes all rows from CovidD table, even if no matching vaccination data exists

SELECT dea.location, dea.date, dea.total_cases, vac.new_vaccinations
FROM krupa..CovidD dea
LEFT JOIN krupa..CovidVaa vac
  ON dea.location = vac.location
  AND dea.date = vac.date


---Includee all the rows from CovidVaa and matching rows from CovidD

SELECT dea.location, dea.date, dea.total_cases, vac.new_vaccinations
FROM krupa..CovidD dea
RIGHT JOIN krupa..CovidVaa vac
  ON dea.location = vac.location
  AND dea.date = vac.date

---exploring the data using an inner join ,inwhich include the rows where the match between the location and the date in both tables

SELECT dea.location, dea.date, dea.total_cases, vac.new_vaccinations
FROM krupa..CovidD dea
INNER JOIN krupa..CovidVaa vac
  ON dea.location = vac.location
  AND dea.date = vac.date

---This includes all rows from both tables CovidD and CovidVaa, without considering  the match location or the date in both tables

SELECT dea.location, dea.date, dea.total_cases, vac.new_vaccinations
FROM krupa..CovidD dea
FULL OUTER JOIN krupa..CovidVaa vac
  ON dea.location = vac.location
  AND dea.date = vac.date

---This include all the rows from CovidD and matching rows from covidVaa 

SELECT *
FROM krupa..CovidD dea
LEFT OUTER JOIN krupa..CovidVaa vac
ON dea.location = vac.location
AND dea.date = vac.date;








 












