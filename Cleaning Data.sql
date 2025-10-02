-- Data Cleaning
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Remove Null or Blank values
-- 4. Remove any unnecessary columns

SELECT * FROM layoffs;

-- make table layoffs_cleaned that copy from the original one

Create Table layoffs_cleaned
LIKE layoffs;

insert layoffs_cleaned
select *
from layoffs;

select *
from layoffs_cleaned
where location="Odo";


-- 1. remove dublicates

select * ,
ROW_NUMBER() OVER( 
PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) 
 as row_num
from layoffs_cleaned;

-- use CTEs


WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, date
           ) AS row_num
    FROM layoffs_cleaned
)
SELECT *
FROM duplicate_cte
WHERE row_num >1; -- to see the duplicates

-- let's delete them

Create table layoffs_cleaned_v2
LIKE layoffs_cleaned;

INSERT INTO layoffs_cleaned_v2
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`
           ) AS row_num
    FROM layoffs_cleaned
)
SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
FROM duplicate_cte
WHERE row_num = 1;

SELECT *
from layoffs_cleaned_v2;


-- 2. Standrdize Data

select company, TRIM(company)
from layoffs_cleaned_v2;


update layoffs_cleaned_v2
set company=TRIM(company);


select DISTINCT(industry)
from layoffs_cleaned_v2
order by 1;

update layoffs_cleaned_v2
set industry='Crypto'
where industry in ('Crypto Currency','CryptoCurrency');

select DISTINCT(location)
from layoffs_cleaned_v2
order by 1;

update layoffs_cleaned_v2
set location='Düsseldorf'
where location='DÃ¼sseldorf';

update layoffs_cleaned_v2
set location='Florianópolis'
where location='FlorianÃ³polis';

update layoffs_cleaned_v2
set location='Malmö'
where location='MalmÃ¶';


select DISTINCT(country)
from layoffs_cleaned_v2
order by 1;

update layoffs_cleaned_v2
set country=TRIM(TRAILING '.'from country) ;-- removes any . at the end of the country

-- upadate date column from text to date format()

update layoffs_cleaned_v2
set `date` = STR_TO_DATE(`date`,'%m/%d/%Y') ;


select `date`
from layoffs_cleaned_v2;

-- the date column changed it is format but it is datatype is still text not date so we also have to do this==>

ALTER table layoffs_cleaned_v2
MODIFY column `date` DATE;




-- 3. remove or impute null and blank values



select * 
from layoffs_cleaned_v2;

-- 1. check industry
select *
from layoffs_cleaned_v2
where industry is NULL or 
industry ='';
-- change all blanks to null
update layoffs_cleaned_v2
set industry = NULL
where industry = '';

select *
from layoffs_cleaned_v2
where company='juul'; -- here i notice that airbnb company whose location in SF Bay Area has industry travel and industry blank so we will impute the blank industry with Travel

select * 
from layoffs_cleaned_v2 as t1
join layoffs_cleaned_v2 as t2
on t1.company=t2.company
where (t1.industry is null  or t1.industry = '')
and t2.industry is not null ;

update layoffs_cleaned_v2 as t1
join layoffs_cleaned_v2 as t2
on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is not null;


select *
from layoffs_cleaned_v2
where industry is NULL;





-- 2. check company

select *
from layoffs_cleaned_v2
where company is NULL or 
company =''; -- clean

-- 3. check loaction

select *
from layoffs_cleaned_v2
where location is NULL or 
location =''; -- clean

-- 3. check date

select *
from layoffs_cleaned_v2
where `date` is NULL;



select *
from layoffs_cleaned_v2
where company='Blackbaud';
-- i can't impute it bec i don't have any similary companies so i will delete this row

delete from layoffs_cleaned_v2
where `date` is null;


-- 4. check total_laid_off and percentage_laid_off

select *
from layoffs_cleaned_v2
where total_laid_off is NULL and percentage_laid_off is null;

-- as we don't have a column name total company liad off so we will not be able to impute those nulls so i will delete them

delete from layoffs_cleaned_v2
where total_laid_off is NULL and percentage_laid_off is null;

-- 5. check country
select *
from layoffs_cleaned_v2
where country is NULL ; -- clean


-- 4. Remove any unnecessary columns
	-- there is no unnecessary column in this data

