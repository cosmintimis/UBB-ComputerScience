CREATE TABLE IF NOT EXISTS "roles" (
  "id" BIGSERIAL Primary Key,
  "name" text NOT NULL
);

CREATE TABLE IF NOT EXISTS "user_roles" (
   "user_id" integer REFERENCES users(id),
   "role_id" bigint REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);

INSERT INTO roles(name) VALUES('ROLE_USER');
INSERT INTO roles(name) VALUES('ROLE_ADMIN');

ALTER TABLE users
    ADD UNIQUE (email);

ALTER TABLE users
    ADD UNIQUE (username);
