require 'artist_repository'

RSpec.describe ArtistRepository do

  def reset_artists_table
    seed_sql = File.read('spec/seeds_artists.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_artists_table
  end
  

  describe '#all' do
    it 'shows a list of all artists' do
      repo = ArtistRepository.new

      artists = repo.all

      expect(artists.length).to eq 2
      expect(artists.first.id).to eq 1
      expect(artists.first.name).to eq 'Anna Vissi'
      expect(artists.first.genre).to eq 'Pop'
    end
  end

  describe '#find' do
    it 'returns Anna Vissi as single artist' do
      repo = ArtistRepository.new

      artist = repo.find(1)

      expect(artist.id).to eq 1
      expect(artist.name).to eq 'Anna Vissi'
      expect(artist.genre).to eq 'Pop'
    end

    it 'returns Natassa Mpofiliou as single artist' do
      repo = ArtistRepository.new

      artist = repo.find(2)

      expect(artist.id).to eq 2
      expect(artist.name).to eq 'Natassa Mpofiliou'
      expect(artist.genre).to eq 'Entexno'
    end
  end

  describe '#create' do
    it 'adds Xaris Alexiou as a new artist in the artists table' do
      repo = ArtistRepository.new
      new_artist = Artist.new
      new_artist.name = 'Xaris Alexiou'
      new_artist.genre = 'Laiko'
      repo.create(new_artist)
      artists = repo.all

      expect(artists.length).to eq 3
      expect(artists.last.id).to eq 3
      expect(artists.last.name).to eq 'Xaris Alexiou'
      expect(artists.last.genre).to eq 'Laiko'
    end

    it 'adds Giorgos Ntalaras as another artist in the artists table' do
      repo = ArtistRepository.new
      new_artist_1 = Artist.new
      new_artist_1.name = 'Xaris Alexiou'
      new_artist_1.genre = 'Laiko'
      repo.create(new_artist_1)
      new_artist_2 = Artist.new
      new_artist_2.name = 'Giorgos Ntalaras'
      new_artist_2.genre = 'Rempetiko'
      repo.create(new_artist_2)
      artists = repo.all

      expect(artists.length).to eq 4
      expect(artists.last.id).to eq 4
      expect(artists.last.name).to eq 'Giorgos Ntalaras'
      expect(artists.last.genre).to eq 'Rempetiko'
    end
  end

  describe '#update' do
    it 'updates the values of the first artist' do
      repo = ArtistRepository.new
      artist = repo.find(1)
      artist.name = 'Anna Vissy'
      artist.genre = 'Elafrolaiko'
      repo.update(artist)

      updated_artist = repo.find(1)

      expect(updated_artist.name).to eq 'Anna Vissy'
      expect(updated_artist.genre).to eq 'Elafrolaiko'
    end

    it 'updates the values of the second artist' do
      repo = ArtistRepository.new
      artist = repo.find(2)
      artist.genre = 'Mpalantes'
      repo.update(artist)

      updated_artist = repo.find(2)
      
      expect(updated_artist.name).to eq 'Natassa Mpofiliou'
      expect(updated_artist.genre).to eq 'Mpalantes'
    end
  end
end
