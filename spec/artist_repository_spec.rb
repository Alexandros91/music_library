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
end
