require_relative '../lib/unique_log_parser'
require 'base64'

describe 'UniqueLogParser' do
  context '.unique_views' do
    it 'should be able to get the sorted page views' do
      log_parser = UniqueLogParser.new
      log_parser.process_log
      unique_views = [["/support", 23], ["/home", 23], ["/faq", 23], ["/products", 23], ["/deals", 22], ["/about", 21]]
      expect(log_parser.unique_views).to eq(unique_views)
    end
  end
end