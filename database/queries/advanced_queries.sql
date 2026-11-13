SELECT 
    p.project_id, 
    p.name AS project_name, 
    s.name AS software_name,
    p.status,
    tm.team_name,
    t.name AS task_name,
    t.status AS task_status
FROM projects AS p

INNER JOIN software AS s 
    ON p.software_id = s.software_id
INNER JOIN teams AS tm 
    ON tm.project_id=p.project_id
INNER JOIN tasks as t
    ON t.project_id=p.project_id
ORDER BY p.project_id, tm.team_name, t.name;

SELECT 
    p.project_id,
    p.name AS project_name,
    COUNT(DISTINCT tm.team_id) AS total_teams,
    COUNT(DISTINCT t.task_id) AS total_tasks

FROM projects AS p
LEFT JOIN teams AS tm
    ON tm.project_id =p.project_id
LEFT JOIN tasks AS t
    ON t.project_id=p.project_id
GROUP BY p.project_id, p.name
HAVING COUNT(DISTINCT t.task_id) > 0
ORDER BY p.project_id;




SELECT
    s.software_id,
    s.name AS software_name,
    p.name AS project_name
FROM projects AS p
RIGHT JOIN software AS s
    ON p.software_id = s.software_id
ORDER BY s.software_id;



-- T2.4: FULL OUTER JOIN - show all software and projects

SELECT
    s.software_id,
    s.name AS software_name,
    p.project_id,
    p.name AS project_name
FROM software AS s
FULL OUTER JOIN projects AS p
    ON s.software_id = p.software_id
ORDER BY s.software_id, p.project_id;



SELECT
    p.project_id,
    p.name AS project_name,
    COUNT(DISTINCT tm.team_id) AS total_teams,
    COUNT(DISTINCT t.task_id) AS total_tasks
FROM projects AS p
LEFT JOIN teams AS tm
    ON tm.project_id = p.project_id
LEFT JOIN tasks AS t
    ON t.project_id = p.project_id
GROUP BY p.project_id, p.name
HAVING COUNT(DISTINCT t.task_id) > 1
ORDER BY p.project_id;

-- T2: Software-wise project statistics
SELECT
    s.software_id,
    s.name AS software_name,
    COUNT(p.project_id) AS total_projects,
    MIN(p.start_date) AS first_project_date,
    MAX(p.end_date) AS latest_project_end
FROM software AS s
LEFT JOIN projects AS p
    ON p.software_id = s.software_id
GROUP BY s.software_id, s.name
ORDER BY total_projects DESC;


-- T2: Find projects with above-average subscription price
SELECT
    p.project_id,
    p.name AS project_name
FROM projects AS p
WHERE p.project_id IN (
    SELECT s.project_id
    FROM subscriptions AS s
    WHERE s.price > (
        SELECT AVG(price)
        FROM subscriptions
    )
);

-- T2: Find companies with more than one software
SELECT
    c.company_id,
    c.company_name
FROM companies AS c
WHERE c.company_id IN (
    SELECT s.company_id
    FROM software AS s
    GROUP BY s.company_id
    HAVING COUNT(s.software_id) > 1
);

-- T2: Companies with multiple software products
SELECT
    c.company_name,
    s.name AS software_name
FROM companies AS c
INNER JOIN software AS s
    ON s.company_id = c.company_id
WHERE c.company_id IN (
    SELECT company_id
    FROM software
    GROUP BY company_id
    HAVING COUNT(software_id) > 1
)
ORDER BY c.company_name, s.name;

-- T2: Find users who have at least one skill
SELECT
    u.user_id,
    u.full_name,
    u.user_email
FROM users AS u
WHERE EXISTS (
    SELECT 1
    FROM user_skills AS us
    WHERE us.user_id = u.user_id
);

-- T2: Find users who have no skills assigned
SELECT
    u.user_id,
    u.full_name,
    u.user_email
FROM users AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM user_skills AS us
    WHERE us.user_id = u.user_id
);

SELECT user_id, full_name
FROM users;
SELECT
    u.user_id,
    u.full_name,
    us.skill_id
FROM users AS u
LEFT JOIN user_skills AS us
    ON us.user_id = u.user_id
ORDER BY u.user_id;

-- T2: Projects with price greater than ANY subscription price
SELECT
    p.project_id,
    p.name AS project_name
FROM projects AS p
WHERE p.project_id IN (
    SELECT s.project_id
    FROM subscriptions AS s
    WHERE s.price > ANY (
        SELECT price
        FROM subscriptions
    )
);

-- T2: Projects with price greater than ALL subscription prices
SELECT
    p.project_id,
    p.name AS project_name
FROM projects AS p
WHERE p.project_id IN (
    SELECT s.project_id
    FROM subscriptions AS s
    WHERE s.price > ALL (
        SELECT price
        FROM subscriptions
    )
);

-- T2: Count software products per company using a subquery
SELECT
    company_id,
    total_software
FROM (
    SELECT
        company_id,
        COUNT(*) AS total_software
    FROM software
    GROUP BY company_id
) AS company_software_summary
ORDER BY total_software DESC;

-- T2: Companies having more than one software
SELECT
    c.company_id,
    c.company_name
FROM companies AS c
WHERE (
    SELECT COUNT(*)
    FROM software AS s
    WHERE s.company_id = c.company_id
) > 1
ORDER BY c.company_id;

-- T2: Classify companies by number of software products
SELECT
    c.company_id,
    c.company_name,
    (
        SELECT COUNT(*)
        FROM software AS s
        WHERE s.company_id = c.company_id
    ) AS total_software,
    CASE
        WHEN (
            SELECT COUNT(*)
            FROM software AS s
            WHERE s.company_id = c.company_id
        ) > 1 THEN 'Multiple Software'
        ELSE 'One or No Software'
    END AS software_category
FROM companies AS c
ORDER BY c.company_id;


-- T2: Rank projects within each software
SELECT
    s.name AS software_name,
    p.project_id,
    p.name AS project_name,
    ROW_NUMBER() OVER (
        PARTITION BY s.software_id
        ORDER BY p.project_id
    ) AS project_number
FROM software AS s
INNER JOIN projects AS p
    ON p.software_id = s.software_id;


-- T2: Rank projects by subscription price
SELECT
    p.project_id,
    p.name AS project_name,
    sub.price AS subscription_price,
    RANK() OVER (
        ORDER BY sub.price DESC
    ) AS price_rank
FROM projects AS p
INNER JOIN subscriptions AS sub
    ON sub.project_id = p.project_id;


-- T2: Rank projects by subscription price without skipping ranks
SELECT
    p.project_id,
    p.name AS project_name,
    sub.price AS subscription_price,
    DENSE_RANK() OVER (
        ORDER BY sub.price DESC
    ) AS price_rank
FROM projects AS p
INNER JOIN subscriptions AS sub
    ON sub.project_id = p.project_id;


-- T2: Compare subscription prices with previous project
SELECT
    p.project_id,
    p.name AS project_name,
    sub.price AS current_price,
    LAG(sub.price) OVER (
        ORDER BY p.project_id
    ) AS previous_price
FROM projects AS p
INNER JOIN subscriptions AS sub
    ON sub.project_id = p.project_id;

-- T2: Compare subscription prices with the next project
SELECT
    p.project_id,
    p.name AS project_name,
    sub.price AS current_price,
    LEAD(sub.price) OVER (
        ORDER BY p.project_id
    ) AS next_price
FROM projects AS p
INNER JOIN subscriptions AS sub
    ON sub.project_id = p.project_id;

-- T2: Company-wise subscription analytics
SELECT
    c.company_id,
    c.company_name,
    COUNT(DISTINCT sub.subscription_id) AS total_subscriptions,
    COALESCE(SUM(sub.price), 0) AS total_subscription_value,
    COALESCE(AVG(sub.price), 0) AS average_subscription_price
FROM companies AS c
LEFT JOIN software AS s
    ON s.company_id = c.company_id
LEFT JOIN projects AS p
    ON p.software_id = s.software_id
LEFT JOIN subscriptions AS sub
    ON sub.project_id = p.project_id
GROUP BY c.company_id, c.company_name
ORDER BY total_subscription_value DESC;


-- T2: Project-wise task status analytics
SELECT
    p.project_id,
    p.name AS project_name,
    COUNT(t.task_id) AS total_tasks,
    COUNT(t.task_id) FILTER (
        WHERE t.status = 'completed'
    ) AS completed_tasks,
    COUNT(t.task_id) FILTER (
        WHERE t.status = 'pending'
    ) AS pending_tasks
FROM projects AS p
LEFT JOIN tasks AS t
    ON t.project_id = p.project_id
GROUP BY p.project_id, p.name
ORDER BY p.project_id;

-- T2: Invoice and payment analytics
SELECT
    i.invoice_id,
    i.amount AS invoice_amount,
    i.status AS invoice_status,
    COALESCE(SUM(pay.amount), 0) AS total_paid,
    i.amount - COALESCE(SUM(pay.amount), 0) AS remaining_amount
FROM invoices AS i
LEFT JOIN payments AS pay
    ON pay.invoice_id = i.invoice_id
GROUP BY
    i.invoice_id,
    i.amount,
    i.status
ORDER BY i.invoice_id;

-- T2: Subscription plan performance
SELECT
    sp.plan_id,
    sp.sub_name AS plan_name,
    COUNT(s.subscription_id) AS total_subscriptions,
    COALESCE(SUM(s.price), 0) AS total_revenue,
    COALESCE(AVG(s.price), 0) AS average_price
FROM subscription_plans AS sp
LEFT JOIN subscriptions AS s
    ON s.plan_id = sp.plan_id
GROUP BY sp.plan_id, sp.sub_name
ORDER BY total_revenue DESC;

-- T2: Team member and task assignment analytics
SELECT
    tm.team_id,
    tm.team_name,
    COUNT(DISTINCT tmem.user_id) AS total_members,
    COUNT(DISTINCT ta.task_id) AS assigned_tasks
FROM teams AS tm
LEFT JOIN team_members AS tmem
    ON tmem.team_id = tm.team_id
LEFT JOIN tasks AS t
    ON t.project_id = tm.project_id
LEFT JOIN task_assignees AS ta
    ON ta.task_id = t.task_id
GROUP BY tm.team_id, tm.team_name
ORDER BY tm.team_id;

-- T2: Monthly payment revenue
SELECT
    DATE_TRUNC('month', paid_at)::DATE AS revenue_month,
    COUNT(payment_id) AS total_payments,
    SUM(amount) AS monthly_revenue
FROM payments
WHERE status = 'completed'
  AND paid_at IS NOT NULL
GROUP BY DATE_TRUNC('month', paid_at)
ORDER BY revenue_month;

-- T2: Project-wise subscription status analytics
SELECT
    p.project_id,
    p.name AS project_name,
    COUNT(s.subscription_id) AS total_subscriptions,
    COUNT(s.subscription_id) FILTER (
        WHERE s.status = 'active'
    ) AS active_subscriptions,
    COUNT(s.subscription_id) FILTER (
        WHERE s.status = 'expired'
    ) AS expired_subscriptions
FROM projects AS p
LEFT JOIN subscriptions AS s
    ON s.project_id = p.project_id
GROUP BY p.project_id, p.name
ORDER BY p.project_id;


-- T2: User-wise skill analytics
SELECT
    u.user_id,
    u.full_name,
    COUNT(us.skill_id) AS total_skills
FROM users AS u
LEFT JOIN user_skills AS us
    ON us.user_id = u.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_skills DESC, u.full_name;


-- T2: Find users and their skills
SELECT
    u.user_id,
    u.full_name,
    STRING_AGG(sk.name, ', ' ORDER BY sk.name) AS skills
FROM users AS u
INNER JOIN user_skills AS us
    ON us.user_id = u.user_id
INNER JOIN skills AS sk
    ON sk.skill_id = us.skill_id
GROUP BY u.user_id, u.full_name
ORDER BY u.full_name;

-- Find users who have a specific skill
SELECT
    u.user_id,
    u.full_name,
    sk.name AS skill_name
FROM users AS u
INNER JOIN user_skills AS us
    ON us.user_id = u.user_id
INNER JOIN skills AS sk
    ON sk.skill_id = us.skill_id
WHERE LOWER(sk.name) = LOWER('Python')
ORDER BY u.full_name;

-- Project-wise task completion report
SELECT
    p.project_id,
    p.name AS project_name,
    COUNT(t.task_id) AS total_tasks,
    COUNT(t.task_id) FILTER (
        WHERE LOWER(t.status) = 'completed'
    ) AS completed_tasks,
    ROUND(
        100.0 * COUNT(t.task_id) FILTER (
            WHERE LOWER(t.status) = 'completed'
        ) / NULLIF(COUNT(t.task_id), 0),
        2
    ) AS completion_percentage
FROM projects AS p
LEFT JOIN tasks AS t
    ON t.project_id = p.project_id
GROUP BY p.project_id, p.name
ORDER BY completion_percentage DESC NULLS LAST;

-- Find projects that have no tasks
SELECT
    p.project_id,
    p.name AS project_name,
    s.name AS software_name
FROM projects AS p
INNER JOIN software AS s
    ON s.software_id = p.software_id
WHERE NOT EXISTS (
    SELECT 1
    FROM tasks AS t
    WHERE t.project_id = p.project_id
)
ORDER BY p.project_id;

-- Find users who have no assigned tasks
SELECT
    u.user_id,
    u.full_name
FROM users AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM task_assignees AS ta
    WHERE ta.user_id = u.user_id
)
ORDER BY u.user_id;

-- Find users who are not members of any team
SELECT
    u.user_id,
    u.full_name
FROM users AS u
WHERE NOT EXISTS (
    SELECT 1
    FROM team_members AS tm
    WHERE tm.user_id = u.user_id
)
ORDER BY u.user_id;

-- Count skills for each user
SELECT
    u.user_id,
    u.full_name,
    COUNT(DISTINCT us.skill_id) AS total_skills,
    CASE
        WHEN COUNT(DISTINCT us.skill_id) = 0 THEN 'No Skills'
        WHEN COUNT(DISTINCT us.skill_id) <= 2 THEN 'Beginner'
        ELSE 'Multi-Skilled'
    END AS skill_category
FROM users AS u
LEFT JOIN user_skills AS us
    ON us.user_id = u.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_skills DESC, u.full_name;


-- Highest subscription price for each project
SELECT
    p.project_id,
    p.name AS project_name,
    MAX(s.price) AS highest_subscription_price,
    MIN(s.price) AS lowest_subscription_price,
    AVG(s.price)::NUMERIC(10,2) AS average_subscription_price
FROM projects AS p
LEFT JOIN subscriptions AS s
    ON s.project_id = p.project_id
GROUP BY p.project_id, p.name
ORDER BY highest_subscription_price DESC NULLS LAST;

-- Rank projects by total number of tasks
SELECT
    p.project_id,
    p.name AS project_name,
    COUNT(t.task_id) AS total_tasks,
    DENSE_RANK() OVER (
        ORDER BY COUNT(t.task_id) DESC
    ) AS task_rank
FROM projects AS p
LEFT JOIN tasks AS t
    ON t.project_id = p.project_id
GROUP BY p.project_id, p.name
ORDER BY task_rank, p.project_id;

-- Find the most expensive subscription project for each company
SELECT
    c.company_id,
    c.company_name,
    p.name AS project_name,
    sub.price AS subscription_price
FROM companies AS c
JOIN software AS s
    ON s.company_id = c.company_id
JOIN projects AS p
    ON p.software_id = s.software_id
JOIN subscriptions AS sub
    ON sub.project_id = p.project_id
WHERE sub.price = (
    SELECT MAX(sub2.price)
    FROM software AS s2
    JOIN projects AS p2
        ON p2.software_id = s2.software_id
    JOIN subscriptions AS sub2
        ON sub2.project_id = p2.project_id
    WHERE s2.company_id = c.company_id
)
ORDER BY c.company_id;

-- Payment summary by status
SELECT
    status,
    COUNT(payment_id) AS total_payments,
    COALESCE(SUM(amount), 0) AS total_amount,
    ROUND(AVG(amount), 2) AS average_payment
FROM payments
GROUP BY status
ORDER BY total_amount DESC;

-- Find overdue unpaid invoices
SELECT
    i.invoice_id,
    i.subscription_id,
    i.amount,
    i.due_date,
    i.status
FROM invoices AS i
WHERE i.due_date < CURRENT_DATE
  AND LOWER(i.status) NOT IN ('paid', 'completed')
ORDER BY i.due_date;

-- Company-wise employee and skill report
SELECT
    c.company_id,
    c.company_name,
    COUNT(DISTINCT cu.user_id) AS total_employees,
    COUNT(DISTINCT us.skill_id) AS unique_skills
FROM companies AS c
LEFT JOIN company_users AS cu
    ON cu.company_id = c.company_id
LEFT JOIN user_skills AS us
    ON us.user_id = cu.user_id
GROUP BY c.company_id, c.company_name
ORDER BY total_employees DESC;

-- User activity report
SELECT
    u.user_id,
    u.full_name,
    COUNT(al.log_id) AS total_activities,
    MAX(al.log_created_at) AS last_activity
FROM users AS u
LEFT JOIN activity_logs AS al
    ON al.user_id = u.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_activities DESC, u.full_name;


-- Revenue report by software
SELECT
    s.software_id,
    s.name AS software_name,
    COUNT(DISTINCT sub.subscription_id) AS total_subscriptions,
    COALESCE(SUM(sub.price), 0) AS total_revenue,
    COALESCE(MAX(sub.price), 0) AS highest_price
FROM software AS s
LEFT JOIN projects AS p
    ON p.software_id = s.software_id
LEFT JOIN subscriptions AS sub
    ON sub.project_id = p.project_id
GROUP BY s.software_id, s.name
ORDER BY total_revenue DESC;

-- Find users assigned to multiple tasks
SELECT
    u.user_id,
    u.full_name,
    COUNT(DISTINCT ta.task_id) AS total_assigned_tasks
FROM users AS u
INNER JOIN task_assignees AS ta
    ON ta.user_id = u.user_id
GROUP BY u.user_id, u.full_name
HAVING COUNT(DISTINCT ta.task_id) > 1
ORDER BY total_assigned_tasks DESC;

-- Find companies that have no software
SELECT
    c.company_id,
    c.company_name
FROM companies AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM software AS s
    WHERE s.company_id = c.company_id
)
ORDER BY c.company_id;

-- Project-wise task status summary
SELECT
    p.project_id,
    p.name AS project_name,
    COUNT(t.task_id) AS total_tasks,
    COUNT(t.task_id) FILTER (
        WHERE LOWER(t.status) = 'completed'
    ) AS completed_tasks,
    COUNT(t.task_id) FILTER (
        WHERE LOWER(t.status) = 'pending'
    ) AS pending_tasks,
    COUNT(t.task_id) FILTER (
        WHERE LOWER(t.status) = 'in_progress'
    ) AS in_progress_tasks
FROM projects AS p
LEFT JOIN tasks AS t
    ON t.project_id = p.project_id
GROUP BY p.project_id, p.name
ORDER BY p.project_id;


-- Subscription expiry and renewal report
SELECT
    s.subscription_id,
    p.name AS project_name,
    s.start_date,
    s.end_date,
    s.status,
    CASE
        WHEN s.end_date < CURRENT_DATE THEN 'Expired'
        WHEN s.end_date <= CURRENT_DATE + 30 THEN 'Expiring Soon'
        ELSE 'Active Period'
    END AS renewal_category
FROM subscriptions AS s
JOIN projects AS p
    ON p.project_id = s.project_id
ORDER BY s.end_date;

-- Latest payment for each invoice
SELECT
    invoice_id,
    payment_id,
    amount,
    status,
    paid_at
FROM (
    SELECT
        p.*,
        ROW_NUMBER() OVER (
            PARTITION BY p.invoice_id
            ORDER BY p.paid_at DESC NULLS LAST,
                     p.payment_id DESC
        ) AS payment_rank
    FROM payments AS p
) AS ranked_payments
WHERE payment_rank = 1
ORDER BY invoice_id;


-- Project-wise task status percentages
SELECT
    p.project_id,
    p.name AS project_name,
    COUNT(t.task_id) AS total_tasks,
    ROUND(
        100.0 * COUNT(t.task_id)
            FILTER (WHERE LOWER(t.status) = 'completed')
        / NULLIF(COUNT(t.task_id), 0),
        2
    ) AS completed_percentage,
    ROUND(
        100.0 * COUNT(t.task_id)
            FILTER (WHERE LOWER(t.status) = 'pending')
        / NULLIF(COUNT(t.task_id), 0),
        2
    ) AS pending_percentage
FROM projects AS p
LEFT JOIN tasks AS t
    ON t.project_id = p.project_id
GROUP BY p.project_id, p.name
ORDER BY p.project_id;

-- Top 3 users by assigned task count
SELECT
    u.user_id,
    u.full_name,
    COUNT(DISTINCT ta.task_id) AS total_tasks,
    DENSE_RANK() OVER (
        ORDER BY COUNT(DISTINCT ta.task_id) DESC
    ) AS task_rank
FROM users AS u
LEFT JOIN task_assignees AS ta
    ON ta.user_id = u.user_id
GROUP BY u.user_id, u.full_name
ORDER BY task_rank, u.user_id
LIMIT 3;

-- Combine project and task records into one report
SELECT
    'Project' AS record_type,
    project_id AS record_id,
    name AS record_name
FROM projects

UNION ALL

SELECT
    'Task' AS record_type,
    task_id AS record_id,
    name AS record_name
FROM tasks

ORDER BY record_type, record_id;

-- Compare each subscription with the previous one
SELECT
    subscription_id,
    project_id,
    price,
    LAG(price) OVER (
        ORDER BY subscription_id
    ) AS previous_price,
    price - LAG(price) OVER (
        ORDER BY subscription_id
    ) AS price_difference
FROM subscriptions
ORDER BY subscription_id;

-- Invoice payment status summary
SELECT
    COUNT(*) AS total_invoices,
    COUNT(*) FILTER (
        WHERE LOWER(status) = 'paid'
    ) AS paid_invoices,
    COUNT(*) FILTER (
        WHERE LOWER(status) <> 'paid'
    ) AS unpaid_or_other_invoices,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE LOWER(status) = 'paid'
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS paid_percentage
FROM invoices;

-- Find users who share the same skills
SELECT
    sk.name AS skill_name,
    u1.full_name AS user_one,
    u2.full_name AS user_two
FROM user_skills AS us1
JOIN user_skills AS us2
    ON us1.skill_id = us2.skill_id
   AND us1.user_id < us2.user_id
JOIN users AS u1
    ON u1.user_id = us1.user_id
JOIN users AS u2
    ON u2.user_id = us2.user_id
JOIN skills AS sk
    ON sk.skill_id = us1.skill_id
ORDER BY sk.name, user_one, user_two;

EXPLAIN ANALYZE
SELECT
    t.task_id,
    t.name,
    t.status
FROM tasks AS t
WHERE t.project_id = 7;