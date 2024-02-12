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

  it 'finds all albums' do

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
end