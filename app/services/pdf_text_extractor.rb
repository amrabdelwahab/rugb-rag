class PdfTextExtractor
  def initialize(file:)
    @file = file
  end

  def call
    text = ""
    io = StringIO.new(@file.download) 
    
    PDF::Reader.new(io).pages.each do |page|

      text += page.text
    end
    text
  end
end