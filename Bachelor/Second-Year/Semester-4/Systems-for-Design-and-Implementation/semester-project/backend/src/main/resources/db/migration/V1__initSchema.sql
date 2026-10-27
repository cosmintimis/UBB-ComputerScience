CREATE TABLE IF NOT EXISTS "users" (
    "id" SERIAL Primary Key,
    "username" text NOT NULL,
    "email" text NOT NULL,
    "avatar" text NOT NULL,
    "password" text NOT NULL,
    "birthdate" DATE NOT NULL,
    "rating" real NOT NULL,
    "address" text NOT NULL
);
