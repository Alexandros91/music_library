require_relative '../app.rb'

RSpec.describe Application do
  describe '#run' do
    it 'outputs a welcome message' do
      io = double :io
      expect(io).to receive(:puts).with('Welcome to the music library manager!')

      application = Application.new('music_library_test', io, 'albums', 'artists')
      application.run
    end

    
  end
end