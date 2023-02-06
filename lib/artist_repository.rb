require_relative './artist'

class ArtistRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT id, name, genre FROM artists;'
    result_set = DatabaseConnection.exec_params(sql, [])
    artists = []

    result_set.each do |record|
      artist = Artist.new
      artist.id = record['id'].to_i
      artist.name = record['name']
      artist.genre = record['genre']

      artists << artist
    end

    return artists
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, name, genre FROM artists WHERE id = $1;

    # Returns a single artist object.
  end

  # Add more methods below for each operation you'd like to implement.

  # def create(artist)
  # end

  # def update(artist)
  # end

  # def delete(artist)
  # end
end