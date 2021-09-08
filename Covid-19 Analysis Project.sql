

Select  * 
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

Select location,date,population,new_cases,total_deaths
From PortfolioProject..CovidDeaths
order by 1,2

--Total Cases Vs Total Deaths
Select location,date,population,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Shows Likelihood of dying if you contract covid in your country
Select location,date,population,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%Pakistan%' and continent is not null
order by 1,2

--Total Case Vs Population
-- Show What Percentage of People got Covid
Select location,date,population,total_cases,(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Countries With Highest Infection Rate compared to Population

Select location,population,MAX(total_cases) as HighestInfectionCount,MAX(total_cases/population)*100 
as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by location,population
order by PercentPopulationInfected desc

-- Countries With Highest Death Count per Population

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc


-- Continent With Highest Death Count per Population

Select location,MAX(cast(total_deaths as int)) as TotalDeathCount 
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
order by TotalDeathCount desc

-- Global Numbers

Select date,SUM(new_cases) as TotalCases,SUM(cast(new_deaths as int)) as TotalDeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercentage 
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1,2 


--Total Population Vs Vacciantion

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) Over(Partition by dea.location Order by dea.location,dea.date) as PeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Tempt Table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
PeopleVaccinated numeric
)
Insert Into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) Over(Partition by dea.location Order by dea.location,dea.date) as PeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
Select *,(PeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Create View to Store data for Visualization
Create View PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) Over(Partition by dea.location Order by dea.location,dea.date) as PeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
ON dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
Select * 
From PercentPopulationVaccinated

