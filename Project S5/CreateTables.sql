-- Object Types Table
CREATE TABLE object_types (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE
);

COMMENT ON TABLE object_types IS 'Celestial object types, such as stars, galaxies, quasars, etc.';
COMMENT ON COLUMN object_types.type_id IS 'Unique identifier for Object Type';
COMMENT ON COLUMN object_types.type_name IS 'Name of the Object Type, e.g., Stars, Galaxies, Quasars, etc.';

-- Celestial Object Table
CREATE TABLE celestial_object (
    object_id SERIAL PRIMARY KEY,
    object_type_id INTEGER NOT NULL,
    object_name VARCHAR(50) NOT NULL UNIQUE,
    right_ascension NUMERIC(20,10),
    declination NUMERIC(20,10),
    CONSTRAINT fk_object_type FOREIGN KEY (object_type_id) REFERENCES object_types (type_id)
);

COMMENT ON TABLE celestial_object IS 'Contains data about celestial objects.';
COMMENT ON COLUMN celestial_object.object_id IS 'Unique identifier for a celestial object.';
COMMENT ON COLUMN celestial_object.object_type_id IS 'Type of the celestial object.';
COMMENT ON COLUMN celestial_object.object_name IS 'Name of the celestial object.';
COMMENT ON COLUMN celestial_object.right_ascension IS 'Right Ascension of the object.';
COMMENT ON COLUMN celestial_object.declination IS 'Declination of the object.';

-- Criteria Table
CREATE TABLE criteria (
    criteria_id SERIAL PRIMARY KEY,
    type_id INTEGER,
    criteria_name VARCHAR(50) NOT NULL,
    criteria_measure VARCHAR(50),
    CONSTRAINT fk_type FOREIGN KEY (type_id) REFERENCES object_types (type_id)
);

COMMENT ON TABLE criteria IS 'Defines criteria for celestial objects, such as photometric, spectroscopic, or variability metrics.';
COMMENT ON COLUMN criteria.criteria_id IS 'Unique identifier for a criterion.';
COMMENT ON COLUMN criteria.criteria_name IS 'Name of the criterion, e.g., Magnitude, Stellar Mass.';
COMMENT ON COLUMN criteria.criteria_measure IS 'Unit of measurement for the criterion, e.g., magnitude, solar masses.';

-- Criteria Category Table
CREATE TABLE criteria_category (
    category_id SERIAL PRIMARY KEY,
    criteria_id INTEGER NOT NULL,
    category_name VARCHAR(50),
    CONSTRAINT fk_criteria FOREIGN KEY (criteria_id) REFERENCES criteria (criteria_id)
);

COMMENT ON TABLE criteria_category IS 'Defines categorical values for a given criterion.';
COMMENT ON COLUMN criteria_category.category_id IS 'Unique identifier for a category.';
COMMENT ON COLUMN criteria_category.criteria_id IS 'Criterion associated with the category.';
COMMENT ON COLUMN criteria_category.category_name IS 'Name of the category, e.g., Main Sequence, Spiral Galaxy.';

-- Numeric Criteria Data
CREATE TABLE celestial_object_criteria_numeric (
    object_id INTEGER NOT NULL,
    criteria_id INTEGER NOT NULL,
    value NUMERIC(20,10),
    CONSTRAINT fk_object FOREIGN KEY (object_id) REFERENCES celestial_object (object_id),
    CONSTRAINT fk_criteria FOREIGN KEY (criteria_id) REFERENCES criteria (criteria_id),
    PRIMARY KEY (object_id, criteria_id)
);

COMMENT ON TABLE celestial_object_criteria_numeric IS 'Stores numeric criteria values for celestial objects.';
COMMENT ON COLUMN celestial_object_criteria_numeric.object_id IS 'Celestial Object identifier.';
COMMENT ON COLUMN celestial_object_criteria_numeric.criteria_id IS 'Criterion identifier.';
COMMENT ON COLUMN celestial_object_criteria_numeric.value IS 'Value of the numeric criterion.';

-- Categorical Criteria Data
CREATE TABLE celestial_object_criteria_category (
    object_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    CONSTRAINT fk_object FOREIGN KEY (object_id) REFERENCES celestial_object (object_id),
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES criteria_category (category_id),
    PRIMARY KEY (object_id, category_id)
);

COMMENT ON TABLE celestial_object_criteria_category IS 'Stores categorical criteria for celestial objects.';
COMMENT ON COLUMN celestial_object_criteria_category.object_id IS 'Celestial Object identifier.';
COMMENT ON COLUMN celestial_object_criteria_category.category_id IS 'Category identifier.';

-- History Table
CREATE TABLE history (
    history_id SERIAL PRIMARY KEY,
    date_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    object_id INTEGER NOT NULL,
    old_data JSON,
    new_data JSON,
    CONSTRAINT fk_object FOREIGN KEY (object_id) REFERENCES celestial_object (object_id)
);

COMMENT ON TABLE history IS 'Tracks changes to celestial objects.';
COMMENT ON COLUMN history.date_time IS 'Timestamp of the change.';
COMMENT ON COLUMN history.old_data IS 'Old data in JSON format.';
COMMENT ON COLUMN history.new_data IS 'New data in JSON format.';

-- Stars Spectral Type and Temperature Table
CREATE TABLE stars_spectral_type_temperature (
    category_id INTEGER NOT NULL,
    temperature_from INTEGER NOT NULL,
    temperature_to INTEGER NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES criteria_category (category_id),
    PRIMARY KEY (category_id)
);

COMMENT ON TABLE stars_spectral_type_temperature IS 'Defines surface temperature range for each spectral type.';
COMMENT ON COLUMN stars_spectral_type_temperature.temperature_from IS 'Lower bound of temperature range.';
COMMENT ON COLUMN stars_spectral_type_temperature.temperature_to IS 'Upper bound of temperature range.';

-- Stars Data Table
CREATE TABLE stars_data (
    object_id INTEGER NOT NULL,
    constellation_id INTEGER NOT NULL,
    designation VARCHAR(200),
    CONSTRAINT fk_object FOREIGN KEY (object_id) REFERENCES celestial_object (object_id),
    CONSTRAINT fk_constellation FOREIGN KEY (constellation_id) REFERENCES celestial_object (object_id),
    PRIMARY KEY (object_id)
);

COMMENT ON TABLE stars_data IS 'Stores additional data specific to stars.';
COMMENT ON COLUMN stars_data.object_id IS 'Star identifier.';
COMMENT ON COLUMN stars_data.constellation_id IS 'Identifier for the constellation the star belongs to.';
COMMENT ON COLUMN stars_data.designation IS 'IAU catalog designation for the star.';
