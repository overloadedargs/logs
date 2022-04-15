require "base64"

class LogParser
  def initialize
    @filereader = FileReader.new('spec/fixtures/production.log')
    @line = @filereader.readnext.split(' ')
    @log = Hash.new([])
    @ip_log = Hash.new([])
    @page_views = Hash.new()
  end

  def has_hit?(ip = ip_address)
    @ip_log[ip].include?(uri)
  end

  def has_url?(url = encoded_uri)
    @log[url].include?(ip_address)
  end

  def process_log
    begin
      while @line do
        @page_views[uri.to_sym] = @page_views.fetch(uri.to_sym, 0) + 1
        @ip_log[ip_address] << uri unless has_hit?
        @log[encoded_uri] << ip_address unless has_url?
        @line = @filereader.readnext.split(' ')
      end
      rescue StopIteration => e
        return @log
    end
  end

  def sorted_views
    @page_views.sort_by { |_,v| v }.reverse
  end

  def page_views(uri)
    @page_views[uri.to_sym]
  end

  def encoded_uri
    Base64.encode64(uri)
  end

  def uri
    @line.first.gsub('\n','')
  end

  def ip_address
    @line.last
  end
end