Select*
From portfolio..[covid deaths]
Where continent is not null
order by 3,4

--Select*
--From portfolio..[covid vaccine]
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From portfolio..[covid deaths]
Where continent is not null
order by 1,2

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
-- SHOWS THE LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN ASIA
Select Location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as int))*100 as death_percentage
From portfolio..[covid deaths]
Where location like '%india%'
and continent is not null
order by 1,2



-- LOOKING AT TOTAL CASES VS POPULATION
-- SHOWS WHAT PERCENTAGE OF POPULATION in india got COVID

Select Location, date, total_cases, population, (cast(total_cases as float)/cast(population as bigint))*100 as covid_percentage
From portfolio..[covid deaths]
Where Location like '%india%'
and continent is not null
order by 1,2

--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

Select Location, date, population, MAX(total_cases) as Highest_infection_count, MAX(cast(total_cases as float)/cast(population as bigint))*100 as max_covid_percentage
From portfolio..[covid deaths]
--Where Location like '%india%'
Where continent is not null
group by location, population,date
order by max_covid_percentage desc

Select Location, population, MAX(total_cases) as Highest_infection_count, MAX(cast(total_cases as float)/cast(population as bigint))*100 as max_covid_percentage
From portfolio..[covid deaths]
--Where Location like '%india%'
where continent is not null
group by location, population
order by max_covid_percentage desc

-- SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

Select Location, MAX(cast(total_deaths as int)) as Highest_death_count
From portfolio..[covid deaths]
--Where Location like '%india%'
Where continent is not null
group by location
order by Highest_death_count desc

-- NOW BASED ON CONTINENT, HIGHEST DEATH COUNT AND TOTAL DEATH COUNT
Select continent, SUM(cast(total_deaths as int)) as Total_death_count
From portfolio..[covid deaths]
Where continent is not null
and continent not in ('world', 'european union', 'international')
group by continent
order by Total_death_count desc

Select continent, MAX(cast(total_deaths as int)) as Highest_death_count
From portfolio..[covid deaths]
Where continent is not null
group by continent
order by Highest_death_count desc

Select date, Sum(new_cases) as total_new_cases, Sum(cast(new_deaths as int)) as total_new_deaths, sum(cast(new_deaths as int))/nullif(sum(new_cases),0)*100 as daily_death_percentage
From portfolio..[covid deaths]
Where continent is not null
group by date
order by 1,2

Select Sum(new_cases) as total_new_cases, Sum(cast(new_deaths as int)) as total_new_deaths, sum(cast(new_deaths as int))/nullif(sum(new_cases),0)*100 as daily_death_percentage
From portfolio..[covid deaths]
Where continent is not null
order by 1,2

-- LOOKING AT TOTAL POPULATION VS VACCINATIONS

select *
From portfolio..[covid deaths] dea
Join portfolio..[covid vaccine] vac
 On dea.location = vac.location
  and dea.date = vac.date

  -- TOTAL NUMBER OF PEOPLE IN THE WORLD GOT VACCINATED

  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  From portfolio..[covid deaths] dea
Join portfolio..[covid vaccine] vac
 On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null 
  order by 2,3

  -- SUM OF TOTAL NUMBER OF NEW VACCINATION LOCATION WISE
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as total_vaccination_location_wise
  From portfolio..[covid deaths] dea
Join portfolio..[covid vaccine] vac
 On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null AND dea.location = 'india'
  order by 2,3

  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as total_vaccination_location_wise
  From portfolio..[covid deaths] dea
Join portfolio..[covid vaccine] vac
 On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null 
  order by 2,3

  -- HOW MANY PEOPLE COUNTRYWISE ARE VACCINATED ( USING CTE)

  
 With popvac (Continent, Location, Date, Population,new_vaccinations,total_vaccination_location_wise)
 AS
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as total_vaccination_location_wise
  From portfolio..[covid deaths] dea
Join portfolio..[covid vaccine] vac
 On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  )
  Select *, (total_vaccination_location_wise/Population)*100 as vaccination_percentage
  From popvac

  With popvac1 (Continent, Location, Date, Population,new_vaccinations,total_vaccination_location_wise)
 AS
 (
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
  , Sum(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.date) as total_vaccination_location_wise
  From portfolio..[covid deaths] dea
Join portfolio..[covid vaccine] vac
 On dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null and dea.location = 'india'
  )
  Select *, (total_vaccination_location_wise/Population)*100 as vaccination_percentage
  From popvac1

  
  
 

 -- CREATE VIEW TO STORE DATA VISUALIZATIONS ON TABLEAU

 Create View death_percentage as
 Select Location, date, total_cases, total_deaths, (cast(total_deaths as int)/cast(total_cases as int))*100 as death_percentage
From portfolio..[covid deaths]
Where location like '%india%'
and continent is not null
--order by 1,2

  Create View covid_percentage as
  Select Location, date, total_cases, population, (cast(total_cases as int)/cast(population as int))*100 as covid_percentage
From portfolio..[covid deaths]
Where Location like '%india%'
and continent is not null
--order by 1,2

Create View max_covid_percentage as
Select Location, population, MAX(total_cases) as Highest_infection_count, MAX(cast(total_cases as int)/cast(population as bigint))*100 as max_covid_percentage
From portfolio..[covid deaths]
--Where Location like '%india%'
Where continent is not null
group by location, population
--order by max_covid_percentage desc

select * from dbo.death_percentage

select * from dbo.covid_percentage

select * from dbo.max_covid_percentage