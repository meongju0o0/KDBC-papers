-- Run this file against an already selected database.
-- Database/user creation is handled by database/init_db.sh using environment variables.

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS papers;
DROP TABLE IF EXISTS paper_issues;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL DEFAULT 'user',
  approved TINYINT(1) NOT NULL DEFAULT 0
);

CREATE TABLE paper_issues (
  id INT AUTO_INCREMENT PRIMARY KEY,
  vol INT NOT NULL,
  no INT NOT NULL,
  publish_year INT NOT NULL,
  publish_month INT NOT NULL,
  UNIQUE KEY uq_paper_issues_vol_no (vol, no)
);

CREATE TABLE papers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  vol INT NOT NULL,
  no INT NOT NULL,
  authors VARCHAR(255) NOT NULL,
  affiliation VARCHAR(255) NOT NULL,
  abstracted_text TEXT,
  pdf_url VARCHAR(500)
);
