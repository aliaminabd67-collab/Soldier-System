-- 1. Create ranks table
CREATE TABLE ranks (
    rank_id INT PRIMARY KEY,
    rank_name VARCHAR(50) NOT NULL UNIQUE,
    rank_level INT NOT NULL CHECK (rank_level BETWEEN 1 AND 6)
);


-- 2. Create units table
CREATE TABLE units (
    unit_id INT PRIMARY KEY,
    unit_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);


-- 3. Create missions table
CREATE TABLE missions (
    mission_id INT PRIMARY KEY,
    mission_name VARCHAR(100) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CONSTRAINT chk_mission_dates CHECK (end_date IS NULL OR end_date >= start_date)
);


CREATE TABLE soldiers (
    soldier_id SERIAL PRIMARY KEY,
    service_number VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    enlistment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'On Leave', 'Retired')),
    rank_id INT NOT NULL,
    unit_id INT NOT NULL,
    CONSTRAINT chk_enlistment_birth CHECK (enlistment_date > date_of_birth),
    CONSTRAINT fk_soldiers_rank FOREIGN KEY (rank_id) REFERENCES ranks(rank_id),
    CONSTRAINT fk_soldiers_unit FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);



-- 5. Create soldier_missions table
CREATE TABLE soldier_missions (
    soldier_id INT NOT NULL,
    mission_id INT NOT NULL,
    mission_role VARCHAR(100) NOT NULL,
    PRIMARY KEY (soldier_id, mission_id),
    CONSTRAINT fk_sm_soldier FOREIGN KEY (soldier_id) REFERENCES soldiers(soldier_id),
    CONSTRAINT fk_sm_mission FOREIGN KEY (mission_id) REFERENCES missions(mission_id)
);




-- B1: Insert ranks data
INSERT INTO ranks (rank_id, rank_name, rank_level) VALUES
(1, 'Private', 1),
(2, 'Corporal', 2),
(3, 'Sergeant', 3),
(4, 'Lieutenant', 4),
(5, 'Captain', 5),
(6, 'Major', 6);


-- B1: Insert units data
INSERT INTO units (unit_id, unit_name, location) VALUES
(1, 'Alpha Company', 'North Camp'),
(2, 'Bravo Company', 'South Camp'),
(3, 'Charlie Company', 'East Camp'),
(4, 'Delta Company', 'West Camp'),
(5, 'Signals Unit', 'Central Camp'),
(6, 'Medical Unit', 'Central Camp');


-- B3: Insert 3 additional soldiers (IDs 31, 32, 33)
INSERT INTO soldiers (soldier_id, service_number, first_name, last_name, date_of_birth, enlistment_date, status, rank_id, unit_id) VALUES
(31, 'ST-2401237', 'YourFirstName', 'YourLastName', '2001-05-15', '2022-01-10', 'Active', 1, 2),
(32, 'ST-2401237-2', 'Alex', 'Smith', '1999-08-20', '2021-06-01', 'Active', 2, 2),
(33, 'ST-2401237-3', 'Jordan', 'Lee', '2000-11-30', '2023-03-15', 'Active', 2, 3);



INSERT INTO missions (mission_id, mission_name, start_date, end_date) VALUES
(1, 'Exercise Falcon', '2025-02-03', '2025-02-28'),
(2, 'Flood Relief', '2025-04-14', '2025-05-30'),
(3, 'Border Patrol', '2025-07-01', NULL),
(4, 'Peace Support', '2025-09-15', NULL),
(5, 'Field Medical Camp', '2026-01-12', '2026-01-23');


INSERT INTO soldier_missions (soldier_id, mission_id, mission_role) VALUES
(31, 3, 'Lead Scout'),
(32, 3, 'Radio Operator');




INSERT INTO soldiers (soldier_id, service_number, first_name, last_name, date_of_birth, enlistment_date, status, rank_id, unit_id) VALUES
(31, 'ST-2401237', 'YourFirstName', 'YourLastName', '2001-05-15', '2022-01-10', 'Active', 1, 2),
(32, 'ST-2401237-2', 'Alex', 'Smith', '1999-08-20', '2021-06-01', 'Active', 2, 2)
ON CONFLICT (soldier_id) DO NOTHING;


INSERT INTO soldier_missions (soldier_id, mission_id, mission_role) VALUES
(31, 3, 'Lead Scout'),
(32, 3, 'Radio Operator')
ON CONFLICT (soldier_id, mission_id) DO NOTHING;


-- C1: The last 10 soldiers added, newest first
SELECT * 
FROM soldiers 
ORDER BY soldier_id DESC 
LIMIT 10;



SELECT * 
FROM (
    SELECT * 
    FROM soldiers 
    ORDER BY soldier_id DESC 
    LIMIT 10
) AS recent_soldiers
ORDER BY soldier_id ASC;



SELECT * 
FROM soldiers 
WHERE soldier_id IN (10, 15, 20);



SELECT * 
FROM soldiers 
WHERE soldier_id IN (10 + 7, 15 + 7, 20 + 7);



SELECT * 
FROM soldiers 
WHERE status = 'Active' 
  AND soldier_id BETWEEN 10 AND 20;



SELECT 
    s.soldier_id,
    CONCAT(s.first_name, ' ', s.last_name) AS soldier_name,
    r.rank_name,
    r.rank_level
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
ORDER BY r.rank_level DESC, s.last_name ASC;



SELECT 
    s.first_name,
    s.last_name,
    r.rank_name,
    u.unit_name,
    u.location
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
JOIN units u ON s.unit_id = u.unit_id
WHERE s.status = 'Active' 
  AND s.unit_id = 2; 


  
SELECT 
    m.mission_name,
    CONCAT(s.first_name, ' ', s.last_name) AS soldier_name,
    sm.mission_role,
    u.unit_name
FROM soldier_missions sm
JOIN soldiers s ON sm.soldier_id = s.soldier_id
JOIN missions m ON sm.mission_id = m.mission_id
JOIN units u ON s.unit_id = u.unit_id
WHERE sm.mission_id = 3; 



SELECT 
    s.soldier_id,
    s.first_name,
    s.last_name
FROM soldiers s
LEFT JOIN soldier_missions sm ON s.soldier_id = sm.soldier_id
WHERE sm.soldier_id IS NULL;



SELECT 
    u.unit_name,
    COUNT(s.soldier_id) AS total_soldiers
FROM units u
LEFT JOIN soldiers s ON u.unit_id = s.unit_id
GROUP BY u.unit_id, u.unit_name
ORDER BY total_soldiers DESC;



EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Mugisha';

CREATE INDEX idx_soldiers_last_name ON soldiers(last_name);

EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Mugisha';


CREATE VIEW v_soldier_profile AS
SELECT 
    s.soldier_id,
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    r.rank_name,
    u.unit_name,
    u.location,
    s.status
FROM soldiers s
JOIN ranks r ON s.rank_id = r.rank_id
JOIN units u ON s.unit_id = u.unit_id;


SELECT * 
FROM v_soldier_profile
WHERE unit_name = (SELECT unit_name FROM units WHERE unit_id = 2) 
ORDER BY full_name ASC;


ALTER TABLE soldiers 
ADD COLUMN email VARCHAR(100) UNIQUE;