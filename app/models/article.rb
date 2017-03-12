# Journal and newspaper articles taken from an external API
class Article < SolrDocument
    attr_reader :abstract, :authors, :db, :id, :journal, :title, :type, :url, :year
    PROXY_PREFIX = 'http://ezproxy.libweb.linnbenton.edu:2048/login?url='

    def initialize
        @authors = []
        @type = 'Article'
        @db = 'cat'
        @id = 'cat'
        @title = 'cat'
        @url = 'http://cat.cat'
    end

    def extract_data_from_api_response record
        if record['PLink'] and record['RecordInfo']['BibRecord']['BibEntity']['Titles'].first['TitleFull']
            @title = record['RecordInfo']['BibRecord']['BibEntity']['Titles'].first['TitleFull']
            @url = PROXY_PREFIX + record['PLink']
            @db = record['Header']['DbId']
            @id = record['Header']['An']
            if record['Header']['PubType']
                @type = record['Header']['PubType']
            end
            extract_journal_name_from_api_response record
            if record['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].respond_to? :first
	        begin
                    @year = record['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].first['BibEntity']['Dates'].first['Y']
                rescue NoMethodError
                    @year = "Unknown year"
		end
            end
            if record['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships']
                record['RecordInfo']['BibRecord']['BibRelationships']['HasContributorRelationships'].each do |person|
                    @authors.push(person['PersonEntity']['Name']['NameFull'])
                end
            end
            record['Items'].each do |item|
                if 'Abstract' == item['Name']
                    @abstract = Nokogiri::HTML.parse(item['Data']).text
                end
            end
        end
    end

    private
    def extract_journal_name_from_api_response record
        begin
            @journal = record['RecordInfo']['BibRecord']['BibRelationships']['IsPartOfRelationships'].first['BibEntity']['Titles'].first['TitleFull']
        rescue NoMethodError
            @journal = "Unknown journal"	
        end
    end


end
