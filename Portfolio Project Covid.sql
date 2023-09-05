Select *
From [Portfolio Project]..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From [Portfolio Project]..CovidVaccinations
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
order by 1,2


-- Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, 
(cast(total_deaths as decimal))/cast(total_cases as decimal)*100 as deathpercentage
From [Portfolio Project]..CovidDeaths
WHERE location like '%states%'
order by 1,2 


-- looking at Total Cases vs Population
--Shows what % of population got covid

Select Location, date, total_cases, population, 
(cast(Total_cases as decimal))/cast(Population as decimal)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
WHERE location like '%states%'
order by 1,2  



--What countries have highest infection rates compared to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,
Max(cast(Total_cases as decimal))/cast(Population as Decimal)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Group by location, Population
order by PercentPopulationInfected desc  

Select Date, Location, Population, total_cases
From [Portfolio Project]..CovidDeaths
Where location like '%Cyprus%'

Select DATE,Location, Population, cast(total_cases as int) as maxtotalcase
From dbo.CovidDeaths
Where location like '%Cyprus%'
order by maxtotalcase asc

Select Date, Location, Population, total_cases
From [Portfolio Project]..CovidDeaths
Where location like '%San Marino%'


-- Looking at Total Cases vs Population
-- Shows what percentsge of population got Covid


Select Location, Population, MAX(total_cases) as HighestInfectionCount,
Max(cast(Total_cases as decimal))/cast(Population as Decimal)*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Group by location, population
order by PercentPopulationInfected desc




-- Showing countries with Highest Death Count per population

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Location
Order By TotalDeathCount desc



-- Let's break things down by continent

Select Continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Continent
Order By TotalDeathCount desc

-- Showing continent with the highest death count

Select Continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
Group by Continent
Order By TotalDeathCount desc

-- GLobal Numbers

Select SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, 
SUM(Cast(New_Deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group by date
order by 1,2



-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVacinnated
--, (RollingPeopleVacinnated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVacinnated
--,(RollingPeopleVacinnated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
	Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



--TEMP TABLE

Drop Table if exists #PercentpopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVacinnated
--,(RollingPeopleVacinnated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVacinnated
--,(RollingPeopleVacinnated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *
From PercentPopulationVaccinated