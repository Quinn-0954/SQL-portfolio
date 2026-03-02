-- ============================================
-- FISHING TRACKER DATABASE (SQL SERVER)
-- ============================================

-- 1?? Create Database
IF DB_ID('fishing_tracker') IS NOT NULL
    DROP DATABASE fishing_tracker;
GO

CREATE DATABASE fishing_tracker;
GO

USE fishing_tracker;
GO

-- ============================================
-- 2?? TABLES
-- ============================================

-- Countries Table
CREATE TABLE countries (
    country_id INT IDENTITY(1,1) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    iso_code CHAR(3) UNIQUE
);

-- Species Table
CREATE TABLE species (
    species_id INT IDENTITY(1,1) PRIMARY KEY,
    species_name VARCHAR(100) NOT NULL
);

-- Years Table
CREATE TABLE years (
    year_id INT IDENTITY(1,1) PRIMARY KEY,
    year_value INT NOT NULL UNIQUE
);

-- Fish Catches Table
CREATE TABLE fish_catches (
    catch_id INT IDENTITY(1,1) PRIMARY KEY,
    country_id INT NOT NULL,
    species_id INT NOT NULL,
    year_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    unit VARCHAR(20) DEFAULT 'tons',

    CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES countries(country_id),
    CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species(species_id),
    CONSTRAINT fk_year FOREIGN KEY (year_id) REFERENCES years(year_id),

    CONSTRAINT unique_record UNIQUE(country_id, species_id, year_id)
);

-- ============================================
-- 3?? INSERT SAMPLE DATA
-- ============================================

-- Countries
INSERT INTO countries (country_name, iso_code)
VALUES 
('Brazil', 'BRA'),
('Japan', 'JPN'),
('Norway', 'NOR'),
('United States', 'USA');

-- Species
INSERT INTO species (species_name)
VALUES
('Tuna'),
('Salmon'),
('Cod'),
('Sardine');

-- Years
INSERT INTO years (year_value)
VALUES
(2022),
(2023),
(2024);

-- Fish Catch Records
INSERT INTO fish_catches (country_id, species_id, year_id, amount)
VALUES
(1, 1, 1, 150000.50),
(2, 2, 1, 300000.00),
(3, 3, 1, 250000.75),
(1, 4, 2, 120000.00),
(4, 1, 2, 200000.00),
(2, 3, 3, 275000.25);

-- ============================================
-- 4?? TEST QUERY
-- ============================================

SELECT 
    c.country_name,
    y.year_value,
    SUM(f.amount) AS total_catch_tons
FROM fish_catches f
JOIN countries c ON f.country_id = c.country_id
JOIN years y ON f.year_id = y.year_id
GROUP BY c.country_name, y.year_value
ORDER BY y.year_value, total_catch_tons DESC;