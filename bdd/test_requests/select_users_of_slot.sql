-- Sélectionner les personnes impliquées dans le créneau 1
SELECT login, id_slot from bookings 
WHERE id_slot = 1;