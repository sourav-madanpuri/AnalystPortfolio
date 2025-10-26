/*

Queries used for Tableau Project

*/


-- 1. Global Total Cases, Deaths and Death Percentage
SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(CAST(new_deaths AS SIGNED)) AS total_deaths, 
    SUM(CAST(new_deaths AS SIGNED))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY 1,2;

-- 2. Total Death Count by Continent
SELECT 
    continent, 
    SUM(CAST(new_deaths AS SIGNED)) AS TotalDeathCount
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- 3. Countries with Highest Infection Rate compared to Population
SELECT 
    Location, 
    Population, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

-- 4. Countries with Highest Infection Rate by Date
SELECT 
    Location, 
    Population,
    date, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;

-- 5. Daily Cases and Deaths by Country
SELECT 
    Location, 
    date, 
    population, 
    total_cases, 
    total_deaths
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
ORDER BY 1,2;

-- 6. Rolling Vaccination Count with CTE
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CAST(vac.new_vaccinations AS SIGNED)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS RollingPeopleVaccinated
    FROM PortfolioProject.CovidDeaths dea
    JOIN PortfolioProject.CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL AND dea.continent != ''
)
SELECT *, 
    (RollingPeopleVaccinated/Population)*100 AS PercentPeopleVaccinated
FROM PopvsVac;

-- 7. Same as Query 4 (duplicate) - Countries with Highest Infection Rate by Date
SELECT 
    Location, 
    Population,
    date, 
    MAX(total_cases) AS HighestInfectionCount,  
    MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.CovidDeaths
WHERE continent IS NOT NULL AND continent != ''
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected DESC;