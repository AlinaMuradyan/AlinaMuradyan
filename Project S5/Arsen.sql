--Find Null Criteria for a Star
SELECT DISTINCT c.criteria_name AS column_name
FROM criteria AS c
LEFT JOIN celestial_object_criteria_numeric AS cocn
    ON c.criteria_id = cocn.criteria_id
LEFT JOIN celestial_object AS co
    ON co.object_id = cocn.object_id
WHERE co.object_name = 'StarNameHere' AND cocn.value IS NULL

UNION

SELECT DISTINCT c.criteria_name AS column_name
FROM criteria AS c
LEFT JOIN criteria_category AS cc
    ON c.criteria_id = cc.criteria_id
LEFT JOIN celestial_object_criteria_category AS cocc
    ON cc.category_id = cocc.category_id
LEFT JOIN celestial_object AS co
    ON co.object_id = cocc.object_id
WHERE co.object_name = 'StarNameHere' AND cocc.category_id IS NULL;