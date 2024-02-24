# Artists Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `artists`*

```
# EXAMPLE

Table: artists

Columns:
id | name | genre
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: seeds/artists.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE artists RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO artists (name, genre) VALUES ('Anna Vissi', 'Laiko');
INSERT INTO artists (name, genre) VALUES ('Natassa Mpofiliou', 'Entexno');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 music_library_test < artists.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: artists

# Model class
# (in lib/artist.rb)
class Artist
end

# Repository class
# (in lib/artist_repository.rb)
class ArtistRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: artists

# Model class
# (in lib/artist.rb)

class Artist

  # Replace the attributes by your own columns.
  attr_accessor :id, :name, :genre
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# artist = Artist.new
# artist.name = 'Jo'
# artist.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: artists

# Repository class
# (in lib/artist_repository.rb)

class ArtistRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, name, genre FROM artists;

    # Returns an array of artist objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, genre FROM artists WHERE id = $1;

    # Returns a single artist object.
  end

  # Add more methods below for each operation you'd like to implement.

    # Inserts a new artist record
    # Takes an Artist object in argument
  # def create(artist)
    # Executes the SQL query:
    # INSERT INTO artists (name, genre) VALUES ($1, $2);
  
    # Returns nothing (only creates the Artist object)
  # end

    # Deletes an artist record
    # given its id
  # def delete(id)
    # Executes the SQL query:
    # DELETE artists WHERE id = $1;

    # Returns nothing (only deletes the record)
  # end

    # Updates an artist record
    # Takes an Artist object (with the updated fields)
  # def update(artist)
    # Executes the SQL query:
    # UPDATE artists SET name = $1, genre = $2, WHERE id = $3;

    # Returns nothing (only updates the record)
  # end

  # Finds an artist record along with the associated albums
  # given its id
  # def find_with_albums(artist_id)
    # Executes the SQL query:
    # 'SELECT 
    # artists.id AS "artist_id",
    # name AS "asrtist_name",
    # genre,
    # albums.id AS "album_id",
    # albums.title AS "album_title",
    # albums.release_year
    # FROM artists
    # JOIN albums
    # ON artist_id = artists.id
    # WHERE artists.id = 1;'

    # Returns the first artist with all their albums
  # end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all artists

repo = ArtistRepository.new

artists = repo.all
artists.length # =>  2

artists[0].id # =>  1
artists[0].name # =>  'Anna Vissi'
artists[0].genre # =>  'Laiko'

artists[1].id # =>  2
artists[1].name # =>  'Natassa Mpofiliou'
artists[1].genre # =>  'Entexno'

# 2
# Get a single artist

repo = ArtistRepository.new

artist = repo.find(1)

artist.id # =>  1
artist.name # =>  'Anna Vissi'
artist.genre # =>  'Laiko'

# 3
# Get another artist

repo = ArtistRepository.new

artist = repo.find(2)
artist.id # =>  2
artist.name # =>  'Natassa Mpofiliou'
artist.genre # =>  'Entexno'


# Add more examples for each method

# 4
# Create a new artist

repo = ArtistRepository.new

artist = Artist.new
artist.name = 'Beatles'
artist.genre = 'Pop'

repo.create(artist) # => nil

artists = repo.all
last_artist = artists.last
artists.length # => 3
last_artist.id # => 3
last_artist.name # => 'Beatles'
last_artist.genre # => 'Pop'

# 5
# Delete an artist

repo = ArtistRepository.new
artists = repo.all

id_to_delete = 1
repo.delete(id_to_delete)

last_artist = artists.last
artists.length # => 1
last_artist.id # => 1
last_artist.name # => 'Anna Vissi'
last_artist.genre # => 'Laiko'

# 6
# Delete both artists

repo = ArtistRepository.new

repo.delete(1)
repo.delete(2)
artists = repo.all

artists.length # => 0

# 7
# Update an artist

repo = ArtistRepository.new

updated_artist = repo.find(1)
repo.update(updated_artist)

updated_artist.name = 'Fake Artist'
updated_artist.genre = 'Fake Genre'
artists = repo.all
artists.first.name # => 'Fake Artist'
artists.first.genre # => 'Fake Genre'

# 8
# Find an artist with their albums

repo = ArtistRepository.new

artist = find_with_albums(1)

artist.id # => 1
artist.name # => 'Anna Vissi'
artist.genre # => 'Laiko'
artist.albums.length # => 2 
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/artist_repository_spec.rb

def reset_artists_table
  seed_sql = File.read('seeds/artists.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe ArtistRepository do
  before(:each) do 
    reset_artists_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->