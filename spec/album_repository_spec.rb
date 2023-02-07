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

  describe '#create' do
    it 'adds a new album object to the repository' do
      repo = AlbumRepository.new
      new_album = Album.new
      new_album.id = 3
      new_album.title = 'O metoikos'
      new_album.release_year = 1971
      new_album.artist_id = 4
      repo.create(new_album)
      albums = repo.all

      expect(albums.length).to eq 3
      expect(albums.last.id).to eq 3
      expect(albums.last.title).to eq 'O metoikos'
      expect(albums.last.release_year).to eq 1971
      expect(albums.last.artist_id).to eq 4
    end

    it 'adds multiple album objects to the repository' do
      repo = AlbumRepository.new

      new_album_1 = Album.new
      new_album_1.id = 3
      new_album_1.title = 'O metoikos'
      new_album_1.release_year = 1971
      new_album_1.artist_id = 4

      new_album_2 = Album.new
      new_album_2.id = 4
      new_album_2.title = 'I agapi einai zali'
      new_album_2.release_year = 1986
      new_album_2.artist_id = 3

      repo.create(new_album_1)
      repo.create(new_album_2)
      albums = repo.all

      expect(albums.length).to eq 4
      expect(albums.last.id).to eq 4
      expect(albums.last.title).to eq 'I agapi einai zali'
      expect(albums.last.release_year).to eq 1986
      expect(albums.last.artist_id).to eq 3
    end

    describe '#update' do
      it 'updates an existing album' do
        repo = AlbumRepository.new
        album = repo.find(1)
        album.title = 'Antidoto'
        album.release_year = 1998
        album.artist_id = 1

        repo.update(album)
        updated_album = repo.find(1)

        expect(updated_album.title).to eq 'Antidoto'
        expect(updated_album.release_year).to eq 1998
        expect(updated_album.artist_id).to eq 1
      end

      it 'updates some values of an existing album' do
        repo = AlbumRepository.new
        album = repo.find(1)
        album.title = 'I epoxi tou therismou'
        album.release_year = 2020

        repo.update(album)
        updated_album = repo.find(1)

        expect(updated_album.title).to eq 'I epoxi tou therismou'
        expect(updated_album.release_year).to eq 2020
        expect(updated_album.artist_id).to eq 2
      end
    end


  end
 
end