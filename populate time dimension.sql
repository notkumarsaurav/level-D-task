-- 1. Drop table and procedure if they already exist
IF OBJECT_ID('dbo.TimeDimension', 'U') IS NOT NULL DROP TABLE dbo.TimeDimension;
IF OBJECT_ID('dbo.PopulateTimeDimension', 'P') IS NOT NULL DROP PROCEDURE dbo.PopulateTimeDimension;
GO

-- 2. Create the TimeDimension table
CREATE TABLE dbo.TimeDimension (
    [Date] DATE PRIMARY KEY,
    KeyDate DATE,
    CalendarDay INT,
    CalendarMonth INT,
    CalendarMonthName NVARCHAR(20),
    CalendarQuarter INT,
    CalendarYear INT,
    DayName NVARCHAR(20),
    DayNameShort NVARCHAR(10),
    DayNumberOfWeek INT,
    DayNumberOfYear INT,
    DaySuffix NVARCHAR(5),
    WeekOfYear INT,
    IsWeekend BIT,
    FiscalDay INT,
    FiscalMonth INT,
    FiscalMonthName NVARCHAR(20),
    FiscalQuarter INT,
    FiscalYear INT,
    FiscalYearPeriod NVARCHAR(10)
);
GO

-- 3. Create the stored procedure
CREATE PROCEDURE dbo.PopulateTimeDimension
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(@InputDate), 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(YEAR(@InputDate), 12, 31);
    DECLARE @FiscalStartMonth INT = 4;  -- April

    ;WITH DateList AS (
        SELECT @StartDate AS DateValue
        UNION ALL
        SELECT DATEADD(DAY, 1, DateValue)
        FROM DateList
        WHERE DateValue < @EndDate
    )
    INSERT INTO dbo.TimeDimension (
        [Date], KeyDate, CalendarDay, CalendarMonth, CalendarMonthName, CalendarQuarter, CalendarYear,
        DayName, DayNameShort, DayNumberOfWeek, DayNumberOfYear, DaySuffix,
        WeekOfYear, IsWeekend,
        FiscalDay, FiscalMonth, FiscalMonthName, FiscalQuarter, FiscalYear, FiscalYearPeriod
    )
    SELECT
        d.DateValue,
        d.DateValue,
        DAY(d.DateValue),
        MONTH(d.DateValue),
        DATENAME(MONTH, d.DateValue),
        DATEPART(QUARTER, d.DateValue),
        YEAR(d.DateValue),
        DATENAME(WEEKDAY, d.DateValue),
        LEFT(DATENAME(WEEKDAY, d.DateValue), 3),
        DATEPART(WEEKDAY, d.DateValue),
        DATEPART(DAYOFYEAR, d.DateValue),
        CAST(DAY(d.DateValue) AS VARCHAR) + 
            CASE 
                WHEN DAY(d.DateValue) IN (11,12,13) THEN 'th'
                WHEN RIGHT(CAST(DAY(d.DateValue) AS VARCHAR),1) = '1' THEN 'st'
                WHEN RIGHT(CAST(DAY(d.DateValue) AS VARCHAR),1) = '2' THEN 'nd'
                WHEN RIGHT(CAST(DAY(d.DateValue) AS VARCHAR),1) = '3' THEN 'rd'
                ELSE 'th'
            END,
        DATEPART(WEEK, d.DateValue),
        CASE WHEN DATEPART(WEEKDAY, d.DateValue) IN (1,7) THEN 1 ELSE 0 END,

        -- Fiscal calculations
        DAY(d.DateValue),
        CASE
            WHEN MONTH(d.DateValue) >= @FiscalStartMonth THEN MONTH(d.DateValue) - (@FiscalStartMonth - 1)
            ELSE MONTH(d.DateValue) + (12 - @FiscalStartMonth + 1)
        END,
        DATENAME(MONTH, d.DateValue),
        CASE
            WHEN MONTH(d.DateValue) >= @FiscalStartMonth THEN ((MONTH(d.DateValue) - @FiscalStartMonth) / 3) + 1
            ELSE ((MONTH(d.DateValue) + (12 - @FiscalStartMonth)) / 3) + 1
        END,
        CASE
            WHEN MONTH(d.DateValue) >= @FiscalStartMonth THEN YEAR(d.DateValue)
            ELSE YEAR(d.DateValue) - 1
        END,
        CAST(
            CASE
                WHEN MONTH(d.DateValue) >= @FiscalStartMonth THEN YEAR(d.DateValue)
                ELSE YEAR(d.DateValue) - 1
            END AS VARCHAR(4)
        ) +
        RIGHT('0' + CAST(
            CASE
                WHEN MONTH(d.DateValue) >= @FiscalStartMonth THEN MONTH(d.DateValue) - (@FiscalStartMonth - 1)
                ELSE MONTH(d.DateValue) + (12 - @FiscalStartMonth + 1)
            END AS VARCHAR(2)), 2)

    FROM DateList d
    OPTION (MAXRECURSION 366);
END;
GO

-- 4. Execute the procedure with any date in the year you want to populate
EXEC dbo.PopulateTimeDimension '2020-07-14';
GO

-- 5. View results
SELECT TOP 10 * FROM dbo.TimeDimension ORDER BY [Date];
