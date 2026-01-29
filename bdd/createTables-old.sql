DROP TABLE IF EXISTS abstract_slots, bookings, slots, week_schemes, users, categories CASCADE;

CREATE TABLE categories (
    id_category SERIAL,
    name_category VARCHAR(50),
    duration INT, -- temps indiqué en minutes
    capacity INT,
    CONSTRAINT pk_category PRIMARY KEY (id_category)
);

CREATE TABLE users (
    login VARCHAR(50),
    password VARCHAR(50),
    ownership boolean,
    CONSTRAINT pk_user PRIMARY KEY (login)
);

CREATE TABLE slots (
    id_slot SERIAL,
    day_start DATE,
    day_end DATE,
    time_start TIME,
    time_end TIME,
    id_category INT,
    CONSTRAINT pk_slot PRIMARY KEY (id_slot),
    CONSTRAINT fk_category FOREIGN KEY (id_category) REFERENCES categories(id_category) ON DELETE CASCADE
);

CREATE TABLE bookings (
    login VARCHAR(50),
    id_slot INT,
    CONSTRAINT pk_booking PRIMARY KEY (login, id_slot),
    CONSTRAINT fk_user FOREIGN KEY (login) REFERENCES users(login) ON DELETE CASCADE
);