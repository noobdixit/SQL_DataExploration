--SELECT *
--FROM CovidDeaths

--SELECT * 
--FROM CovidVaccination

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM CovidDeaths 
order by location,date 

--Looking at Total Cases VS Total Deaths 

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths 
order by location,date 

SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths 
WHERE location ='India'
order by location,date 

--Looking at Total Cases VS Population, means what % of people has got COVID

SELECT location,date,population,total_cases,(total_cases/population)*100 AS COVIDPercentage
FROM CovidDeaths 
WHERE location ='India'
order by location,date 

--Looking at countries with highest infection rate

SELECT location,population,MAX(total_cases) AS MaximumCases,MAX((total_cases/population))*100 AS HighestInfectionRate
FROM CovidDeaths 
--WHERE location ='India'
GROUP BY location,population
ORDER BY HighestInfectionRate DESC

--Looking at countries with highest death percentage

SELECT location,population,MAX(cast(total_deaths as int)) AS MaximumDeaths,MAX((total_deaths/population))*100 AS HighestDeathpecentage
FROM CovidDeaths 
--WHERE location ='India'
GROUP BY location,population
ORDER BY HighestDeathpecentage DESC

--Looking at maxmimum percentage of Continent

SELECT location,max(cast(total_deaths as int)) as MaximumDeaths
from CovidDeaths
where continent is null
group by location

--Looking at GLOBAL NUMBERS

SELECT date,SUM(new_cases) as TotalCases,SUM(cast (new_deaths as bigint)) as TotalDeaths, (SUM(cast (new_deaths as bigint))/SUM(new_cases))*100 as DeathPercentage
from CovidDeaths
--where location='India'
WHERE continent is not null
Group by date
order by date

--Total Number of Cases VS Death Percentage in the World 

SELECT SUM(new_cases) as TotalCases,SUM(cast (new_deaths as bigint)) as TotalDeaths, (SUM(cast (new_deaths as bigint))/SUM(new_cases))*100 as DeathPercentage
from CovidDeaths
--where location='India'
WHERE continent is not null

--TOTAL NUMBER OF CASES IN INDIA 

SELECT SUM(new_cases) as TotalCases,SUM(cast (new_deaths as bigint)) as TotalDeaths, (SUM(cast (new_deaths as bigint))/SUM(new_cases))*100 as DeathPercentage
from CovidDeaths
where location='India'


--JOINS

--LOOKIMG AT TOTAL POPULATION VS NEW VACCINATIONS

SELECT CovidDeaths.continent,CovidDeaths.location,CovidDeaths.date,CovidDeaths.population,CovidVaccination.new_vaccinations
FROM CovidDeaths
JOIN CovidVaccination
	ON CovidDeaths.location=CovidVaccination.location
	and CovidDeaths.date=CovidVaccination.date
	WHERE CovidDeaths.continent is not null --and CovidVaccination.new_vaccinations is not null and CovidDeaths.location='India'
order by 2,3

--LOOKING AT TOTAL POPULATION VS TOTAL VACCINATIONS

SELECT CovidDeaths.continent,CovidDeaths.location,CovidDeaths.date,CovidDeaths.population,CovidVaccination.new_vaccinations,SUM(cast(CovidVaccination.new_vaccinations as bigint)) 
OVER(PARTITION BY CovidDeaths.location order by CovidDeaths.location,CovidDeaths.date) AS TotalVaccinations
FROM CovidDeaths
JOIN CovidVaccination
ON CovidDeaths.location=CovidVaccination.location and CovidDeaths.date=CovidVaccination.date
--WHERE CovidDeaths.location='India' 
WHERE CovidDeaths.continent is not null

--POPULATION VACCINATED IN INDIA

SELECT CovidDeaths.continent,CovidDeaths.location,CovidDeaths.date,CovidDeaths.population,CovidVaccination.people_fully_vaccinated 
FROM CovidDeaths
JOIN CovidVaccination
ON CovidDeaths.location=CovidVaccination.location and CovidDeaths.date=CovidVaccination.date
WHERE CovidDeaths.location='India'

-- Using CTE

With PopvsVac (Continent, Location, Date, Population, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population,vac.people_fully_vaccinated
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
and dea.location='India'
)

Select *, (PeopleVaccinated/Population)*100
From PopvsVac

-- Creating View to store data for later visualizations

CREATE VIEW PercentPolulatedVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population,(vac.people_fully_vaccinated/population)*100 AS PercentPopulationVaccinated
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--and dea.location='India'

SELECT * 
from PercentPolulatedVaccinated