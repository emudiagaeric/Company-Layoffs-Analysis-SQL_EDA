-- -- EMUDIAGA RUKEVWE ERICSON -- --

-- Exploratory Data Analysis of yearly company layoffs

-- Overview of dataset
SELECT 
    *
FROM
    layoffs;

-- Describptive statistics of total layoff
SELECT 
    SUM(total_laid_off) Total_Laid_Off, 
    round(AVG(total_laid_off)) Avg_Laid_Off,
    MAX(total_laid_off) Highest_Laid_Off,
    MIN(total_laid_off) Lowest_Laid_Off
FROM
    layoffs;
    
-- Describptive statistics of fund raised
SELECT 
    SUM(funds_raised_millions) Total_funding,
    round(AVG(funds_raised_millions)) Avg_funding,
    MAX(funds_raised_millions) Highest_funding,
    MIN(funds_raised_millions) Lowest_funding
FROM
    layoffs;


-- Layoffs by Year
SELECT DISTINCT
    YEAR(`date`) AS Lay_off_Year,
    SUM(total_laid_off) AS Total_Lay_off
FROM
    layoffs
    where YEAR(`date`) is not null
GROUP BY Lay_off_Year
ORDER BY Total_Lay_off DESC;

-- Layoffs by Month
SELECT DISTINCT
    Month(`date`) AS Lay_off_Year,
    SUM(total_laid_off) AS Total_Lay_off
FROM
    layoffs
    where month(`date`) is not null
GROUP BY Lay_off_Year
ORDER BY Total_Lay_off DESC;

-- Cummulative layoff over time 
with month_sum as
(SELECT 
    YEAR(`date`) Years,
        SUM(total_laid_off) total_layoffs
   FROM
    layoffs
WHERE
    YEAR(`date`) IS NOT NULL
GROUP BY Years
ORDER BY Years)
select Years, sum(total_layoffs) over(order by Years) as Moving_Total_Layoffs 
from month_sum 
;

-- Top 10 Companies with with layoff above 50% but less than 100% layoff
SELECT DISTINCT
    company, percentage_laid_off
FROM
    layoffs
WHERE
    percentage_laid_off > 0.5 and percentage_laid_off < 1
ORDER BY percentage_laid_off desc
LIMIT 10;

-- Top 10 industries with with layoff above 50% but less than 100% layoff
SELECT DISTINCT
    industry, percentage_laid_off
FROM
    layoffs
WHERE
    percentage_laid_off > 0.5 and percentage_laid_off < 1
ORDER BY percentage_laid_off desc
LIMIT 10;

-- Top 10 locations with with layoff above 50% but less than 100% layoff
SELECT DISTINCT (location), country, percentage_laid_off
FROM
    layoffs
WHERE
    percentage_laid_off > 0.5 and percentage_laid_off < 1
ORDER BY percentage_laid_off desc
LIMIT 10;

-- Top 10 worst hit lay off by companies
SELECT DISTINCT
    company, SUM(total_laid_off) AS Total_Lay_off, SUM(funds_raised_millions) Total_Funding_millions
FROM
    layoffs
GROUP BY company
ORDER BY Total_Lay_off DESC
limit 10;

-- Top 10 worst hit lay off by locations
SELECT DISTINCT
    location, SUM(total_laid_off) AS Total_Lay_off, SUM(funds_raised_millions) Total_Funding_millions
FROM
    layoffs
GROUP BY location
ORDER BY Total_Lay_off DESC
limit 10;


-- Top 10 worst hit lay off by industry
SELECT DISTINCT
    industry, SUM(total_laid_off) AS Total_Lay_off, SUM(funds_raised_millions) Total_Funding_millions
FROM
    layoffs
GROUP BY industry
ORDER BY Total_Lay_off DESC
limit 10;

-- Top 10 industries laid off by total funding
SELECT DISTINCT
    industry, SUM(funds_raised_millions) Total_Funding_millions
FROM
    layoffs
GROUP BY industry
ORDER BY Total_Funding_millions DESC
limit 10;


-- Top layoffs by Company, year and month 
With company_year as 
(SELECT 
    company,
    YEAR(`date`) AS dob,
    MONTH(`date`) AS monthb,
    sum(total_laid_off) as total_laid    
FROM
    layoffs
    GROUP BY company, dob, monthb), company_year_ranking as
    (
select *, dense_rank() over(partition by dob order by total_laid desc) as ranking from company_year)
select*from company_year_ranking where ranking <=5 
and dob is not null ORDER BY ranking;

-- Top layoffs by industries, year and month 

with industry_year as
(
SELECT 
    industry, year(`date`) years, month(`date`) months, SUM(total_laid_off) Total_Laid_Off
FROM
    layoffs
GROUP BY industry, years, months
ORDER BY Total_laid_off DESC),
industry_rank as
(select *, rank() over (partition by years order by Total_Laid_Off desc) as ranks
 from industry_year
)
select * from industry_rank
where years is not null and ranks <=5;

-- Top layoffs by countries and year 
with country_year as
(
SELECT 
    country, year(`date`) years, SUM(total_laid_off) Total_Laid_Off
FROM
    layoffs
GROUP BY country, years
ORDER BY Total_laid_off DESC),
country_rank as
(select *, rank() over (partition by years order by Total_Laid_Off desc) as ranks
 from country_year
)
select * from country_rank
where years is not null and ranks <=5;

