require_relative '../app.rb'

RSpec.describe Application do

  def reset_albums_table
    seed_sql = File.read('spec/seeds_albums.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end
  
  
  before(:each) do 
    reset_albums_table
  end

  def reset_artists_table
    seed_sql = File.read('spec/seeds_artists.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
    connection.exec(seed_sql)
  end

  before(:each) do 
    reset_artists_table
  end

  subject(:application) { described_class.new('music_library_test', io, AlbumRepository.new, ArtistRepository.new)}
  describe '#initialize' do
    it 'constructs' do
      expect(Application).to respond_to(:new).with(4).arguments
    end
  end

  describe '#run' do
    it 'asks for the number 1 and returns a list of all albums' do
      io = double :io
      expect(io).to receive(:puts).with("Welcome to the music library manager! \n\nWhat would you like to do? \n  1 - List all albums \n  2 - List all artists \n\n")
      expect(io).to receive(:print).with("Enter your choice: ")
      expect(io).to receive(:gets).and_return('1')

      expect(io).to receive(:puts).with(" \nHere is the list of albums:")
      expect(io).to receive(:puts).with(" * 1 - Vavel")
      expect(io).to receive(:puts).with(" * 2 - Klima Tropiko")

      application = Application.new('music_library_test', io, AlbumRepository.new, ArtistRepository.new)
      application.run
    end

    it 'asks for the number 2 and returns a list of all artists' do
      io = double :io
      expect(io).to receive(:puts).with("Welcome to the music library manager! \n\nWhat would you like to do? \n  1 - List all albums \n  2 - List all artists \n\n")
      expect(io).to receive(:print).with("Enter your choice: ")
      expect(io).to receive(:gets).and_return('2')

      expect(io).to receive(:puts).with(" \nHere is the list of artists:")
      expect(io).to receive(:puts).with(" * 1 - Anna Vissi")
      expect(io).to receive(:puts).with(" * 2 - Natassa Mpofiliou")

      application = Application.new('music_library_test', io, AlbumRepository.new, ArtistRepository.new)
      application.run
    end

    it 'raise an error if input is neither 1 or 2' do
      io = double :io
      expect(io).to receive(:puts).with("Welcome to the music library manager! \n\nWhat would you like to do? \n  1 - List all albums \n  2 - List all artists \n\n")
      expect(io).to receive(:print).with("Enter your choice: ")
      expect(io).to receive(:gets).and_return('albums')
      application = Application.new('music_library_test', io, AlbumRepository.new, ArtistRepository.new)
      expect { application.run }.to raise_error 'Enter either "1" or "2" to view albums or artists'
    end
  end
end