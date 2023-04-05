SELECT DISTINCT disturbances.date, disturbances.train 
FROM Disturbances 
WHERE perturbation = 'Supprimé' 
ORDER BY date DESC;