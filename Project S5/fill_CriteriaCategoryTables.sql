INSERT INTO object_types (type_id, type_name) VALUES
    (1, 'Stars'),
    (2, 'Galaxies'),
    (3, 'Quasars'),
    (4, 'Active Galactic Nuclei (AGN)'),
    (5, 'Star Clusters'),
    (6, 'Nebulae'),
    (7, 'Supernovae'),
    (8, 'Asteroids and Minor Bodies'),
    (9, 'White Dwarfs'),
    (10, 'RR Lyrae Variables'),
    (11, 'Cepheid Variables'),
    (12, 'Tidal Disruption Events (TDE)');


INSERT INTO criteria (criteria_id, type_id, criteria_name, criteria_measure) VALUES
    -- Stars
    (1, 1, 'Class', NULL),
    (2, 1, 'Temperature', 'C'),
    (3, 1, 'Mass', 'M☉'),
    (4, 1, 'Color', NULL),
    (5, 1, 'Apparent Magnitude V', 'mag'),
    (6, 1, 'Apparent Magnitude J', 'mag'),
    (7, 1, 'Apparent Magnitude K', 'mag'),
    (8, 1, 'Evolutionary Stage', NULL),
    (9, 1, 'Distance', 'light years'),
    (10, 1, 'Rotation', 'years'),
    (11, 1, 'Rotational Velocity', 'km/s'),
    (12, 1, 'Age', 'Myr'),

    -- Galaxies
    (13, 2, 'Stellar Mass', 'M☉'),
    (14, 2, 'Star Formation Rate (SFR)', 'M☉/yr'),
    (15, 2, 'Surface Brightness', 'mag/arcsec^2'),

    -- Positional Data
    (16, NULL, 'Right Ascension', 'degrees'),
    (17, NULL, 'Declination', 'degrees'),

    -- Photometric Data
    (18, NULL, 'u-band Magnitude', 'mag'),
    (19, NULL, 'g-band Magnitude', 'mag'),
    (20, NULL, 'r-band Magnitude', 'mag'),
    (21, NULL, 'i-band Magnitude', 'mag'),
    (22, NULL, 'z-band Magnitude', 'mag'),

    -- Spectroscopic Data
    (23, NULL, 'Redshift', 'z'),
    (24, NULL, 'H-alpha Line Strength', NULL),
    (25, NULL, 'H-beta Line Strength', NULL),
    (26, NULL, 'O III Line Strength', NULL),
    (27, NULL, 'N II Line Strength', NULL),
    (28, NULL, 'S II Line Strength', NULL),
    (29, NULL, 'Equivalent Widths of Spectral Lines', NULL),
    (30, NULL, 'Spectral Index', NULL),

    -- Astrometric Data
    (31, NULL, 'Proper Motion RA', 'mas/yr'),
    (32, NULL, 'Proper Motion Dec', 'mas/yr'),
    (33, NULL, 'Radial Velocity', 'km/s'),

    -- Orbital Elements (Asteroids)
    (34, 8, 'Semi-major Axis', 'AU'),
    (35, 8, 'Eccentricity', NULL),
    (36, 8, 'Inclination', 'degrees'),
    (37, 8, 'Absolute Magnitude (H)', 'mag'),

    -- Variability Metrics (Variable Stars)
    (38, 10, 'Period', 'days'),
    (39, 10, 'Amplitude', 'mag'),
    (40, 10, 'Light Curve Parameters', NULL);


INSERT INTO criteria_category (criteria_id, category_name) VALUES
    -- Stars
    (1, 'O'),
    (1, 'B'),
    (1, 'A'),
    (1, 'F'),
    (1, 'G'),
    (1, 'K'),
    (1, 'M'),
    (4, 'blue'),
    (4, 'blue-white'),
    (4, 'white'),
    (4, 'yellow-white'),
    (4, 'yellow'),
    (4, 'orange'),
    (4, 'red'),
    (8, 'Main Sequence'),
    (8, 'Giant'),
    (8, 'White Dwarf'),
    (8, 'Variable Star'),

    -- Galaxies
    (13, 'Elliptical'),
    (13, 'Spiral'),
    (13, 'Irregular'),
    (13, 'Dwarf'),
    (13, 'Starburst'),
    (13, 'Seyfert'),
    (13, 'LINER'),

    -- Quasars
    (14, 'Radio-loud'),
    (14, 'Radio-quiet'),
    (14, 'High-redshift'),

    -- AGN
    (15, 'Type 1 (Broad-line)'),
    (15, 'Type 2 (Narrow-line)'),
    (15, 'LINER'),

    -- Clusters
    (16, 'Open Cluster'),
    (16, 'Globular Cluster'),
    (16, 'Supercluster'),

    -- Nebulae
    (17, 'Emission'),
    (17, 'Reflection'),
    (17, 'Dark'),

    -- Supernovae
    (18, 'Type Ia'),
    (18, 'Type II'),
    (18, 'Type Ib/c'),

    -- Asteroids
    (19, 'Main Belt'),
    (19, 'Near-Earth'),
    (19, 'Trans-Neptunian'),

    -- Variable Stars
    (20, 'RR Lyrae (Fundamental mode)'),
    (20, 'RR Lyrae (First overtone)'),
    (21, 'Cepheid (Classical)'),
    (21, 'Cepheid (Type II)');
