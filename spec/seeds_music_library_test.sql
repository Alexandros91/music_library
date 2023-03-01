TRUNCATE TABLE artists RESTART IDENTITY; -- replace with your own table name.
TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO artists (name, genre) VALUES ('Anna Vissi', 'Pop');
INSERT INTO artists (name, genre) VALUES ('Natassa Mpofiliou', 'Entexno');

INSERT INTO albums (title, release_year, artist_id) VALUES ('Vavel', 2016, 2);
INSERT INTO albums (title, release_year, artist_id) VALUES ('Klima Tropiko', 1996, 1);
INSERT INTO albums (title, release_year, artist_id) VALUES ('Oi meres tou fotos', 2012, 2);
INSERT INTO albums (title, release_year, artist_id) VALUES ('I epomeni kinisi', 1986, 1);