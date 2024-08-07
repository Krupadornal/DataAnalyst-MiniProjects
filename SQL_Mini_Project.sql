Select *
From krupa..CovidD
order by 3,4

--Select *
--From krupa..CovidVaa
--order by 3,4

--select data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From krupa..CovidD
order by 1,2

-- Looking at Total Cases vs Total Deaths 
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPerecentage
From krupa..CovidD
Where location like '%india%'
order by 1,2

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPerecentage
From krupa..CovidD
Where location like '%States%'
order by 1,2

---- show likelihood  of dying if you contract covid in your country 

---Loking at the Total cases vs population

Select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPerecentage
From krupa..CovidD
Where location like '%states'
order by 1,2

Select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPerecentage
From krupa..CovidD
Where location like '%india'
order by 1,2

---shows the what percentage of pop got covid

select
  Population,
  total_cases,
  (cast(total_cases as decimal) / cast(Population as decimal)) * 100 as covidPercentage
From
  krupa..CovidD
Where
  location is not null
order by
  1, 2;


---checking for the highest infection vs population rate 

Select Location,  Population, MAX(total_cases) as HighestInfectioncount,MAX(total_cases/population)*100 as percentPopulationInfected
From krupa..CovidD
Where location like '%states%'
Group by Location, Population
order by 1,2

Select Location,  Population, MAX(total_cases) as HighestInfectioncount,MAX(total_cases/population)*100 as percentPopulationInfected
From krupa..CovidD
---Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

---showing countries with Highest death count per population

Select Location,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From krupa..CovidD
---Where location like '%states%'
Where continent is  not null
Group by Location
order by TotalDeathCount desc

---break down by continent 

Select continent,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From krupa..CovidD
---Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--- with null/not null  value and location 

Select Location,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From krupa..CovidD
---Where location like '%states%'
Where continent is null
Group by Location
order by TotalDeathCount desc

---showing the continnet with the highest death count per population 

Select Location,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From krupa..CovidD
---Where location like '%states%'
Where continent is null
Group by Location
order by TotalDeathCount desc

--- Global numbers

Select  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From krupa..CovidD
---Where location like '%states%'
Where continent is not null
Group By date
order by 1,2


-----CovidVaa

Select *
From krupa..CovidD dea
Join krupa..CovidVaa vac
    On dea.location = vac.location
	and dea.date = vac.date

---looking at the total Population  vs Vaccination


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date)as RollingPeopleVaccinated
---, (RollingPeoplevaccinated/Population)*100
FROM krupa..CovidD dea
JOIN krupa..CovidVaa vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;
---)
---Select *
---from PopvsVac

---Using CTE 

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date)as RollingPeopleVaccinated
---, (RollingPeoplevaccinated/Population)*100
FROM krupa..CovidD dea
JOIN krupa..CovidVaa vac
  ON dea.location = vac.location
  AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3;
)
Select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac



--- Temp Table

DROP Table if exists #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From krupa..CovidD dea
Join krupa..CovidVaa vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated









 












