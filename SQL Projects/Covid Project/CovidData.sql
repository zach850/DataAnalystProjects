-- veiw the covid deaths table
Select *
From CovidDeaths

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases V Total Deaths 
SELECT location, date, total_cases,total_deaths,(CAST(total_deaths AS FLOAT) / CAST(total_cases AS FLOAT)) * 100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%states%'
ORDER BY location, date;


  -- Looking at Total Cases V Population

  SELECT location, date, total_cases, population, (CAST(total_cases AS FLOAT) / CAST(population AS FLOAT)) * 100 AS PercentPopSick
FROM CovidDeaths
WHERE location LIKE '%states%'
ORDER BY location, date;


-- Countries with highest infection rate compared to population 
 SELECT location, MAX(total_cases) as HighestInfectionCount, population, MAX((CAST(total_cases AS FLOAT) / CAST(population AS FLOAT))) * 100 AS PercentPopSick
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopSick Desc;

-- Countries with highest death count percent per population
SELECT location, Max(total_deaths) as total_deaths, population, Max((CAST(total_deaths as FLOAT)/CAST(population as float))) * 100 as death_count_percent
FROM CovidDeaths
Group by location, population
ORDER BY death_count_percent Desc;

--Countries with highest death count
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount Desc

-- Continents with highest deaths 
Select location, MAX(cast(total_deaths as float)) as TotalDeathCount
From CovidDeaths
Where continent is null 
	and Location <> 'High Income' 
	and Location <> 'Low Income' 
	and Location <> 'Upper middle income'
	and Location <> 'Lower middle income'
Group by location
Order by TotalDeathCount Desc

-- Global numbers
Select SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int)) / SUM(new_cases) * 100 as DeathPercentage
From CovidDeaths
Where continent is not null
Order by 1,2


-- Joining both tables
Select * 
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

-- Total Population v Vaccination 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(Cast(vac.new_vaccinations as float)) Over (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3

-- CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(Cast(vac.new_vaccinations as float)) Over (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
	and dea.location LIKE '%states%'
)
Select *, (RollingPeopleVaccinated/Population) *100
From PopvsVac

-- Temp table 
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(Cast(vac.new_vaccinations as float)) Over (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select *, (RollingPeopleVaccinated/Population) *100
From #PercentPopulationVaccinated

-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	Sum(Cast(vac.new_vaccinations as float)) Over (Partition by dea.location Order by dea.location , dea.date) as RollingPeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
 