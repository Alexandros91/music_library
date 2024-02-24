require 'artist_repository'

RSpec.describe ArtistRepository do

  def reset_artists_table
    seed_sql = File.read('seeds/artists.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_artists_table
  end

  describe '#all' do
    it 'returns the list of artists' do
      repo = ArtistRepository.new
      
      artists = repo.all
      expect(artists.length).to eq 2
      
      expect(artists[0].id).to eq 1
      expect(artists[0].name).to eq 'Anna Vissi'
      expect(artists[0].genre).to eq 'Laiko'
      
      expect(artists[1].id).to eq 2
      expect(artists[1].name).to eq 'Natassa Mpofiliou'
      expect(artists[1].genre).to eq 'Entexno'
    end
  end

  describe '#find' do
    it 'returns Anna Vissi as single artist' do
      repo = ArtistRepository.new

      artist = repo.find(1)
      expect(artist.id).to eq  1
      expect(artist.name).to eq  'Anna Vissi'
      expect(artist.genre).to eq  'Laiko'
    end

    it 'returns Natassa Mpofiliou as single artist' do
      repo = ArtistRepository.new

      artist = repo.find(2)
      expect(artist.id).to eq  2
      expect(artist.name).to eq  'Natassa Mpofiliou'
      expect(artist.genre).to eq  'Entexno'
    end
  end

  describe '#create' do
    it 'creates Beatles as an artist' do
      repo = ArtistRepository.new

      new_artist = Artist.new
      new_artist.name = 'Beatles'
      new_artist.genre = 'Pop'

      repo.create(new_artist) # => nil

      artists = repo.all
      last_artist = artists.last
      expect(artists.length).to eq 3
      expect(last_artist.id).to eq 3
      expect(last_artist.name).to eq 'Beatles'
      expect(last_artist.genre).to eq 'Pop'
    end
  end

  describe '#delete' do
    it 'deletes the artist with id 1' do
      repo = ArtistRepository.new
      
      id_to_delete = 1
      repo.delete(id_to_delete)
      artists = repo.all

      first_artist = artists.first
      expect(artists.length).to eq 1
      expect(first_artist.id).to eq 2
      expect(first_artist.name).to eq 'Natassa Mpofiliou'
      expect(first_artist.genre).to eq 'Entexno'
    end

    it 'deletes both artists' do
      repo = ArtistRepository.new
      
      repo.delete(1)
      repo.delete(2)

      artists = repo.all
      expect(artists.length).to eq 0
    end
  end

  describe 'update' do
    it 'updates the Anna Vissi artist' do
      repo = ArtistRepository.new
      
      artist_to_update = repo.find(1)
      
      artist_to_update.name = 'Fake Artist'
      artist_to_update.genre = 'Fake Genre'

      repo.update(artist_to_update)
      updated_artist = repo.find(1)
      expect(updated_artist.name).to eq 'Fake Artist'
      expect(updated_artist.genre).to eq 'Fake Genre'
    end

    it 'updates only the name of Natassa Mpofiliou artist' do
      repo = ArtistRepository.new
      
      artist_to_update = repo.find(2)
      
      artist_to_update.name = 'Pseudo Artist'

      repo.update(artist_to_update)
      updated_artist = repo.find(2)
      expect(updated_artist.name).to eq 'Pseudo Artist'
      expect(updated_artist.genre).to eq 'Entexno'
    end
  end

  describe '#find_with_albums' do
    it 'returns an artist record qith their associated albums' do
      repo = ArtistRepository.new

      artist = repo.find_with_albums(1)

      expect(artist.id).to eq 1
      expect(artist.name).to eq 'Anna Vissi'
      expect(artist.genre).to eq 'Laiko'
      expect(artist.albums.length).to eq 2 
    end
  end
end