require_relative '../lib/file_reader'

describe 'FileReader' do
  let(:filename) { File.join(File.dirname(__FILE__), 'fixtures/production.log') }

  it 'should be a FileReader' do
    expect(FileReader.new(filename)).to be_a FileReader
  end

  it 'should be able to read a file' do
    expect(FileReader.new(filename).readnext).to eq("/products 100.114.232.150\r\n")
  end

  it 'should be able to read two lines of a file' do
    file = FileReader.new(filename)
    file.readnext
    expect(file.readnext).to eq("/faq 102.38.137.231\r\n")
  end
end