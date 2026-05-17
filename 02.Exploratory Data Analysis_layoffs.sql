### Exploratory Data Analysis

SELECT *
FROM layoff_staging2;

-- Finding the maximum values to understand the scale of layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoff_staging2;

-- Identifying companies that laid off 100% of their workforce (Sorted by funds raised)
SELECT *
FROM layoff_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Total layoffs per company
SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

-- The interval of the dataset
SELECT MIN(`DATE`), MAX(`DATE`)
FROM layoff_staging2;

-- Total layoffs per industry
SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoff_staging2;

-- Yearly layoffs trend
SELECT YEAR(`DATE`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY YEAR(`DATE`)
ORDER BY 1 DESC;

-- Monthly layoffs trend (Using Substring for Year-Month grouping)
SELECT SUBSTRING(`DATE`, 1, 7) AS `month`, SUM(total_laid_off)
FROM layoff_staging2
WHERE SUBSTRING(`DATE`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`DATE`, 1, 7)
ORDER BY 1 ASC;

-- Calculating the Rolling Total of layoffs by month
WITH rolling_total AS
(
SELECT SUBSTRING(`DATE`, 1, 7) AS `month`, SUM(total_laid_off) AS num_off
FROM layoff_staging2
WHERE SUBSTRING(`DATE`, 1, 7) IS NOT NULL
GROUP BY SUBSTRING(`DATE`, 1, 7)
ORDER BY 1 ASC
)
SELECT `month`, num_off,
	SUM(num_off) OVER(ORDER BY `month`) AS rolling_total
FROM rolling_total;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Ranking top 5 companies with most layoffs per year
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(
SELECT *,
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5
;
