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
    sql = 'SELECT id, name, genre FROM artists WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)

    record = result_set[0]

    artist = Artist.new
    artist.id = record['id'].to_i
    artist.name = record['name']
    artist.genre = record['genre']

    return artist
  end


  def create(artist)
    sql = 'INSERT into artists (name, genre) VALUES ($1, $2);'
    sql_params = [artist.name, artist.genre]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  # def update(artist)
  # end

  # def delete(artist)
  # end
end