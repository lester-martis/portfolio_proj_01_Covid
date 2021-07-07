-- 1. complete covid data set exploration
SELECT * FROM covid_death
WHERE continent IS NOT NULL
ORDER BY continent;

-- 2. Infection rate (this data exlains top 10 countries which have highest infection rate to it's population)
SELECT
	location,
    MAX(total_cases) as total_cases,
    population,
    ROUND((MAX(total_cases) / population) * 100, 2) as infection_rate
FROM
	covid_death
-- WHERE location LIKE '%ind%'
GROUP BY location
ORDER BY infection_rate DESC
LIMIT 10;

-- 3. Countries with highest death rate,
-- (Explains which country has highest death rate comparing total cases where total cases are more than 100). 
SELECT
	location,
    MAX(total_deaths) AS total_deaths,
    MAX(total_cases) AS total_cases,
    ROUND((MAX(total_deaths) / MAX(total_cases)) * 100, 2) AS death_rate
    
FROM
	covid_death
    WHERE total_cases > '100' AND iso_code NOT LIKE '%OWID%'
GROUP BY location
 ORDER BY death_rate DESC;
 
 -- 4. Total deaths country wise
 SELECT
		location,
        MAX(total_deaths) AS total_deaths
FROM
	covid_death
WHERE iso_code NOT LIKE '%OWID%'
GROUP BY location
ORDER BY total_deaths DESC;

-- 5. Total deaths continent wise
SELECT
	continent,
    MAX(total_deaths) as total_deaths
FROM
	covid_death
WHERE total_deaths > '0' AND iso_code NOT LIKE '%OWID%'
GROUP BY continent
ORDER BY total_deaths DESC;

-- 6. Global Data (Daily_cases_deaths)
SELECT
	date,
    SUM(new_deaths) AS Daily_Deaths,
    SUM(new_cases) AS Daily_Cases,
    ROUND((SUM(new_deaths) / SUM(new_cases)) * 100, 2) as daily_death_rate
FROM
	covid_death
WHERE iso_code NOT LIKE '%OWID%' 
GROUP BY date;
-- ORDER BY date -- daily_death_rate DESC;


-- 7. Use of CTE & Joining covid_deaths and vaccination tables.

with vaccVsPop (continent, location, date, population, new_vaccinations, total_vaccinated)
AS
(
SELECT
	dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(new_vaccinations) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS total_vaccinated
FROM
	covid_death dea
JOIN
	covid_vacc vac
ON
	dea.date = vac.date AND dea.location = vac.location
    WHERE dea.iso_code NOT LIKE '%OWID%'
    ORDER BY dea.location, total_vaccinated
)

SELECT
	*, ROUND((total_vaccinated/population) *100, 2) AS vaccination_rate
FROM
	vaccVspop;
    
-- 8. Temp Table
DROP TABLE if exists vacc_data;
CREATE TABLE vacc_data
(
	continet varchar(255),
    location varchar(255),
    date text,	
    population bigint,
    new_vaccinations bigint,
    total_vaccinated bigint
);

INSERT INTO vacc_data   
SELECT
	dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(new_vaccinations) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS total_vaccinated
FROM
	covid_death dea
JOIN
	covid_vacc vac
ON
	dea.date = vac.date AND dea.location = vac.location
    WHERE dea.iso_code NOT LIKE '%OWID%'
    ORDER BY dea.location, total_vaccinated;

SELECT
	*, ROUND((total_vaccinated/population) *100, 2) AS vaccination_rate
FROM
	vacc_data;
    
-- 9. Creating a view - Covid_deaths_continent (for data visualization)

CREATE VIEW continent_deaths AS
SELECT
	continent,
    MAX(total_deaths) as total_deaths
FROM
	covid_death
WHERE total_deaths > '0' AND iso_code NOT LIKE '%OWID%'
GROUP BY continent
ORDER BY total_deaths DESC;


    
    
-- 10. Creating a view - Vaccination Data (for data visualization)
CREATE view data_vaccination AS 
SELECT
	dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(new_vaccinations) OVER (partition by dea.location ORDER BY dea.location, dea.date) AS total_vaccinated
FROM
	covid_death dea
JOIN
	covid_vacc vac
ON
	dea.date = vac.date AND dea.location = vac.location
    WHERE dea.iso_code NOT LIKE '%OWID%'
    ORDER BY dea.location, total_vaccinated;
