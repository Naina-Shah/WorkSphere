INSERT INTO companies
(company_name, company_email, company_phone, company_address)
VALUES
('TechVision', 'contact@techvision.com', '03001234567', 'Islamabad'),
('CodeCraft', 'info@codecraft.com', '03007654321', 'Lahore');

INSERT INTO users
(full_name, user_email, user_password, active_user)
VALUES
('Ali Ahmed', 'ali@techvision.com', 'seed_hash_1', TRUE),
('Sara Khan', 'sara@techvision.com', 'seed_hash_2', TRUE),
('Usman Malik', 'usman@codecraft.com', 'seed_hash_3', TRUE);

INSERT INTO skills (name, description)
VALUES
('Python', 'Python backend development'),
('FastAPI', 'Building REST APIs'),
('PostgreSQL', 'Relational database management'),
('Frontend Development', 'HTML, CSS, JavaScript and Bootstrap'),
('Graphic Design', 'UI graphics and visual design');

INSERT INTO company_users (company_id, user_id, role, status)
VALUES
(1, 1, 'owner', 'active'),
(1, 2, 'member', 'active'),
(2, 3, 'owner', 'active');

INSERT INTO user_profiles (user_id, job_title, bio)
VALUES
(1, 'Python Backend Developer', 'Works with Python and FastAPI'),
(2, 'Frontend Developer', 'Works with frontend technologies'),
(3, 'Full Stack Developer', 'Works on web applications');

INSERT INTO user_skills (user_id, skill_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 1),
(3, 2),
(3, 3);

INSERT INTO software (company_id, name, description)
VALUES
(1, 'WorkSphere ERP', 'Enterprise resource planning software'),
(1, 'WorkSphere CRM', 'Customer relationship management software'),
(2, 'CodeCraft HR', 'Human resource management software');

INSERT INTO projects
(software_id, name, description, status, start_date, end_date)
VALUES
(4, 'ERP Development', 'Develop core ERP modules', 'active', '2026-11-01', '2027-03-31'),
(5, 'CRM Dashboard', 'Build customer management dashboard', 'planned', '2026-11-10', '2027-02-28'),
(6, 'HR Portal', 'Develop employee management portal', 'active', '2026-11-05', '2027-04-30');


INSERT INTO teams (project_id, team_name, team_description)
VALUES
(1, 'Backend Team', 'Develops ERP backend APIs'),
(2, 'Frontend Team', 'Builds the CRM dashboard'),
(3, 'Full Stack Team', 'Develops the HR portal');


INSERT INTO team_members (team_id, user_id)
VALUES
(1, 1),
(1, 2),
(2, 2),
(3, 3);

INSERT INTO tasks
(project_id, name, description, status, due_date)
VALUES
(1, 'Create Authentication API', 'Implement user login and authentication', 'in_progress', '2026-12-01'),
(1, 'Build Database Models', 'Create SQLAlchemy models', 'pending', '2026-12-10'),
(2, 'Design CRM Dashboard', 'Build dashboard interface', 'pending', '2026-12-15'),
(3, 'Develop Employee API', 'Create employee management endpoints', 'in_progress', '2026-12-20');

INSERT INTO task_assignees (task_id, user_id)
VALUES
(1, 1),
(2, 1),
(2, 3),
(3, 2),
(4, 3);

INSERT INTO subscription_plans
(sub_name, sub_description, sub_price, sub_billing_cycle)
VALUES
('Basic', 'Basic project management features', 2000.00, 'monthly'),
('Professional', 'Advanced team and project management', 5000.00, 'monthly'),
('Enterprise', 'Complete business management features', 50000.00, 'yearly');

INSERT INTO subscriptions
(project_id, plan_id, start_date, end_date, price, status)
VALUES
(1, 2, '2026-11-01', '2026-11-30', 5000.00, 'active'),
(2, 1, '2026-11-10', '2026-12-09', 2000.00, 'active'),
(3, 3, '2026-11-05', '2027-11-04', 50000.00, 'active');

INSERT INTO invoices
(subscription_id, amount, issue_date, due_date, status)
VALUES
(1, 5000.00, '2026-11-01', '2026-11-15', 'paid'),
(2, 2000.00, '2026-11-10', '2026-11-24', 'pending'),
(3, 50000.00, '2026-11-05', '2026-11-20', 'pending');

INSERT INTO payments
(invoice_id, amount, payment_method, status, paid_at)
VALUES
(1, 5000.00, 'bank_transfer', 'completed', NOW()),
(2, 1000.00, 'card', 'completed', NOW());

INSERT INTO activity_logs (user_id, log_action, log_details)
VALUES
(1, 'project_created', 'Created ERP Development project'),
(2, 'task_assigned', 'Assigned CRM dashboard task'),
(3, 'subscription_created', 'Created HR Portal subscription');