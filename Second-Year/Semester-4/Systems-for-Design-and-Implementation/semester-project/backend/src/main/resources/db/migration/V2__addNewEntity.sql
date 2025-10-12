CREATE TABLE IF NOT EXISTS "products" (
    "id" BIGSERIAL Primary Key,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "price" real NOT NULL,
    "user_id" integer,
    CONSTRAINT fk_user
        FOREIGN KEY(user_id)
            REFERENCES users(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
