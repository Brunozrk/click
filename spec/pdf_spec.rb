describe "verifying pdfs" do
  it "you can create a pdf pretty easily" do
    pdf = Prawn::Document.new
    pdf.text Faker::Lorem.sentence
  end
  
  it "and then to verify you can render it to an inspector" do
    pdf = Prawn::Document.new
    pdf.text Faker::Lorem.sentence
    
    result = PDF::Inspector::Page.analyze(pdf.render)
    
    expect(result.pages.size).to eq 1
  end
  
  it "you can render it to a file if you like" do
    pdf = Prawn::Document.new
    pdf.text Faker::Lorem.sentence
    pdf.render_file "tmp/example.pdf"
  end
end

describe "paging pdfs" do
  it "when you add lots of lines, you get multiple pages (looks like by default you get 50 per page)" do
    pdf = Prawn::Document.new
    
    100.times {pdf.text Faker::Lorem.sentence}
    
    result = PDF::Inspector::Page.analyze(pdf.render)
    
    expect(result.pages.size).to eq 2
    expect(result.pages.size).to eq pdf.page_count
  end
  
  it "you can add page numbers" do
    pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :portrait)
    
    100.times {pdf.text Faker::Lorem.sentence}
    
    pdf.number_pages("<page> of <total>", {
      :start_count_at => 1,
      :page_filter => lambda{ |pg| pg > 0 },
      :at => [pdf.bounds.right - 50, 0],
      :align => :right,
      :size => 9
    })
    
  end
  
  it "you can then inspect and verify the page numbers are there" do
    pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :portrait)
    
    100.times {pdf.text Faker::Lorem.sentence}
    
    pdf.number_pages("<page> of <total>", {
      :start_count_at => 1,
      :page_filter => lambda{ |pg| pg > 0 },
      :at => [pdf.bounds.right - 50, 0],
      :align => :right,
      :size => 9
    })
    
    result = PDF::Inspector::Page.analyze(pdf.render)
    
    expect(result.pages.first[:strings].last).to eq "1 of 2"
  end
 
  class PageTextReceiver
    attr_accessor :content
  
    def initialize
      @content = []
    end
  
    def begin_page(arg = nil)
      @content << ""
    end
  
    # record text that is drawn on the page
    def show_text(string, *params)
      @content.last << string.strip
    end
  
    alias :super_show_text :show_text
    alias :move_to_next_line_and_show_text :show_text
    alias :set_spacing_next_line_show_text :show_text
  
    def show_text_with_positioning(*params)
      params = params.first
      params.each { |str| show_text(str) if str.kind_of?(String)}
    end
  end

  it "failing that (it is not stable), you can use PDF::Reader" do
    pdf = Prawn::Document.new
    pdf.text Faker::Lorem.sentence
    pdf.render_file "tmp/example.pdf"
    
    receiver = PageTextReceiver.new
    pdf = PDF::Reader.file("tmp/example.pdf", receiver)
    puts receiver.content.inspect
  end
end