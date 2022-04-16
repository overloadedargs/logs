require "base64"

class LogParser

  attr_reader :log

  def initialize
    @filereader = FileReader.new('spec/fixtures/production.log')
    @line = @filereader.readnext.split(' ')
    @log = Hash.new()
    @ip_log = Hash.new()
    @page_views = Hash.new()
  end

  def process_log
    begin
      while @line do
        @page_views[uri.to_sym] = @page_views.fetch(uri.to_sym, 0) + 1
        
        @log[encoded_uri] = [] unless @log[encoded_uri]
        @ip_log[ip_address] = [] unless @ip_log[ip_address]

        @log[encoded_uri] << ip_address unless has_hit?(ip_address, encoded_uri)
        @ip_log[ip_address] << uri unless has_hit?

        @line = @filereader.readnext.split(' ')
      end
      rescue StopIteration => e
        return @log
    end
  end

  def has_hit?(ip = ip_address, url = encoded_uri)
    @ip_log[ip].include?(uri)
  end

  def has_url?(ip = ip_address, url = encoded_uri)
    @log[url].include?(ip)
  end

  def sorted_views
    @page_views.sort_by { |_,v| v }.reverse
  end

  def unique_views
    (@log.map { |k,v| [Base64.decode64(k), v.length] }.to_h).sort_by { |_,v| v }.reverse
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