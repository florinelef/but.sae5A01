\i createTables.sql

INSERT INTO categories(name_category, duration, capacity) VALUES 
    ('Vélo elliptique (1h)', 60, 4),
    ('Fitness (2h)', 120, 15),
    ('Yoga (30min)', 30, 10),
    ('Musculation (1h30)', 90, 5),
    ('Cardio (1h)', 60, 3);

INSERT INTO users (login, password, ownership) VALUES 
    ('jeremy', MD5('mot de passe'), TRUE),
    ('jean_paul', MD5('coucou'), FALSE),
    ('florine', MD5('florine'), FALSE),
    ('charlie', MD5('charlie'), FALSE),
    ('toto', MD5('toto'), FALSE);

INSERT INTO slots (day_start, day_end, time_start, time_end, id_category) VALUES
    ('2025-10-12', '2025-10-12', '09:00', '10:00', 1),
    ('2025-10-15', '2025-10-15', '15:00', '15:30', 3),
    ('2025-10-15', '2025-10-15', '09:00', '10:00', 1),
    ('2025-10-15', '2025-10-15', '10:00', '10:30', 3),
    ('2025-10-15', '2025-10-15', '10:00', '10:30', 3),
    ('2025-10-15', '2025-10-15', '14:30', '16:00', 4),
    ('2025-10-16', '2025-10-16', '14:30', '15:30', 5),
    ('2025-10-01', '2025-10-01', '10:00', '11:30', 4),
    ('2025-11-03', '2025-11-03', '15:00', '17:00', 2)
    ;

INSERT INTO bookings (login, id_slot) VALUES 
    ('jean_paul', 1),
    ('florine', 2),
    ('charlie', 3),
    ('toto', 1),
    ('florine', 1),
    ('charlie', 1)
    ;