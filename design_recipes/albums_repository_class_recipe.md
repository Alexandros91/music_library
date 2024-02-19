# Albums Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

*In this template, we'll use an example table `albums`*

```
# EXAMPLE

Table: albums

Columns:
id | title | release_year
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: seeds/albums.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE albums RESTART IDENTITY; -- replace with your own table title.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO albums (title, release_year, artist_id) VALUES ('Klima Tropiko', '1996', '1');
INSERT INTO albums (title, release_year, artist_id) VALUES ('Vavel', '2015', '2');
INSERT INTO albums (title, release_year, artist_id) VALUES ('I Epochi Tou Therismou', '2020', '2');
INSERT INTO albums (title, release_year, artist_id) VALUES ('Kitrino Galazio', '1980', '1');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 music_library_test < albums.sql
```

## 3. Define the class titles

Usually, the Model class title will be the capitalised table title (single instead of plural). The same title is then suffixed by `Repository` for the Repository class title.

```ruby
# EXAMPLE
# Table title: albums

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
# Table title: albums

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
# album = Album.new
# album.title = 'Jo'
# album.title
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table title: albums

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

  # Add more methods below for each operation you'd like to implement.

  # def create(album)
  # end

  # def update(album)
  # end

  # def delete(album)
  # end
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
albums.length # =>  4

albums[0].id # =>  1
albums[0].title # =>  'Klima Tropiko'
albums[0].release_year # =>  '1996'
albums[0].artist_id # =>  '1'

albums[1].id # =>  2
albums[1].title # =>  'Vavel'
albums[1].release_year # =>  '2015'
albums[1].artist_id # =>  '2'

albums[2].id # =>  2
albums[2].title # =>  'I Epochi Tou Therismou'
albums[2].release_year # =>  '2015'
albums[2].artist_id # =>  '2'

albums[3].id # =>  2
albums[3].title # =>  'Kitrino Galazio'
albums[3].release_year # =>  '1980'
albums[3].artist_id # =>  '1'


# 2
# Get a single album

repo = AlbumRepository.new

album = repo.find(1)

album.id # =>  1
album.title # =>  'Klima Tropiko'
album.release_year # =>  '1996'
album.artist_id # => '1'

# 3
# Get another album

album = repo.find(2)

album.id # =>  2
album.title # =>  'Vavel'
album.release_year # =>  '2015'
album.artist_id # => '2'

# 4
# Get another album

album = repo.find(3)

album.id # =>  3
album.title # =>  'I Epochi Tou Therismou'
album.release_year # =>  '2020'
album.artist_id # => '2'

# 5
# Get another album

album = repo.find(4)

album.id # =>  4
album.title # =>  'Kitrino Galazio'
album.release_year # =>  '1980'
album.artist_id # => '1'

# Add more examples for each method
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/album_repository_spec.rb

def reset_albums_table
  seed_sql = File.read('seeds/albums.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe AlbumRepository do
  before(:each) do 
    reset_albums_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._

<!-- BEGIN GENERATED SECTION DO NOT EDIT -->