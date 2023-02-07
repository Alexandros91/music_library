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
-- (file: spec/seeds_artists.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE artists RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO artists (name, genre) VALUES ('Anna Vissi', 'Pop');
INSERT INTO artists (name, genre) VALUES ('Natassa Mpofiliou', 'Entexno');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 music_library_test < spec/seeds_artists.sql
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
# artist = artist.new
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
  def create(artist)
    # Executes the SQL query:
    # INSERT into artists (name, genre) VALUES ($1, $2);

    # Doesn't need to return anything (only creates the record).
  end

  # Updates a single record
  # Takes an artist object (with the updates fields)
  def update(artist)
  # Executes the SQL query:
  # UPDATE artists SET name = $1, genre = $2 WHERE id = $3;

  # Doesn't need to return anything (only updates the record).
  end

  # Deletes an artist record
  # given its id
  def delete(artist)
  # Executes the SQL query:
  # DELETE from artists WHERE id = $1;

  # Doesn't need to return anything (only deletes the record).
  end
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

artists.first.id # =>  1
artists.first.name # =>  'Anna Vissi'
artists.first.genre # =>  'Pop'

# 2
# Get a single artist

repo = ArtistRepository.new

artist = repo.find(1)

artist.id # =>  1
artist.name # =>  'Anna Vissi'
artist.genre # =>  'Pop'

# 3
# Get another artist

repo = ArtistRepository.new

artist = repo.find(2)

artist.id # =>  2
artist.name # =>  'Natassa Mpofiliou'
artist.genre # =>  'Entexno'

# 4
# Create a new artist
repo = ArtistRepository.new
new_artist = Artist.new
new_artist.name = 'Xaris Alexiou'
new_artist.genre = 'Laiko'
repo.create(new_artist)
artists = repo.all

artists.length # => 3
artists.last.id # => 3
artists.last.name # => 'Xaris Alexiou'
artists.last.genre # => 'Laiko'

# 5
# Create another artist
repo = ArtistRepository.new
new_artist_1 = Artist.new
new_artist_1.name = 'Xaris Alexiou'
new_artist_1.genre = 'Laiko'
repo.create(new_artist_1)
new_artist_2 = Artist.new
new_artist_2.name = 'Giorgos Ntalaras'
new_artist_2.genre = 'Rempetiko'
repo.create(new_artist_2)
artists = repo.all

artists.length # => 4
artists.last.id # => 4
artists.last.name # => 'Giorgos Ntalaras'
artists.last.genre # => 'Rempetiko'


# 6
# Update an existing artist
repo = ArtistRepository.new
artist = repo.find(1)
artist.name = 'Anna Vissy'
artist.genre = 'Elafrolaiko'
repo.update(artist)

updated_artist = repo.find(1)

updated_artist.name # => 'Anna Vissy'
updated_artist.genre # => 'Elafrolaiko'


# 7
# Update one value of an existing artist
repo = ArtistRepository.new
artist = repo.find(2)
artist.genre = 'Mpalantes'
repo.update(artist)

updated_artist = repo.find(2)

updated_artist.name # => 'Natassa Mpofiliou'
updated_artist.genre # => 'Mpalantes'

# 8
# Delete an existing artist
repo = ArtistRepository.new
artist_to_delete = repo.find(1)

repo.delete(artist_to_delete)

repo.length # => 1
repo.first.id # => 2

# 9
# Delete both artists
repo = ArtistRepository.new
artist_1_to_delete = repo.find(1)
artist_2_to_delete = repo.find(2)

repo.delete(artist_1_to_delete)
repo.delete(artist_2_to_delete)

repo.length # => 0

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/artist_repository_spec.rb

def reset_artists_table
  seed_sql = File.read('spec/seeds_artists.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe artistRepository do
  before(:each) do 
    reset_artists_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->

---

**How was this resource?**  
[😫](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😫) [😕](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😕) [😐](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😐) [🙂](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=🙂) [😀](https://airtable.com/shrUJ3t7KLMqVRFKR?prefill_Repository=makersacademy%2Fdatabases&prefill_File=resources%2Frepository_class_recipe_template.md&prefill_Sentiment=😀)  
Click an emoji to tell us.

<!-- END GENERATED SECTION DO NOT EDIT -->