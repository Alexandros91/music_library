require_relative './album'

class AlbumRepository

  # Selecting all records
  # No arguments
  def all
    sql = 'SELECT id, title, release_year, artist_id FROM albums;'
    result_set = DatabaseConnection.exec_params(sql, [])

    albums = []

    result_set.each do |record|
      album = Album.new
      album.id = record['id'].to_i
      album.title = record['title']
      album.release_year = record['release_year'].to_i
      album.artist_id = record['artist_id'].to_i

      albums << album
    end

    return albums
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    sql = 'SELECT id, title, release_year, artist_id FROM albums WHERE id = $1;'
    sql_params = [id]

    result_set = DatabaseConnection.exec_params(sql, sql_params)
    record = result_set[0]
    album = Album.new
    album.id = record['id'].to_i
    album.title = record['title']
    album.release_year = record['release_year'].to_i
    album.artist_id = record['artist_id'].to_i
    
    return album
  end


  def create(album)
    sql = 'INSERT into albums (title, release_year, artist_id) VALUES ($1, $2, $3);'
    sql_params = [album.title, album.release_year, album.artist_id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  def update(album)
    sql = 'UPDATE albums SET title = $1, release_year = $2, artist_id = $3 WHERE id = $4;'
    sql_params = [album.title, album.release_year, album.artist_id, album.id]

    DatabaseConnection.exec_params(sql, sql_params)

    return nil
  end

  # def delete(album)
  # end
end