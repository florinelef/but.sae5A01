-- Récupérer les créneaux disponibles
SELECT 
    slots.id_slot,
    slots.day_start,
    slots.time_start,
    slots.time_end,
    categories.name_category,
    categories.capacity,
    COUNT(bookings.login) AS nb_reservations
FROM slots
LEFT JOIN bookings ON bookings.id_slot = slots.id_slot
INNER JOIN categories ON categories.id_category = slots.id_category
GROUP BY 
    slots.id_slot,
    slots.day_start,
    slots.time_start,
    slots.time_end,
    categories.name_category,
    categories.capacity
HAVING COUNT(bookings.login) < categories.capacity;
