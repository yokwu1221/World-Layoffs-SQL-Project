# Data Cleaning

SELECT *
FROM layoffs;

# 1. Remove Duplicates
# 2. Standardize the Data
# 3. Null Values or blank values
# 4. Remove Any Columns

-- Creating a duplicate table to work on to keep the raw data safe
CREATE TABLE layoff_staging
LIKE layoffs;

SELECT *
FROM layoff_staging;

INSERT INTO layoff_staging
SELECT *
FROM layoffs;

##########################################################################################################################################################
### 1. Remove Duplicates
SELECT *
FROM layoff_staging;

-- Identifying duplicates using ROW_NUMBER() and CTE
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoff_staging
WHERE company = 'Casper';

-- Creating a second staging table to store data with row_num for deletion
CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoff_staging2
WHERE row_num > 1;

INSERT INTO layoff_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoff_staging;

-- Deleting identified duplicates
DELETE
FROM layoff_staging2
WHERE row_num > 1;

SELECT *
FROM layoff_staging2;

##########################################################################################################################################################
### 2. Standardize the Data
SELECT company, TRIM(company)
FROM layoff_staging2;

-- Trimming company names
UPDATE layoff_staging2
SET company = TRIM(company);

SELECT DISTINCT(industry)
FROM layoff_staging2;

-- Standardizing industry names (Fixing 'Crypto' variations)
UPDATE layoff_staging2
SET industry = 'Crpto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT(country), TRIM(TRAILING '.' FROM country) 
FROM layoff_staging2
WHERE country LIKE 'United States%';

-- Standardizing country names (Removing trailing periods)
UPDATE layoff_staging2
SET country = 'United States'
WHERE country LIKE 'United States%';

SELECT DISTINCT(country)
FROM layoff_staging2
WHERE country LIKE 'United States%';

-- Converting 'date' column from text to DATE format
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoff_staging2;

UPDATE layoff_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoff_staging2;

ALTER TABLE layoff_staging2
MODIFY COLUMN `date` DATE;

##########################################################################################################################################################
### 3. Null Values or blank values
-- Populating missing industry values based on other entries for the same company
SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoff_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoff_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
	AND (t2.industry IS NOT NULL AND t2.industry != '');
    
UPDATE layoff_staging2 t1
JOIN layoff_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
	AND (t2.industry IS NOT NULL AND t2.industry != '');

##########################################################################################################################################################
### 4. Remove Any Columns
-- Dropping the row_num column used during the cleaning process
SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoff_staging2;

ALTER TABLE layoff_staging2
DROP COLUMN row_num;
