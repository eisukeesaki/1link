-- DATABASE
CREATE DATABASE "1link";
\c 1link

-- EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- FUNCTIONS
CREATE OR REPLACE FUNCTION update_modified_column() 
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.modified = now();
        RETURN NEW; 
    END;
    $$ language 'plpgsql';

-- USERS
CREATE TABLE users (
    id
        UUID
        PRIMARY KEY
        DEFAULT gen_random_uuid()
        NOT NULL,
	username
        VARCHAR(50)
        NOT NULL,
	given_name
        VARCHAR(50)
        NOT NULL,
	family_name
        VARCHAR(50)
        NOT NULL,
    email
        VARCHAR(50)
        NOT NULL
        UNIQUE,
    created
        TIMESTAMP
        NOT NULL
        DEFAULT (CURRENT_TIMESTAMP), 
    modified
        TIMESTAMP
);
CREATE TRIGGER update_users_modtime
    BEFORE UPDATE
    ON users
    FOR EACH ROW
        EXECUTE PROCEDURE update_modified_column();

-- LINKS
CREATE TABLE links (
    id
        UUID
        PRIMARY KEY
        DEFAULT gen_random_uuid()
        NOT NULL,
    user_id
        UUID
        REFERENCES users
        NOT NULL,
    title
        VARCHAR(250)
        NOT NULL,
    uri
        VARCHAR(500)
        NOT NULL,
    created
        TIMESTAMP
        NOT NULL
        DEFAULT (CURRENT_TIMESTAMP), 
    modified
        TIMESTAMP
);
CREATE TRIGGER update_links_modtime
    BEFORE UPDATE
    ON links
    FOR EACH ROW
        EXECUTE PROCEDURE update_modified_column();

