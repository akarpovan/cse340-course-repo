-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);

-- ========================================
-- Insert sample data: Organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');

-- 
-- ========================================
-- Insert 3 additional organizations
-- ========================================
-- INSERT INTO organization (name, description, contact_email, logo_filename)
-- VALUES
-- ('TechForGood Initiative', 'A technology nonprofit that builds free software solutions for other charitable organizations and teaches coding skills to underserved communities.', 'contact@techforgood.org', 'techforgood-logo.png'),
-- ('HealthyFoods Alliance', 'A food justice organization working to eliminate food deserts and provide nutritious meals to low-income families across the state.', 'info@healthyfoodsalliance.org', 'healthyfoods-logo.png'),
-- ('Animal Welfare League', 'A rescue and rehabilitation organization dedicated to finding loving homes for abandoned pets and promoting responsible pet ownership.', 'adopt@animalwelfare.org', 'animalwelfare-logo.png');
-- 
-- ========================================
SELECT organization_id, name, description, contact_email, logo_filename
	FROM public.organization;

-- ========================================
 UPDATE organization
    SET name = $1, description = $2, contact_email = $3, logo_filename = $4
    WHERE organization_id = $5
    RETURNING organization_id;
	
-- ========================================
-- Project Table
-- ========================================
CREATE TABLE project (
    project_id      SERIAL PRIMARY KEY,
    organization_id INT NOT NULL REFERENCES organization(organization_id),
    title           VARCHAR(255) NOT NULL,
    description     TEXT,
    location        VARCHAR(255),
    date            DATE NOT NULL
);

-- ========================================
-- Insert sample data: Projects
-- ========================================
INSERT INTO project (organization_id, title, description, location, date) VALUES
-- BrightFuture Builders (org 1)
(1, 'School Supply Drive',    'Collect supplies for local schools.',        'Salt Lake City, UT', '2025-09-05'),
(1, 'Reading Mentorship',     'Mentor elementary students in reading.',      'Provo, UT',          '2025-09-12'),
(1, 'After-School Tutoring',  'Tutoring program for middle schoolers.',      'Ogden, UT',          '2025-09-19'),
(1, 'Scholarship Fundraiser', 'Raise funds for student scholarships.',       'Orem, UT',           '2025-09-26'),
(1, 'STEM Workshop',          'Hands-on STEM activities for kids.',          'Logan, UT',          '2025-10-03'),
-- GreenHarvest Growers (org 2)
(2, 'Park Cleanup',           'Clean up and beautify local parks.',          'Salt Lake City, UT', '2025-09-06'),
(2, 'Community Garden',       'Plant and maintain a community garden.',      'Provo, UT',          '2025-09-13'),
(2, 'River Restoration',      'Remove invasive plants along the river.',     'Moab, UT',           '2025-09-20'),
(2, 'Recycling Awareness',    'Educate neighborhoods about recycling.',      'Ogden, UT',          '2025-09-27'),
(2, 'Tree Planting Day',      'Plant 100 trees in the city.',                'Orem, UT',           '2025-10-04'),
-- UnityServe Volunteers (org 3)
(3, 'Food Drive',             'Collect food for local food banks.',          'Salt Lake City, UT', '2025-09-07'),
(3, 'Homeless Shelter Help',  'Serve meals at the homeless shelter.',        'Provo, UT',          '2025-09-14'),
(3, 'Senior Visits',          'Visit and assist elderly community members.', 'Ogden, UT',          '2025-09-21'),
(3, 'Clothing Donation',      'Collect and distribute clothing donations.',  'Logan, UT',          '2025-09-28'),
(3, 'Community Health Fair',  'Free health screenings for the community.',   'Orem, UT',           '2025-10-05');

-- =============================
-- Then insert the 5 projects
-- INSERT INTO project (organization_id, title, description, location, date) VALUES
-- ((SELECT LAST_INSERT_ID()), 'Pet Adoption Drive', 'Weekly adoption event featuring dogs, cats, and small animals looking for forever homes.', 'Los Angeles, CA', '2025-09-07'),
-- ((SELECT LAST_INSERT_ID()), 'Spay & Neuter Clinic', 'Low-cost spay and neuter services to help control the pet population.', 'San Diego, CA', '2025-09-14'),
-- ((SELECT LAST_INSERT_ID()), 'Pet Food Bank', 'Distributing free pet food to low-income families to keep pets healthy at home.', 'Long Beach, CA', '2025-09-21'),
-- ((SELECT LAST_INSERT_ID()), 'Foster Care Training', 'Training session for volunteers interested in fostering animals until adoption.', 'Irvine, CA', '2025-09-28'),
-- ((SELECT LAST_INSERT_ID()), 'Animal Rescue Fundraiser', 'Gala event to raise funds for emergency medical care and rescue operations.', 'Anaheim, CA', '2025-10-05');
-- ========================================
SELECT 
    p.project_id,
    p.title,
    p.location,
    p.date,
    o.name AS organization_name
FROM project p
JOIN organization o ON p.organization_id = o.organization_id
ORDER BY o.name, p.date;
-- ========
SELECT
	p.project_id,
	p.title,
	p.description,
	p.date,
	p.location,
	p.organization_id,
	o.name AS organization_name
FROM project p
JOIN organization o ON p.organization_id = o.organization_id
WHERE p.date >= '2025-05-20'
ORDER BY p.date ASC
LIMIT 10;
-- ========================================
UPDATE project
	SET organization_id = $1, title = $2, description = $3, location = $4, date = $5
	WHERE project_id = $6
	RETURNING project_id;

-- ========================================
-- Category Table
-- ========================================
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(150) NOT NULL UNIQUE
);

-- ========================================
-- Insert sample data: Categories
-- ========================================
INSERT INTO category (name) VALUES
('Environmental'),
('Educational'),
('Community Service'),
('Health and Wellness');

-- ========================================
-- Project-Category Junction Table
-- (connects projects to categories)
-- ========================================
CREATE TABLE project_category (
    project_id  INT NOT NULL REFERENCES project(project_id),
    category_id INT NOT NULL REFERENCES category(category_id),
    PRIMARY KEY (project_id, category_id)
);

-- ========================================
-- Associate projects with categories
-- ========================================
INSERT INTO project_category (project_id, category_id) VALUES
-- BrightFuture Builders projects (Educational)
(1, 2),  -- School Supply Drive       → Educational
(2, 2),  -- Reading Mentorship        → Educational
(3, 2),  -- After-School Tutoring     → Educational
(4, 2),  -- Scholarship Fundraiser    → Educational
(5, 2),  -- STEM Workshop             → Educational
-- GreenHarvest Growers projects (Environmental)
(6, 1),  -- Park Cleanup              → Environmental
(7, 1),  -- Community Garden          → Environmental
(8, 1),  -- River Restoration         → Environmental
(9, 1),  -- Recycling Awareness       → Environmental
(10, 1), -- Tree Planting Day         → Environmental
-- UnityServe Volunteers projects (Community Service)
(11, 3), -- Food Drive                → Community Service
(12, 3), -- Homeless Shelter Help     → Community Service
(13, 4), -- Senior Visits             → Health and Wellness
(14, 3), -- Clothing Donation         → Community Service
(15, 4); -- Community Health Fair     → Health and Wellness

-- ========================================
-- Verify categories
-- ========================================
SELECT * FROM category;

SELECT category_id, name
FROM public.category
ORDER BY name;

-- Verify project-category associations
SELECT 
    p.title AS project,
    c.name  AS category
FROM project_category pc
JOIN project  p ON pc.project_id  = p.project_id
JOIN category c ON pc.category_id = c.category_id
ORDER BY c.name, p.title;

-- ============================================
-- INSERT INTO category (name) VALUES
-- ('Arts and Culture'),
-- ('Disaster Relief'),
-- ('Youth Development'),
-- ('Senior Support'),
-- ('Housing and Shelter');


-- ======================
SELECT user_id, name, email, password_hash, role_id, created_at
	FROM public.users;

-- ===
-- Roles table defines available roles
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    role_description TEXT
);

INSERT INTO roles (role_name, role_description) VALUES 
    ('user', 'Standard user with basic access'),
    ('admin', 'Administrator with full system access');

-- Verify the data was inserted
SELECT * FROM roles;

-- View all users and roles
SELECT * FROM users;
SELECT * FROM roles;

-- Update the dedicated admin testing account to have admin role
UPDATE users SET role_id = (SELECT role_id FROM roles WHERE role_name = 'admin') WHERE email = 'admin@example.com';

-- Verify the update by listing all users and their roles
SELECT users.user_id, users.email, roles.role_name FROM users JOIN roles ON users.role_id = roles.role_id;

-- Users table references roles
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert a test user
-- INSERT INTO users (name, email, password_hash, role_id) 
-- VALUES ('testuser', 'test@example.com', 'placeholder_hash', 1);

-- admin, admin@example.com, cse340!

-- Join users and roles to see complete information
SELECT u.user_id, u.name, u.email, r.role_name, r.role_description
FROM users u
JOIN roles r ON u.role_id = r.role_id;

-- Delete the test user
-- DELETE FROM users WHERE email = 'test@example.com';

	