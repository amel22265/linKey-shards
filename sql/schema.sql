-- ============================================================
-- CYBERSECURITY LEARNING PLATFORM — PostgreSQL Schema
-- ============================================================


-- ------------------------------------------------------------
-- 1. USERS (auth + profile)
-- ------------------------------------------------------------
CREATE TABLE users (
    id            SERIAL PRIMARY KEY,
    username      VARCHAR(50)  UNIQUE NOT NULL,
    email         VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,          -- store bcrypt hash, NEVER plain text
    full_name     VARCHAR(100),
    created_at    TIMESTAMP DEFAULT NOW(),
    updated_at    TIMESTAMP DEFAULT NOW()
);


-- ------------------------------------------------------------
-- 2. ROADMAPS
-- One roadmap = one learning path (e.g. "Cybersecurity Path")
-- ------------------------------------------------------------
CREATE TABLE roadmaps (
    id          SERIAL PRIMARY KEY,
    title       VARCHAR(100) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT NOW()
);


-- ------------------------------------------------------------
-- 3. COURSES (belong to a roadmap, ordered)
-- ------------------------------------------------------------
CREATE TABLE courses (
    id          SERIAL PRIMARY KEY,
    roadmap_id  INT REFERENCES roadmaps(id) ON DELETE CASCADE,
    title       VARCHAR(100) NOT NULL,
    description TEXT,
    order_index INT NOT NULL,                    -- controls position in the roadmap
    created_at  TIMESTAMP DEFAULT NOW()
);


-- ------------------------------------------------------------
-- 4. MODULES (belong to a course, ordered)
-- ------------------------------------------------------------
CREATE TABLE modules (
    id           SERIAL PRIMARY KEY,
    course_id    INT REFERENCES courses(id) ON DELETE CASCADE,
    title        VARCHAR(100) NOT NULL,
    description  TEXT,
    content_type VARCHAR(20) CHECK (
                     content_type IN ('text', 'video', 'interactive', 'lab')
                 ),
    content_url  TEXT,                           -- link to video or interactive resource
    order_index  INT NOT NULL,
    created_at   TIMESTAMP DEFAULT NOW()
);


-- ------------------------------------------------------------
-- 5. SOFT SKILLS (catalog)
-- e.g. "Critical Thinking", "Research Methodology"
-- ------------------------------------------------------------
CREATE TABLE soft_skills (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description TEXT
);
 

-- ------------------------------------------------------------
-- 6. MODULE ↔ SOFT SKILL (which skill is hidden in which module)
-- ------------------------------------------------------------
CREATE TABLE module_soft_skills (
    id            SERIAL PRIMARY KEY,
    module_id     INT REFERENCES modules(id)     ON DELETE CASCADE,
    soft_skill_id INT REFERENCES soft_skills(id) ON DELETE CASCADE,
    UNIQUE (module_id, soft_skill_id)
);


-- ------------------------------------------------------------
-- 7. TOOLS (catalog)
-- e.g. Wireshark, Nmap, Metasploit
-- ------------------------------------------------------------
CREATE TABLE tools (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    category    VARCHAR(50)                      -- e.g. 'network', 'exploitation', 'analysis'
);


-- ------------------------------------------------------------
-- 8. MODULE ↔ TOOL (which tools are used in which modules)
-- ------------------------------------------------------------
CREATE TABLE module_tools (
    id        SERIAL PRIMARY KEY,
    module_id INT REFERENCES modules(id) ON DELETE CASCADE,
    tool_id   INT REFERENCES tools(id)   ON DELETE CASCADE,
    UNIQUE (module_id, tool_id)
);


-- ------------------------------------------------------------
-- 9. QUIZZES (one per module, optional)
-- ------------------------------------------------------------
CREATE TABLE quizzes (
    id           SERIAL PRIMARY KEY,
    module_id    INT REFERENCES modules(id) ON DELETE CASCADE,
    title        VARCHAR(100) NOT NULL,
    passing_score INT DEFAULT 70               -- minimum % to pass
);


-- ------------------------------------------------------------
-- 10. QUIZ QUESTIONS
-- ------------------------------------------------------------
CREATE TABLE quiz_questions (
    id            SERIAL PRIMARY KEY,
    quiz_id       INT REFERENCES quizzes(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    order_index   INT NOT NULL
);


-- ------------------------------------------------------------
-- 11. QUIZ ANSWERS (multiple choice options)
-- ------------------------------------------------------------
CREATE TABLE quiz_answers (
    id            SERIAL PRIMARY KEY,
    question_id   INT REFERENCES quiz_questions(id) ON DELETE CASCADE,
    answer_text   TEXT    NOT NULL,
    is_correct    BOOLEAN DEFAULT FALSE
);


-- ------------------------------------------------------------
-- 12. USER PROGRESS (module completions + quiz scores)
-- One row per user per module — marked when module is completed
-- ------------------------------------------------------------
CREATE TABLE user_progress (
    id           SERIAL PRIMARY KEY,
    user_id      INT REFERENCES users(id)   ON DELETE CASCADE,
    module_id    INT REFERENCES modules(id) ON DELETE CASCADE,
    completed_at TIMESTAMP DEFAULT NOW(),
    quiz_score   INT,                          -- NULL if no quiz or not yet taken
    UNIQUE (user_id, module_id)
);


-- ------------------------------------------------------------
-- 13. USER SOFT SKILLS (earned when a module is completed)
-- ------------------------------------------------------------
CREATE TABLE user_soft_skills (
    id            SERIAL PRIMARY KEY,
    user_id       INT REFERENCES users(id)       ON DELETE CASCADE,
    soft_skill_id INT REFERENCES soft_skills(id) ON DELETE CASCADE,
    earned_at     TIMESTAMP DEFAULT NOW(),
    UNIQUE (user_id, soft_skill_id)
);

cv (id, user_id,personal_informations,intro,certificates, labs / projects ,skills, tools , soft skills  )

-- ============================================================
-- CV IS DERIVED, NOT STORED
-- When generating a CV, query:
--   • user_progress + modules + courses      → completed courses & modules
--   • user_soft_skills + soft_skills         → earned soft skills
--   • user_progress + module_tools + tools   → tools encountered
-- No separate cv_entries table needed for the prototype.
-- ============================================================
