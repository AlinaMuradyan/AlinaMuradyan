SELECT 
    co.object_id AS object_id,
    co.object_name AS "StarName",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Temperature' THEN cocn.value END), 0) AS "Temperature",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Mass' THEN cocn.value END), 0) AS "Mass",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Apparent Magnitude V' THEN cocn.value END), 0) AS "Apparent Magnitude V",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Apparent Magnitude J' THEN cocn.value END), 0) AS "Apparent Magnitude J",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Apparent Magnitude K' THEN cocn.value END), 0) AS "Apparent Magnitude K",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Distance' THEN cocn.value END), 0) AS "Distance",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Rotation' THEN cocn.value END), 0) AS "Rotation",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Rotational velocity' THEN cocn.value END), 0) AS "Rotational velocity",
    COALESCE(MAX(CASE WHEN c.criteria_name = 'Age' THEN cocn.value END), 0) AS "Age",
    COALESCE(MAX(CASE WHEN ccc.criteria_name = 'Class' THEN cc.category_name END), 'Unknown') AS "Class",
    COALESCE(MAX(CASE WHEN ccc.criteria_name = 'Color' THEN cc.category_name END), 'Unknown') AS "Color",
    COALESCE(MAX(CASE WHEN ccc.criteria_name = 'Evolutionary stage' THEN cc.category_name END), 'Unknown') AS "Evolutionary stage"
FROM celestial_object AS co
    INNER JOIN object_types AS ot ON co.object_type_id = ot.type_id
    LEFT JOIN celestial_object_criteria_numeric AS cocn ON co.object_id = cocn.object_id
    LEFT JOIN criteria AS c ON cocn.criteria_id = c.criteria_id
    LEFT JOIN celestial_object_criteria_category AS cocc ON co.object_id = cocc.object_id
    LEFT JOIN criteria_category AS cc ON cocc.category_id = cc.category_id
    LEFT JOIN criteria AS ccc ON cc.criteria_id = ccc.criteria_id
WHERE co.object_type_id = 1 -- Assuming 1 represents "Stars"
GROUP BY co.object_id, co.object_name
ORDER BY co.object_name;