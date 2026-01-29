-- Sélectionner les réservations du jour courant
SELECT 
    slots.id_slot,
    slots.day_start,
    slots.day_end,
    slots.time_start,
    slots.time_end,
    bookings.login AS booked_by
FROM slots 
INNER JOIN bookings ON slots.id_slot = bookings.id_slot
WHERE slots.day_start = DATE(NOW())
AND slots.id_slot IN (SELECT id_slot FROM bookings);