Select * from Portfolioproject..CovidDeaths
Where continent is not null
order by 3, 4

--select * from CovidVaccinations
--order by 3, 4

-- select data that we are going to use

select location, date, total_cases, new_cases, total_deaths, population
from Portfolioproject..CovidDeaths
Where continent is not null
order by 1,2

-- This query explores the total cases vs the total deaths
-- This shows the possibility of death if you contract Covid-19
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from Portfolioproject..CovidDeaths
Where location = 'United Kingdom'
Where continent is not null
order by 1,2

-- This query looks at the percentage of the population that contracted covid
select Location, date, population, total_cases, (total_cases/population)*100 as populationwithcovid
from Portfolioproject..CovidDeaths
Where location = 'United Kingdom'
Where continent is not null
order by 1,2


--This query explores the infection rates of countries against their population 
--This allows us to look at the countiries with the highest infection count
select Location, population, MAX(total_cases) as Highestinfectioncount, Max((total_cases/population))*100 as percentofpopulationinfected
from Portfolioproject..CovidDeaths
--Where location = 'United Kingdom'
Group by location, population
order by percentofpopulationinfected desc

-- This query explores the countries with the highest death count per population
select Location, MAX(cast(total_deaths as int)) as TotalDeathcount
from Portfolioproject..CovidDeaths
--Where location = 'United Kingdom'
Where continent is not null
Group by Location
order by TotalDeathcount desc

-- Breaking things down by continent
select location, MAX(cast(total_deaths as int)) as TotalDeathcount
from Portfolioproject..CovidDeaths
--Where location = 'United Kingdom'
Where continent is null
Group by location
order by TotalDeathcount desc

-- Breaking things down by continent
select continent, MAX(cast(total_deaths as int)) as TotalDeathcount
from Portfolioproject..CovidDeaths
--Where location = 'United Kingdom'
Where continent is not null
Group by continent 
order by TotalDeathcount desc

-- showing continents with highest deathcounts ^^

-- Global Numbers


-- Global death percentage (All cases)
select sum(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths , SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
from Portfolioproject..CovidDeaths
--Where location = 'United Kingdom' 
Where continent is not null
--Group by date
order by 1,2

-- global death percentage for each date within time-frame of data
select date, sum(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths , SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
from Portfolioproject..CovidDeaths
Where continent is not null
Group by date
order by 1,2

--overall death percentage for all cases grouped by continent
select continent, sum(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths , SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage
from Portfolioproject..CovidDeaths
--Where location = 'United Kingdom' 
Where continent is not null
Group by continent
order by 1,2


-- This query explores the total percentage of the population vaccinated at each date within time fram
-- CTE

with popvsVac (continent, location, date, population, new_vaccinations, Rolling_people_vaccinated)
as
(

Select CDA.continent, CDA.location, CDA.date, CDA.population, CVA.new_vaccinations
, SUM(CAST(CVA.new_vaccinations as int)) OVER (partition by CDA.location order by CDA.location ,CDA.date)
as Rolling_people_vaccinated

from Portfolioproject..CovidDeaths CDA
Join Portfolioproject..CovidVaccinations CVA
	On CDA.location = CVA.location 
	and CDA.date = CVA.date
Where CDA.continent is not null 
--AND CDA.location = 'Canada'
--order by 2,3
)
Select *, (Rolling_people_vaccinated/population)*100
from popvsVac


-- Creating view to store data for later visualisations 

create view percentpopulationvaccinated as

Select CDA.continent, CDA.location, CDA.date, CDA.population, CVA.new_vaccinations
, SUM(CAST(CVA.new_vaccinations as int)) OVER (partition by CDA.location order by CDA.location ,CDA.date)
as Rolling_people_vaccinated

from Portfolioproject..CovidDeaths CDA
Join Portfolioproject..CovidVaccinations CVA
	On CDA.location = CVA.location 
	and CDA.date = CVA.date
Where CDA.continent is not null 
--AND CDA.location = 'Canada'
--order by 2,3 

select * from percentpopulationvaccinated

-- view 
-- This query explores the total cases vs the total deaths
-- This shows the possibility of death if you contract Covid-19
Create view Deathpercentage as
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from Portfolioproject..CovidDeaths
--Where location = 'United Kingdom'
Where continent is not null
--order by 1,2

select * from Deathpercentage