-- Creating table : rangers
CREATE table rangers (
    ranger_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50)
);

SELECT * from rangers;

-- creating table : species
CREATE table species (
    species_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

SELECT * from species;

-- creating table : sightings
CREATE table sightings (
    sighting_id SERIAL UNIQUE NOT NULL PRIMARY KEY,
    species_id INTEGER REFERENCES species (species_id),
    ranger_id INTEGER REFERENCES rangers (ranger_id),
    location VARCHAR(50),
    sighting_time TIMESTAMP,
    notes TEXT
);

SELECT * from sightings;

-- inserting data to table : rangers
INSERT INTO
    rangers (ranger_id, name, region)
VALUES (
        1,
        'Alice Green',
        'Northern Hills'
    ),
    (2, 'Bob White', 'River Delta'),
    (
        3,
        'Carol King',
        'Mountain Range'
    );

-- inserting data to table : species
INSERT INTO
    species (
        species_id,
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        1,
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        2,
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        3,
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        4,
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

-- inserting data to table : sightings
INSERT INTO
    sightings (
        sighting_id,
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:0',
        'Feeding observed'
    ),
    (
        4,
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- Problem 1
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- Problem 2
SELECT count(species_id) as unique_species_count
from species
where
    species_id IN (
        SELECT species_id
        from sightings
    );

-- Problem 3
SELECT * from sightings WHERE location LIKE '%Pass%';

-- Problem 4
SELECT r.name as name, count(*) as total_sightings
from rangers as r
    join sightings as s on r.ranger_id = s.ranger_id
GROUP BY
    r.ranger_id
ORDER BY name;

-- Problem 5
-- solution 1 :
SELECT common_name
FROM species
WHERE
    species_id NOT IN (
        SELECT species_id
        FROM sightings
    );

-- solution 2 (using LEFT JOIN operation) :
SELECT common_name
FROM species AS sp
    LEFT JOIN sightings AS st ON sp.species_id = st.species_id
WHERE
    sighting_id IS NULL;

-- Problem 6
SELECT table2.common_name, table2.sighting_time, table1.name
FROM (
        select name, sighting_time
        from sightings as st
            JOIN rangers as r ON st.ranger_id = r.ranger_id
        order by sighting_time DESC
        LIMIT 2
    ) as table1
    JOIN (
        SELECT common_name, sighting_time
        FROM species as sp
            JOIN sightings as st on sp.species_id = st.species_id
        ORDER BY sighting_time DESC
        limit 2
    ) as table2 on table1.sighting_time = table2.sighting_time;

-- Problem 7
UPDATE species
set
    conservation_status = 'Historic'
where
    EXTRACT(
        YEAR
        from discovery_date
    ) < 1800;

-- Problem 8
SELECT
    sighting_id,
    CASE
        WHEN extract(
            hour
            from sighting_time
        ) < 12 THEN 'Morning'
        WHEN extract(
            hour
            from sighting_time
        ) between 12 and 17  then 'Afternoon'
        ELSE 'Evening'
    END as time_of_day
from sightings;

-- Problem 9
DELETE from rangers
WHERE
    ranger_id IN (
        SELECT r.ranger_id
        from rangers as r
            LEFT JOIN sightings as st on r.ranger_id = st.ranger_id
        where
            sighting_id IS NULL
    );