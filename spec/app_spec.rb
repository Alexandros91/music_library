require_relative './../app'

RSpec.describe Application do
  describe '#run' do
    context 'when the user types 1' do
      it 'prints the list of albums' do
        album_repository = double :album_repository
        allow(album_repository).to receive(:all).and_return([
          double(id: 1, title: 'Doolittle'),
          double(id: 2, title: 'Surfer Rosa'),
          double(id: 3, title: 'Waterloo'),
          double(id: 4, title: 'Super Trouper'),
          double(id: 5, title: 'Bossanova'),
          double(id: 6, title: 'Lover'),
          double(id: 7, title: 'Folklore'),
          double(id: 8, title: 'I Put a Spell on You'),
          double(id: 9, title: 'Baltimore'),
          double(id: 10, title: 'Here Comes the Sun'),
          double(id: 11, title: 'Fodder on My Wings'),
          double(id: 12, title: 'Ring Ring'),
        ])
        artist_repository = double :artist_repository
        io = double :io
        expect(io).to receive(:puts).with "Welcome to the music library manager!\n"
        expect(io).to receive(:puts).with 'What would you like to do?'
        expect(io).to receive(:puts).with ' 1 - List all albums'
        expect(io).to receive(:puts).with ' 2 - List all artists'
        expect(io).to receive(:print).with 'Enter your choice: '
        expect(io).to receive(:gets).and_return '1'
        expect(io).to receive(:puts).with 'Here is the list of albums:'
        expect(io).to receive(:puts).with ' * 1 - Doolittle'
        expect(io).to receive(:puts).with ' * 2 - Surfer Rosa'
        expect(io).to receive(:puts).with ' * 3 - Waterloo'
        expect(io).to receive(:puts).with ' * 4 - Super Trouper'
        expect(io).to receive(:puts).with ' * 5 - Bossanova'
        expect(io).to receive(:puts).with ' * 6 - Lover'
        expect(io).to receive(:puts).with ' * 7 - Folklore'
        expect(io).to receive(:puts).with ' * 8 - I Put a Spell on You'
        expect(io).to receive(:puts).with ' * 9 - Baltimore'
        expect(io).to receive(:puts).with ' * 10 - Here Comes the Sun'
        expect(io).to receive(:puts).with ' * 11 - Fodder on My Wings'
        expect(io).to receive(:puts).with ' * 12 - Ring Ring'
        app = Application.new('music_library_test', io, album_repository, artist_repository)
        app.run
      end
    end
  end
end