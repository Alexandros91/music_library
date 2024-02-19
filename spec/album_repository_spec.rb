require 'album_repository'

RSpec.describe AlbumRepository do

  def reset_albums_table
    seed_sql = File.read('seeds/albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
  
  before(:each) do 
    reset_albums_table
  end

  describe '#all' do

    it 'returns all albums' do

      repo = AlbumRepository.new

      albums = repo.all
      expect(albums.length).to eq 4

      expect(albums[0].id).to eq 1
      expect(albums[0].title).to eq 'Klima Tropiko'
      expect(albums[0].release_year).to eq '1996'
      expect(albums[0].artist_id).to eq '1'

      expect(albums[1].id).to eq 2
      expect(albums[1].title).to eq 'Vavel'
      expect(albums[1].release_year).to eq '2015'
      expect(albums[1].artist_id).to eq '2'

      expect(albums[2].id).to eq 3
      expect(albums[2].title).to eq 'I Epochi Tou Therismou'
      expect(albums[2].release_year).to eq '2020'
      expect(albums[2].artist_id).to eq '2'

      expect(albums[3].id).to eq 4
      expect(albums[3].title).to eq 'Kitrino Galazio'
      expect(albums[3].release_year).to eq '1980'
      expect(albums[3].artist_id).to eq '1'
    end

    describe '#find' do
      it 'returns Klima Tropiko as a single album' do
        repo = AlbumRepository.new
        album = repo.find(1)

        expect(album.id).to eq 1
        expect(album.title).to eq 'Klima Tropiko'
        expect(album.release_year).to eq '1996'
        expect(album.artist_id).to eq'1'
      end

      it 'returns Vavel as a single album' do
        repo = AlbumRepository.new
        album = repo.find(2)

        expect(album.id).to eq 2
        expect(album.title).to eq 'Vavel'
        expect(album.release_year).to eq '2015'
        expect(album.artist_id).to eq'2'
      end

      it 'returns I Epochi Tou Therismou as a single album' do
        repo = AlbumRepository.new
        album = repo.find(3)

        expect(album.id).to eq 3
        expect(album.title).to eq 'I Epochi Tou Therismou'
        expect(album.release_year).to eq '2020'
        expect(album.artist_id).to eq'2'
      end

      it 'returns Kitrino Galazio as a single album' do
        repo = AlbumRepository.new
        album = repo.find(4)

        expect(album.id).to eq 4
        expect(album.title).to eq 'Kitrino Galazio'
        expect(album.release_year).to eq '1980'
        expect(album.artist_id).to eq'1'
      end
    end

    describe '#create' do
      it 'creates Revolver as a new album' do
        repo = AlbumRepository.new
        
        album = Album.new
        album.title = 'Revolver'
        album.release_year = 1966
        album.artist_id = 3
        
        repo.create(album)
        albums = repo.all
        
        expect(albums.length).to eq 5
        expect(albums.last.id).to eq 5
        expect(albums.last.title).to eq 'Revolver'
        expect(albums.last.release_year).to eq "1966"
        expect(albums.last.artist_id).to eq "3"
      end
    end
  end
end