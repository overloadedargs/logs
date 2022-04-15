class FileReader
  def initialize(filename)
    @filename = filename
    @file = enumerator
  end

  def enumerator
    File.open(@filename).each_line.lazy
  end

  def readnext
    @file.next
  end
end