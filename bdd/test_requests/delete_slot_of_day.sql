-- Supprimer tous les créneaux du 12 octobre 2025 (inondation dans la salle)
DELETE FROM slots 
WHERE day_start = '2025-10-12'
AND day_end = '2025-10-12';