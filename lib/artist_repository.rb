require_relative './artist'
require_relative './album'

class ArtistRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT id, name, genre FROM artists;'
    result_set = DatabaseConnection.exec_params(sql, [])
    artists = []

    result_set.each do |record|
      artists << record_to_artist_object(record)
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

    return record_to_artist_object(record)
  end


  def create(artist)
    sql = 'INSERT into artists (name, genre) VALUES ($1, $2);'
    sql_params = [artist.name, artist.genre]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def update(artist)
    sql = 'UPDATE artists SET name = $1, genre = $2 WHERE id = $3;'
    sql_params = [artist.name, artist.genre, artist.id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(artist)
    sql = 'DELETE from artists WHERE id = $1;'
    sql_params = [artist.id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def find_with_albums(artist_id)
    sql = 'SELECT artists.id AS "id",
    artists.name AS "name",
    artists.genre AS "genre",
    albums.id AS "album_id",
    albums.title AS "title",
    albums.release_year AS "release_year"
    FROM artists
    JOIN albums
    ON albums.artist_id = artists.id
    WHERE artists.id = $1;'
    sql_params = [artist_id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
    first_record = result_set[0]

    artist = record_to_artist_object(first_record)

    result_set.each do |record|
      artist.albums << record_to_album_object(record)
    end

    return artist
  end

  private

  def record_to_artist_object(record)
    artist = Artist.new
    artist.id = record['id'].to_i
    artist.name = record['name']
    artist.genre = record['genre']
    artist.albums = []

    return artist
  end

  def record_to_album_object(record)
    album = Album.new
    album.id = record['album_id'].to_i
    album.title = record['title']
    album.release_year = record['release_year']

    return album
  end

end