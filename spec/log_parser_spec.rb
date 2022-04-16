require_relative '../lib/log_parser'
require 'base64'

describe 'LogParser' do

  it 'should be a LogParser' do
    expect(LogParser.new).to be_a LogParser
  end

  it 'should be able to create a unique hash of the link' do
    expect(LogParser.new.encoded_uri).to eq(Base64.encode64('/products'))
  end

  it 'should be able to create a unique hash of the link' do
    expect(LogParser.new.uri).to eq('/products')
  end

  it 'should be able to extract the ip address' do
    expect(LogParser.new.ip_address).to eq('100.114.232.150')
  end

  context 'processing_log' do

    describe '.has_hit?' do
      it 'should be able to check if there is a hit' do
        log_parser = LogParser.new
        log_parser.process_log
        expect(log_parser.has_hit?('233.57.149.50', Base64.encode64('/about'))).to be true
      end
    end

    describe '.has_url?' do
      it 'should be able to check if an ip went to a url' do
        log_parser = LogParser.new
        log_parser.process_log
        expect(log_parser.has_url?('123.233.150.93', Base64.encode64('/products'))).to be true
      end
    end
  end

  context 'page views' do
    describe '.page_views?' do
      it 'should be able to get the page views' do
        log_parser = LogParser.new
        log_parser.process_log
        expect(log_parser.page_views('/products')).to eq(80)
      end
    end
  end

  describe '.sorted_views' do
    it 'should be able to get the max page views' do
      log_parser = LogParser.new
      log_parser.process_log
      views = [[:"/deals", 90], [:"/faq", 89], [:"/support", 82], [:"/about", 81], [:"/products", 80], [:"/home", 78]]
      expect(log_parser.sorted_views).to eq(views)
    end
  end

  context '.unique_views' do
    it 'should be able to get the sorted page views' do
      log_parser = LogParser.new
      log_parser.process_log
      unique_views = [["/support", 23], ["/home", 23], ["/faq", 23], ["/products", 23], ["/deals", 22], ["/about", 21]]
      expect(log_parser.unique_views).to eq(unique_views)
    end
  end
end