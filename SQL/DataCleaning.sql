-- Date cleaning

SELECT * 
FROM layoffs;

-- 1.remove duplicates
-- 2.standardize the data
-- 3.null values and blank values
-- 4.remove any columns

# to copying data from layoffs to layoffs_staging table
# i have to do that so if i have any problem i can retrieve data
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

SELECT * 
FROM layoffs_staging;

# first step (remove duplicates)
# 1- row number over partition by all columns
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

# 2- put it in cte
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
	PARTITION BY company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions) AS row_num
FROM layoffs_staging
)

# 3- select where row_number more than 1
SELECT *
FROM duplicate_cte
WHERE row_num >1;

# create table like the previous but adding to it row_num column in this table i will delete rows that row_num > 1
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
	PARTITION BY company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    `date`,
    stage,
    country,
    funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1 ;

SELECT *
FROM layoffs_staging2;

# second step (standardize the data)
# removing white space
SELECT company,TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

# unification
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

# remove . from the end
SELECT DISTINCT country ,TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

# make the date column of type date rather than text
# first modify the style 
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

# then modify the column type to make it date
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date`  DATE;

# third step (null values and blank values)
# change blank to null
UPDATE layoffs_staging2
SET industry= null
WHERE industry='';


SELECT t1.industry,t2.industry
FROM layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

# remove rows that total_laid_off and percentage_laid_off is null because they are not useful
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# fourth step (remove any columns)
# drop row_num column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

