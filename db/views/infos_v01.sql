SELECT DISTINCT disturbances.information
FROM disturbances 
WHERE disturbances.information IS NOT NULL 
ORDER BY disturbances.information;