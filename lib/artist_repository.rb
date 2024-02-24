require_relative './artist'

class ArtistRepository
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
    sql = 'INSERT INTO artists (name, genre) VALUES ($1, $2);'
    sql_params = [artist.name, artist.genre]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def delete(id)
    sql = 'DELETE from artists WHERE id = $1;'
    sql_params = [id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def update(artist)
    sql = 'UPDATE artists SET name = $1, genre = $2 WHERE id = $3;'
    sql_params = [artist.name, artist.genre, artist.id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def find_with_albums(artist_id)
    sql = 'SELECT 
    artists.id AS "artist_id",
    name AS "artist_name",
    genre,
    albums.id AS "album_id",
    albums.title AS "album_title",
    albums.release_year
    FROM artists
    JOIN albums
    ON artists.id = albums.artist_id
    WHERE artists.id = $1;'
    sql_params = [artist_id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
    first_record = result_set[0]

    artist = Artist.new
    artist.id = first_record['artist_id'].to_i
    artist.name = first_record['artist_name']
    artist.genre = first_record['genre']
    artist.albums = []

    result_set.each do |record|
      album = Album.new
      album.id = record['album_id']
      album.title = record['album_title']
      album.release_year = record['release_year'].to_i

      artist.albums << album
    end

    return artist
  end
end