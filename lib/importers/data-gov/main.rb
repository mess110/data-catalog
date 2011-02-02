class Importers
  class DataGov
    INDEX_URL = 'http://www.data.gov/catalog/raw/category/0/agency/0/filter//type//sort//page/1/count/99999#data'
    CACHED_INDEX_FILE = File.expand_path('../index.html', __FILE__)
    DATA_SETS_FILE = File.expand_path('../data_sets.yml', __FILE__)

    def self.fetch
      contents = ImporterUtility.fetch(INDEX_URL)
      File.open(CACHED_INDEX_FILE, 'w') { |f| f.write(contents) }
    end

    def self.process
      document = ImporterUtility.parse_file(:html, CACHED_INDEX_FILE)
      data_sets = get_data_sets(document)
      ImporterUtility.write_yaml(DATA_SETS_FILE, rows)
    end

    def self.store
      DataLoader.new(
        :model_path => File.expand_path('..', __FILE__),
        :verbosity  => 1
      ).run
    end

    # ---

    def self.get_data_sets(parsed_document)
      rows = parsed_document.css('table#tblInstant > tbody > tr')
      raise "Expecting more than 1000 datasets" if rows < 1000
      metadata = rows.map do |row|
        cells = row.css('td')

        formats = {}
        add_format(formats, :xml,       cells[3])
        add_format(formats, :csv,       cells[4]) # 'csv/txt'
        add_format(formats, :kml,       cells[5]) # 'kml/kmv'
        add_format(formats, :shapefile, cells[6])
        add_format(formats, :maps,      cells[7])
        add_format(formats, :other,     cells[8])

        href = cells[0].css('a').first['href']
        {
          :uid     => uid_from_uri(href),
          :href    => full_uri(href),
          :title   => U.single_line_clean(cells[0].css('a').first.content),
          :rating  => cells[1].css('img').first['alt'],
          :agency  => U.single_line_clean(cells[2].content),
          :formats => formats,
        }
      end
      metadata.sort do |a, b|
        a[:uid] <=> b[:uid]
      end
    end

    # Converts a URI into a Unique ID
    #
    #   For example:
    #   uid_from_uri("http://www.data.gov/details/954")
    #   => 954
    def self.uid_from_uri(uri)
      last_part = uri.split("/").last
      result = last_part.to_i
      if result == 0
        message = <<-BLOCK.outdent
          Could not make a non-zero Unique ID for this URI:
          #{uri}
        BLOCK
        raise Error, message
      end
      result
    end

  end
end
