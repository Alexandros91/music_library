require_relative './../app'

RSpec.describe Application do
  describe '#run' do
    context 'when the user types 1' do
      it 'prints the list of albums' do
        album_repository = double :album_repository
        allow(album_repository).to receive(:all).and_return([
          double(id: 1, title: 'Klima Tropiko'),
          double(id: 2, title: 'Vavel'),
          double(id: 3, title: 'I Epochi Tou Therismou'),
          double(id: 4, title: 'Kitrino Galazio'),
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
        expect(io).to receive(:puts).with ' * 1 - Klima Tropiko'
        expect(io).to receive(:puts).with ' * 2 - Vavel'
        expect(io).to receive(:puts).with ' * 3 - I Epochi Tou Therismou'
        expect(io).to receive(:puts).with ' * 4 - Kitrino Galazio'
        app = Application.new('music_library_test', io, album_repository, artist_repository)
        app.run
      end
    end

    context 'when the user types 2' do
      it 'prints the list of artists' do
        album_repository = double :album_repository
        artist_repository = double :artist_repository
        allow(artist_repository).to receive(:all).and_return([
        double(id: 1, name: 'Anna Vissi'),
        double(id: 2, name: 'Natassa Mpofiliou'),
        ])
        io = double :io
        expect(io).to receive(:puts).with "Welcome to the music library manager!\n"
        expect(io).to receive(:puts).with 'What would you like to do?'
        expect(io).to receive(:puts).with ' 1 - List all albums'
        expect(io).to receive(:puts).with ' 2 - List all artists'
        expect(io).to receive(:print).with 'Enter your choice: '
        expect(io).to receive(:gets).and_return '2'
        expect(io).to receive(:puts).with 'Here is the list of artists:'
        expect(io).to receive(:puts).with ' * 1 - Anna Vissi'
        expect(io).to receive(:puts).with ' * 2 - Natassa Mpofiliou'
        app = Application.new('music_library_test', io, album_repository, artist_repository)
        app.run
      end
    end
  end
end