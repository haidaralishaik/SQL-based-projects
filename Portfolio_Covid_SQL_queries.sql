/* checking if the table covidDeathData can be imported*/
select *
from [Covid-19_portfolio_project]..['covidDeathsData']
order by 2, 3,4;

/* checking if covidVaccinationsData can be imported*/
select *
from  [Covid-19_portfolio_project]..['covidVaccinationsData']
order by 3,4;

--selecting data from covidDeathsData table that will be used
==has null values in continent column
select continent,location,date, population,total_cases,new_cases,total_deaths,new_deaths 
from [Covid-19_portfolio_project]..['covidDeathsData']

order by 2,3

--looking at total cases vs total deaths and likelyhood of dying if infected with covid
   -- each day
select continent,location,date, population,total_cases,new_cases,total_deaths,new_deaths, nullif((cast(total_deaths as float)/nullif(cast(total_cases as float),0))*100,0)  as chance_death_if_infected
from [Covid-19_portfolio_project]..['covidDeathsData']

order by 2,3
   --as a whole
select continent,location, sum(cast(new_cases as int)) as total_cases, sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as float))/sum(cast(new_cases as float)))*100  as chance_death_if_infected
from [Covid-19_portfolio_project]..['covidDeathsData']
group by continent,location
order by chance_death_if_infected desc

--looking at total cases vs total population and total deaths vs popultaion
select continent, location,date, population, total_cases, total_deaths,(total_cases/population)*100 as percent_of_infected, 100*total_deaths/population as percent_death
from [Covid-19_portfolio_project]..['covidDeathsData']
order by 2,3
 
 -- countries with highest death cases due to covid19 (we see some anomalies in location names)
 select location,population,max(total_cases) as highest_covidCases_count,max(cast(total_deaths as int)) as totaldeaths, max(100*total_deaths/population) as death_percent
 from [Covid-19_portfolio_project]..['covidDeathsData']
 group by location, population
 order by 5 desc
 
 --breaking this into continents
 select location,max(total_cases) as totalcases,max(cast(total_deaths as int)) as total_deaths
 from [Covid-19_portfolio_project]..['covidDeathsData']
 where continent is not null
 group by location
 order by 3 desc

 --checking CvoideVacciationsData
 Select * from [Covid-19_portfolio_project]..['covidDeathsData'];

 --joining covidDeathsData and CovidVaccinationsData tables and checking total vaccinations for each CONTINENT
 select cdt.continent,cdt.location,cdt.date,cdt.total_cases,cdt.new_cases,cdt.total_deaths,cdt.new_deaths,cvt.total_vaccinations 
 from [Covid-19_portfolio_project]..['covidDeathsData'] as cdt
 join [Covid-19_portfolio_project]..['covidVaccinationsData'] as cvt
 on cdt.location=cvt.location and cdt.date=cvt.date
 where cdt.continent is null
 order by cdt.continent, cdt.location, cdt.date;
 
 
 -- looking at total vaccinations for each LOCATION
 select cdt.continent,cdt.location,cdt.date,cdt.total_cases,cdt.new_cases,cdt.total_deaths,cdt.new_deaths,cvt.new_vaccinations,cvt.total_vaccinations
 from [Covid-19_portfolio_project]..['covidDeathsData'] as cdt
 join [Covid-19_portfolio_project]..['covidVaccinationsData'] as cvt
 on cdt.location=cvt.location and cdt.date=cvt.date
 where cdt.continent is not null
 order by cdt.continent, cdt.location, cdt.date;

 --looking at the above table by creating a new cumulative column for total vaccinations from new_vaccinations column using over partition by clause
 select cdt.continent,cdt.location, cdt.date,cdt.population,cdt.total_cases,cdt.new_cases,cdt.total_deaths,cdt.new_deaths,cvt.new_vaccinations,cvt.total_vaccinations, 
 sum(cast(cvt.new_vaccinations as bigint)) over (partition by cdt.location order by cdt.location,cdt.date) as rollingTotalVaccinations--,rollingTotalVaccinations/cdt.population as percentVaccinated
 from [Covid-19_portfolio_project]..['covidDeathsData'] as cdt
 join [Covid-19_portfolio_project]..['covidVaccinationsData'] as cvt
 on cdt.location=cvt.location and cdt.date=cvt.date
 where cdt.continent is not null
 order by cdt.continent, cdt.location, cdt.date;

 --from the above query, we cannot use rollingTotalVaccinations columns for operations directly , it will give an error
 -- do as below (CTE or Temp tables)


 -- using CTE
 with rollingVaccinations(continent,location,date,population,total_cases,new_cases,total_deaths,new_deaths,new_vaccinations,total_vaccinations,rollingTotalVaccinations) as
 (
 select cdt.continent,cdt.location, cdt.date,cdt.population,cdt.total_cases,cdt.new_cases,cdt.total_deaths,cdt.new_deaths,cvt.new_vaccinations,cvt.total_vaccinations, 
 sum(cast(cvt.new_vaccinations as bigint)) over (partition by cdt.location order by cdt.location,cdt.date) as rollingTotalVaccinations--,rollingTotalVaccinations/cdt.population as percentVaccinated
 from [Covid-19_portfolio_project]..['covidDeathsData'] as cdt
 join [Covid-19_portfolio_project]..['covidVaccinationsData'] as cvt
 on cdt.location=cvt.location and cdt.date=cvt.date
 where cdt.continent is not null
 --order by cdt.continent, cdt.location, cdt.date; orderby doesnt work in views and CTEs
 )
 
 select * ,100*(cast(rollingTotalVaccinations as bigint)/population) as percentageVaccinated
 from rollingVaccinations;

 -- using Temp tables
 drop table if exists #rollingVaccinationsTable
 create table #rollingVaccinationsTable (
 continent nvarchar(250),
 location nvarchar(250),
 date datetime,
 population bigint,
 total_cases bigint,
 new_cases bigint,
 total_deaths bigint,
 new_deaths bigint,
 new_vaccinations bigint,
 total_vaccinations bigint,
 rollingTotalVaccinations bigint
 )
 insert into #rollingVaccinationsTable
 select cdt.continent,cdt.location, cdt.date,cdt.population,cdt.total_cases,cdt.new_cases,cdt.total_deaths,cdt.new_deaths,cvt.new_vaccinations,cvt.total_vaccinations, 
 sum(cast(cvt.new_vaccinations as bigint)) over (partition by cdt.location order by cdt.location,cdt.date) as rollingTotalVaccinations--,rollingTotalVaccinations/cdt.population as percentVaccinated
 from [Covid-19_portfolio_project]..['covidDeathsData'] as cdt
 join [Covid-19_portfolio_project]..['covidVaccinationsData'] as cvt
 on cdt.location=cvt.location and cdt.date=cvt.date
 where cdt.continent is not null;
 --order by cdt.continent, cdt.location, cdt.date;
 select *, 100*(convert(float,rollingTotalVaccinations))/population as percentageVaccinated
 from #rollingVaccinationsTable;

 -- creating views for later visualizations on visualisation tools
 --this view table is same as the one from CTE and Temp table
 drop view if exists percentvaccinated
 create view percentvaccinated as 
 select cdt.continent,cdt.location, cdt.date,cdt.population,cdt.total_cases,cdt.new_cases,cdt.total_deaths,cdt.new_deaths,cvt.new_vaccinations,cvt.total_vaccinations, 
 sum(cast(cvt.new_vaccinations as bigint)) over (partition by cdt.location order by cdt.location,cdt.date) as rollingTotalVaccinations--,rollingTotalVaccinations/cdt.population as percentVaccinated
 from [Covid-19_portfolio_project]..['covidDeathsData'] as cdt
 join [Covid-19_portfolio_project]..['covidVaccinationsData'] as cvt
 on cdt.location=cvt.location and cdt.date=cvt.date
 where cdt.continent is not null;
 --order by cdt.continent, cdt.location, cdt.date;

 select * from [dbo].[percentvaccinated]