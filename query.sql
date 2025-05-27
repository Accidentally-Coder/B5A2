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
    ranger_id INTEGER REFERENCES rangers (ranger_id),
    species_id INTEGER REFERENCES species (species_id),
    sighting_time DATE,
    location VARCHAR(50),
    notes TEXT
);

SELECT * from sightings;