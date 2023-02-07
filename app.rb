require_relative 'lib/database_connection'
require_relative 'lib/artist_repository'
require_relative 'lib/album_repository'

class Application

  def initialize(database_name, io, album_repository, artist_repository)
    DatabaseConnection.connect(database_name)
    @io = io
    @album_repository = album_repository
    @artist_repository = artist_repository
  end

  def run
    welcome_message
    response = @io.gets.chomp
    if response == '1'
      show_albums
    elsif response == '2'
     show_artists
    else
      error_message
    end

  end

  private 

  def welcome_message
    @io.puts "Welcome to the music library manager! \n\nWhat would you like to do? \n  1 - List all albums \n  2 - List all artists \n\n" 
    @io.print "Enter your choice: "
  end

  def show_albums
    @io.puts " \nHere is the list of albums:"
    @album_repository.all.each do |album|
      @io.puts " * #{album.id} - #{album.title}"
    end
  end

  def show_artists
    @io.puts " \nHere is the list of artists:"
    @artist_repository.all.each do |artist|
      @io.puts " * #{artist.id} - #{artist.name}"
    end
  end

  def error_message
    raise 'Enter either "1" or "2" to view albums or artists'
  end
end

if __FILE__== $0
  app = Application.new(
    'music_library',
    Kernel,
    AlbumRepository.new,
    ArtistRepository.new
  )
  app.run
end
