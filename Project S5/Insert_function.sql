CREATE OR REPLACE FUNCTION insert_celestial_object(
    objectName VARCHAR(20),
    typeId INTEGER
)
RETURNS INTEGER
AS $$
DECLARE
    v_object_id INTEGER;
BEGIN
    SELECT object_id INTO v_object_id
    FROM celestial_object
    WHERE object_name = objectName AND object_type_id = typeId;

    IF v_object_id IS NULL THEN
        INSERT INTO celestial_object(object_type_id, object_name)
        VALUES (typeId, objectName)
        RETURNING object_id INTO v_object_id;
    END IF;

    RETURN v_object_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_criteria_values(objectid INT, object_criteria JSON)
RETURNS VOID
AS $$
DECLARE
    criteria_not_exists TEXT;
BEGIN
    CREATE TEMP TABLE criteria_values(
        criteria_id INT,
        criteria_name VARCHAR(50),
        criteria_value TEXT,
        is_numeric BOOLEAN,
        category_id INTEGER
    );

    -- Insert into temporary table and preprocess passed data
    INSERT INTO criteria_values (criteria_name, criteria_value)
    SELECT tmp.key, CAST(tmp.value AS TEXT)
    FROM json_each_text(object_criteria) AS tmp;

    -- Set criteria_id
    UPDATE criteria_values
    SET criteria_id = c.criteria_id,
        is_numeric = CASE WHEN c.criteria_measure IS NOT NULL THEN TRUE ELSE FALSE END
    FROM criteria c
    WHERE criteria_values.criteria_name = c.criteria_name;

    -- Set category_id for non-numeric criteria
    UPDATE criteria_values
    SET category_id = cc.category_id
    FROM criteria_category cc
    WHERE cc.category_name = criteria_values.criteria_value
      AND cc.criteria_id = criteria_values.criteria_id
      AND criteria_values.is_numeric = FALSE;

    -- Check that criteria exists in DB
    SELECT TO_JSON(criteria_name) INTO criteria_not_exists
    FROM criteria_values
    WHERE criteria_id IS NULL;

    IF criteria_not_exists IS NOT NULL THEN
        RAISE EXCEPTION 'Unknown criteria %', criteria_not_exists;
        DROP TABLE criteria_values;
        RETURN;
    END IF;

    -- Insert numeric criteria
    INSERT INTO celestial_object_criteria_numeric(object_id, criteria_id, value)
    SELECT objectid, criteria_values.criteria_id, CAST(criteria_values.criteria_value AS NUMERIC(20,5))
    FROM criteria_values
    WHERE criteria_values.is_numeric = TRUE
      AND NOT EXISTS(
          SELECT *
          FROM celestial_object_criteria_numeric co
          WHERE co.object_id = objectid AND co.criteria_id = criteria_values.criteria_id
      );

    -- Update numeric criteria
    UPDATE celestial_object_criteria_numeric
    SET value = CAST(criteria_values.criteria_value AS NUMERIC(20,5))
    FROM criteria_values
    WHERE criteria_values.criteria_id = celestial_object_criteria_numeric.criteria_id
      AND celestial_object_criteria_numeric.object_id = objectid
      AND criteria_values.is_numeric = TRUE;

    -- Insert non-numeric criteria
    INSERT INTO celestial_object_criteria_category(object_id, category_id)
    SELECT objectid, criteria_values.category_id
    FROM criteria_values
    WHERE criteria_values.is_numeric = FALSE
      AND NOT EXISTS(
          SELECT *
          FROM celestial_object_criteria_category co
          WHERE co.object_id = objectid AND co.category_id = criteria_values.category_id
      );

    -- Update non-numeric criteria
    UPDATE celestial_object_criteria_category
    SET category_id = criteria_values.category_id
    FROM criteria_values
    WHERE celestial_object_criteria_category.category_id = criteria_values.category_id
      AND celestial_object_criteria_category.object_id = objectid;

    DROP TABLE IF EXISTS criteria_values;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_celestial_object(
    object_name VARCHAR(20),
    object_type_id INT,
    object_criteria JSON -- JSON object containing criteria data
)
RETURNS INT
AS $$
DECLARE
    object_id INT;
BEGIN
    object_id := insert_celestial_object(object_name, object_type_id);
    PERFORM insert_criteria_values(object_id, object_criteria);
    RETURN object_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_star(
    starName VARCHAR(20),
    object_criteria JSON,
    constellationName VARCHAR(20) DEFAULT NULL,
    v_designation VARCHAR(200) DEFAULT NULL
)
RETURNS VOID
AS $$
DECLARE
    star_object_type_id INTEGER := 1; -- type_id for stars
    constellation_object_type_id INTEGER := 5; -- type_id for constellations
    star_object_id INTEGER;
    constellation_object_id INTEGER;
BEGIN
    -- Insert star object
    star_object_id := insert_celestial_object(starName, star_object_type_id);

    -- Insert constellation object if provided
    IF constellationName IS NOT NULL THEN
        constellation_object_id := insert_celestial_object(constellationName, constellation_object_type_id);
    END IF;

    -- Insert or update star data
    IF NOT EXISTS (SELECT * FROM stars_data WHERE object_id = star_object_id) THEN
        INSERT INTO stars_data(object_id, constellation_id, designation)
        VALUES(star_object_id, constellation_object_id, v_designation);
    ELSE
        UPDATE stars_data
        SET constellation_id = constellation_object_id, designation = v_designation
        WHERE object_id = star_object_id;
    END IF;

    RETURN;
END;
$$ LANGUAGE plpgsql;
