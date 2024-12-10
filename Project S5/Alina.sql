-- Stars and their constellations
SELECT
    c.object_name AS star_name,
    c1.object_name AS constellation_name
FROM celestial_object AS c
LEFT JOIN stars_data AS sd ON c.object_id = sd.object_id
LEFT JOIN celestial_object AS c1 ON sd.constellation_id = c1.object_id
WHERE c.object_type_id = 1
ORDER BY constellation_name;

-- History of a specific star
SELECT
    h.date_time,
    h.old_data,
    h.new_data
FROM history AS h
JOIN celestial_object AS c ON h.object_id = c.object_id
WHERE c.object_name = 'StarNameHere'
ORDER BY h.date_time;

-- Numeric and categorical criteria for a specific star
SELECT
    cr.criteria_name,
    COALESCE(CAST(co.value AS TEXT), ccg.category_name) AS value
FROM celestial_object AS c
LEFT JOIN celestial_object_criteria_numeric AS co ON c.object_id = co.object_id
LEFT JOIN criteria AS cr ON co.criteria_id = cr.criteria_id
LEFT JOIN celestial_object_criteria_category AS cc ON c.object_id = cc.object_id
LEFT JOIN criteria_category AS ccg ON cc.category_id = ccg.category_id
WHERE c.object_name = 'StarNameHere';
