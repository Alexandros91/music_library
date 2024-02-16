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

end