require 'oai' 

class Udk
  def initialize()
    @uri = URI("https://opus4.kobv.de/opus4-udk/oai") #?verb=GetRecord&metadataPrefix=oai_dc&set=doc-type:noten")
    @client = OAI::Client.new @uri.to_s
    @xml_str = ''
  end

  def listRecords
    @client.list_records 
  end

  def resume
    @client.list_records(:resumption_token => listRecords.resumption_token)
  end

  def get_first_page
    @xml_str = ''
    listRecords.each do |record| 
      @xml_str = [@xml_str, record.metadata.to_s].join
    end
    @xml_str
  end

  def get_all
    @xml_str = ''
    listRecords.full.entries do |record|
      @xml_str = [@xml_str, record.metadata.to_s].join
    end
    @xml_str
  end

  def get_scores
    @xml_str = ''
    @client.list_records(opts={"set"=>"doc-type:noten"}).full.entries.each do |record| 
      @xml_str = [@xml_str, record.metadata.to_s].join 
    end
    @xml_str
  end

  def get_scores_nonDoc
    @xml_str = ''
    @client.list_records(opts={"set"=>"noten"}).full.entries.each do |record| 
      @xml_str = [@xml_str, record.metadata.to_s].join 
    end
    @xml_str
  end

  def write(filename)
    f = File.open(filename, 'w')
    f.write(@xml_str)
    f.close
  end
end
