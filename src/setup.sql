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

-- ========================================
SELECT organization_id, name, description, contact_email, logo_filename
	FROM public.organization;

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
	