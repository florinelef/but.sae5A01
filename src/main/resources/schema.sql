DROP TABLE IF EXISTS users, slots, bookings, documents CASCADE; 

CREATE TABLE users (
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    login VARCHAR(50),
    email VARCHAR(100),
    password VARCHAR(100),
    img_path VARCHAR(250),
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_user PRIMARY KEY (login)
);

CREATE TABLE authorities(
    login VARCHAR(50) NOT NULL,
    authority VARCHAR(50) NOT NULL,
    CONSTRAINT pk_authority PRIMARY KEY (login, authority),
    FOREIGN KEY (login) REFERENCES users (login)
);

CREATE TABLE slots (
    id_slot SERIAL,
    day_start DATE,
    day_end DATE,
    time_start TIME,
    time_end TIME,
    CONSTRAINT pk_slot PRIMARY KEY (id_slot)
);

CREATE TABLE bookings (
    login VARCHAR(50),
    id_slot INT,
    CONSTRAINT pk_booking PRIMARY KEY (login, id_slot),
    CONSTRAINT fk_user FOREIGN KEY (login) REFERENCES users(login) ON DELETE CASCADE
);

CREATE TABLE documents (
    id_doc SERIAL,
    doc_path VARCHAR(250),
    id_slot INT,
    login VARCHAR(50),
    CONSTRAINT pk_document PRIMARY KEY (id_doc),
    CONSTRAINT fk_booking FOREIGN KEY (login, id_slot) REFERENCES bookings(login, id_slot) ON DELETE CASCADE
);