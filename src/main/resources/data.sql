-- Users
INSERT INTO users (lastname, firstname, login, password, enabled, email, img_path) VALUES ('dupont', 'jeremy', 'jeremy', '$2a$10$qiBIuWTsp6OtFvLYNAjjYOfPrP.2m5B6onoPB6nzCU/QlAHjIapnO', TRUE, 'florine.lefebvre.etu@univ-lille.fr', '/uploads/jeremy.jpeg'); -- mot de passe
INSERT INTO users (lastname, firstname, login, password, enabled, email, img_path) VALUES ('steven', 'jean paul', 'jean_paul', '$2a$10$4TztfTSVk01dJY1lymPYt.67wdehG28tFTu3qAtk08sb4ynWkfK.2', TRUE, 'florine.lefebvre.etu@univ-lille.fr', '/uploads/jeanpaul.jpeg'); -- coucou
INSERT INTO users (lastname, firstname, login, password, enabled, email, img_path) VALUES ('lefebvre', 'florine', 'florine', '$2a$10$WrESrXyKWmFzRlKd1yfkO.L.SslbsBZFtQhBeBGfgQHAJkuevGajq', TRUE, 'florine.lefebvre.etu@univ-lille.fr', '/uploads/florine.jpeg'); -- florine
INSERT INTO users (lastname, firstname, login, password, enabled, email, img_path) VALUES ('darques', 'charlie', 'charlie', '$2a$10$1gJvUwrvczoHD/LT.yFsUOVXMxXyejN09TbKaJwEP38SSU2rIiuSy', TRUE, 'charlie.darques.etu@univ-lille.fr', '/uploads/charlie.jpeg'); -- charlie
INSERT INTO users (lastname, firstname, login, password, enabled, email, img_path) VALUES ('tutu', 'titi', 'toto', '$2a$10$livGTnmVJMGgUqWEc3td/eLsycSE246sJA.6jC0eoy058rCaJDO0q', TRUE, 'florine.lefebvre.etu@univ-lille.fr', '/uploads/titi.jpeg'); -- toto

-- Authorities
INSERT INTO authorities (login, authority) VALUES ('jeremy', 'ADMIN');
INSERT INTO authorities (login, authority) VALUES ('jean_paul', 'USER');
INSERT INTO authorities (login, authority) VALUES ('florine', 'USER');
INSERT INTO authorities (login, authority) VALUES ('charlie', 'USER');
INSERT INTO authorities (login, authority) VALUES ('toto', 'USER');


-- Slots
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-27', '16:00', '17:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-28', '09:00', '10:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-28', '14:00', '15:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-28', '15:00', '16:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-28', '16:00', '17:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-29', '10:00', '11:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-29', '11:00', '12:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-30', '10:00', '11:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-01-31', '09:00', '10:00');

-- pour tester les évènements passés
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-10-03', '15:00', '16:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-11-01', '10:00', '11:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-11-03', '15:00', '16:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-11-16', '14:00', '15:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-12-01', '10:00', '11:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-12-01', '11:00', '12:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-12-01', '15:00', '16:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-12-03', '15:00', '16:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-12-16', '14:00', '15:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-12-16', '13:00', '14:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2025-12-18', '14:00', '15:00');

-- Bookings
INSERT INTO bookings (login, id_slot) VALUES ('jean_paul', 1);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 2);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 3);
INSERT INTO bookings (login, id_slot) VALUES ('toto', 1);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 1);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 1);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 2);
INSERT INTO bookings (login, id_slot) VALUES ('toto', 4);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 5);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 6);
INSERT INTO bookings (login, id_slot) VALUES ('jean_paul', 7);
INSERT INTO bookings (login, id_slot) VALUES ('toto', 8);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 9);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 4);
INSERT INTO bookings (login, id_slot) VALUES ('jean_paul', 4);
-- pour tester les évènements passés
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 10);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 11);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 12);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 13);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 14);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 15);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 16);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 17);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 18);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 19);
INSERT INTO bookings (login, id_slot) VALUES ('jean_paul', 20);


INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-03', '09:00', '10:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-03', '10:00', '11:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-03', '11:00', '12:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-03', '14:00', '15:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-03', '15:00', '16:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-03', '16:00', '17:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-02', '09:00', '11:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-02', '11:00', '13:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-02', '14:00', '16:00');
INSERT INTO slots (day_start, time_start, time_end) VALUES ('2026-02-02', '16:00', '17:00');

INSERT INTO bookings (login, id_slot) VALUES ('jean_paul', 21);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 21);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 22);
INSERT INTO bookings (login, id_slot) VALUES ('toto', 22);
INSERT INTO bookings (login, id_slot) VALUES ('jean_paul', 23);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 24);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 25);
INSERT INTO bookings (login, id_slot) VALUES ('toto', 25);
INSERT INTO bookings (login, id_slot) VALUES ('jean_paul', 26);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 27);
INSERT INTO bookings (login, id_slot) VALUES ('charlie', 28);
INSERT INTO bookings (login, id_slot) VALUES ('toto', 29);
INSERT INTO bookings (login, id_slot) VALUES ('florine', 30);