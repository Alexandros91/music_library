require 'album_repository'

RSpec.describe AlbumRepository do

  def reset_albums_table
    seed_sql = File.read('spec/seeds_albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
  
  
  before(:each) do 
    reset_albums_table
  end

  describe '#all' do
    it 'shows a list of all albums' do
      repo = AlbumRepository.new

      albums = repo.all

      expect(albums.length).to eq 2

      expect(albums.first.id).to eq 1
      expect(albums.first.title).to eq 'Vavel'
      expect(albums.first.release_year).to eq 2016
      expect(albums.first.artist_id).to eq 2
    end
  end

  describe '#find' do
    it 'shows the album with the id 1' do
      repo = AlbumRepository.new

      album = repo.find(1)

      expect(album.id).to eq 1
      expect(album.title).to eq 'Vavel'
      expect(album.release_year).to eq 2016
      expect(album.artist_id).to eq 2
    end

    it 'shows the album with the id 2' do
      repo = AlbumRepository.new

      album = repo.find(2)

      expect(album.id).to eq 2
      expect(album.title).to eq 'Klima Tropiko'
      expect(album.release_year).to eq 1996
      expect(album.artist_id).to eq 1
    end
  end
 
end