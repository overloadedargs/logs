require "base64"

class UniqueLogParser
  def initialize
    @filereader = FileReader.new('spec/fixtures/production.log')
    @line = @filereader.readnext
    @log = Hash.new()
    @page_log = Hash.new()
  end

  def process_log
    begin
      while @line do
        hash = Base64.strict_encode64(@line.gsub('\r',''))

        @page_log[uri] = [] unless @page_log[uri] 
        @page_log[uri] << ip_address  unless @log.key?(hash)
        @log[hash] = @log.fetch(hash, 0) + 1
        
        @line = @filereader.readnext
      end
    rescue StopIteration => e
      return @page_log
    end
  end

  def unique_views
    @page_log.map { |log| [log.first, log.last.size] }.sort_by { |_,v| v }.reverse
  end

  def ip_address
    @line.split(' ').last
  end

  def uri
    @line.split(' ').first
  end
end