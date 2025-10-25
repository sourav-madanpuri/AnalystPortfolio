-- Covid 19 Data Exploration 
-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

-- See Structure of tables 
DESCRIBE PortfolioProject.CovidDeaths;
DESCRIBE PortfolioProject.CovidVaccinations;

-- Noticed date column has been imported as text, let's convert it to DATE for date-wise analysis
-- Be attentive on safe update

SET SQL_SAFE_UPDATES = 0;
-- Convert the text column to date type
UPDATE PortfolioProject.CovidDeaths 
SET date = DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%Y-%m-%d');
-- Then alter the column type
ALTER TABLE PortfolioProject.CovidDeaths 
MODIFY COLUMN date DATE;
SET SQL_SAFE_UPDATES = 1;

-- Doing the same for Vaccinations Table

SET SQL_SAFE_UPDATES = 0;
UPDATE PortfolioProject.CovidVaccinations
SET date = DATE_FORMAT(STR_TO_DATE(date, '%d/%m/%y'), '%Y-%m-%d');
ALTER TABLE PortfolioProject.CovidVaccinations 
MODIFY COLUMN date DATE;
SET SQL_SAFE_UPDATES = 1;

-- Now let's see an overview of Deaths data 

SELECT *
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY 3,4;


-- Select Data that we are going to be starting with

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY 1,2;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.CovidDeaths
WHERE location LIKE '%India%'
AND continent IS NOT NULL AND continent != ''
ORDER BY 1,2;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT Location, date, Population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.CovidDeaths
ORDER BY 1,2;


-- Top 10 Countries with Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, 
ROUND(MAX((total_cases/population))*100,2) AS PercentPopulationInfected
FROM PortfolioProject.CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC LIMIT 10 ;


-- Countries with Highest Death Count per Population

SELECT Location, MAX(CAST(Total_deaths AS SIGNED)) AS TotalDeathCount
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY Location
ORDER BY TotalDeathCount DESC;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing continents with the highest death count per population

SELECT continent, MAX(CAST(Total_deaths AS SIGNED)) AS TotalDeathCount
-- total_deaths, new_deaths, new_vaccinations values represent counts that should never be negative
-- SIGNED is actually more appropriate than SIGNED INT
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;


-- GLOBAL NUMBERS By Date for India

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS SIGNED)) AS total_deaths, 
SUM(CAST(new_deaths AS SIGNED))/SUM(New_Cases)*100 AS DeathPercentage
FROM PortfolioProject.CovidDeaths
-- WHERE location LIKE '%India%'
WHERE continent IS NOT NULL AND continent != ''
GROUP BY date
ORDER BY 4 desc;


-- Total Population vs Vaccinations on Each Day - Rolling Sum

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != ''
ORDER BY location, DATE_FORMAT(dea.date, '%y/%m/%d');


-- Cannot put conditional statement on window functions directly with SELECT statement
-- Using CTE to get Rolling Vac% 

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM PortfolioProject.CovidDeaths dea
    JOIN PortfolioProject.CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL AND dea.continent != ''
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM PopvsVac;


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TEMPORARY TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated (
    Continent VARCHAR(255),
    Location VARCHAR(255),
    Date DATETIME,
    Population NUMERIC,
    New_vaccinations NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

INSERT INTO PercentPopulationVaccinated
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    -- Handle New_vaccinations column
    CASE 
        WHEN vac.new_vaccinations = '' THEN 0
        ELSE CAST(vac.new_vaccinations AS DECIMAL(15,2))
    END as New_vaccinations,
    -- Handle rolling sum
    SUM(CASE 
        WHEN vac.new_vaccinations = '' THEN 0
        ELSE CAST(vac.new_vaccinations AS DECIMAL(15,2))
    END) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM PercentPopulationVaccinated ;


-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject.CovidDeaths dea
JOIN PortfolioProject.CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.continent != '';

