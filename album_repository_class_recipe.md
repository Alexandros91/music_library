# Albums Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table.

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `albums`*

```
# EXAMPLE

Table: albums

Columns:
id | title | release_year | artist_id
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_albums.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO albums (title, release_year, artist_id) VALUES ('Vavel', 2016, 2);
INSERT INTO albums (title, release_year, artist_id) VALUES ('Klima Tropiko', 1996, 1);
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 music_library_test < spec/seeds_albums.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)
class Album
end

# Repository class
# (in lib/album_repository.rb)
class AlbumRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: albums

# Model class
# (in lib/album.rb)
class Album

  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :release_year, :artist_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# album = album.new
# album.name = 'Jo'
# album.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: albums

# Repository class
# (in lib/album_repository.rb)

class AlbumRepository

  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums;

    # Returns an array of album objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;

    # Returns a single album object.
  end

  # Creates a new album record
  # Takes an album object as an argument
  def create(album)
    # Executes the SQL query:
    # INSERT into albums (title, release_year, artist_id) VALUES ($1, $2, $3);

    # Returns nothing (only creates the record)
  end

  # Updates an existing album record
  # Takes a album object as an argument
  def update(album)
    # Executes the SQL query:
    # UPDATE albums SET title = $1, release_year = $2, artist_id = $3 WHERE id = $4;

    # Returns nothing (only updates the record)
  end

  # Deletes an existing album record
  # given its id
  def delete(album)
    # Executes the SQL query:
    # DELETE FROM albums WHERE id = $1;

    # Returns nothing (only deletes the record)
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all albums

repo = AlbumRepository.new

albums = repo.all

albums.length # =>  2

albums.first.id # =>  1
albums.first.title # =>  'Vavel'
albums.first.release_year # =>  2016
albums.first.artist_id # =>  2

# 2
# Get a single album

repo = AlbumRepository.new

album = repo.find(1)

album.id # =>  1
album.title # =>  'Vavel'
album.release_year # =>  2016
album.artist_id # =>  2

# 3
# Get another album

repo = AlbumRepository.new

album = repo.find(2)

album.id # =>  2
album.title # =>  'Klima Tropiko'
album.release_year # =>  1996
album.artist_id # =>  1

# 4
# Create a new album

repo = AlbumRepository.new
new_album = Album.new
new_album.id = 3
new_album.title = 'I agapi einai zali'
new_album.release_year = 1986
new_album.artist_id = 3
repo.create(new_album)
albums = repo.all

albums.length # =>  3
albums.last.id # =>  3
albums.last.title # =>  'I agapi einai zali'
albums.last.release_year # =>  1986
albums.last.artist_id # =>  3

# 5
# Update a new album

repo = AlbumRepository.new
album = repo.find(1)
album.title = 'Antidoto'
album.release_year = 1998
album.artist_id = 1

updated_album = repo.find(1)

updated_album.title # => 'Antidoto'
updated_album.release_year # => 1998
updated_album.artist_id # => 1

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/album_repository_spec.rb

def reset_albums_table
  seed_sql = File.read('spec/seeds_albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe albumRepository do
  before(:each) do 
    reset_albums_table
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