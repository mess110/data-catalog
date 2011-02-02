# encoding: UTF-8
require 'csv'
require 'json'
require 'nokogiri'
require 'open-uri'

module ImporterUtility

  # == URLs ==

  def self.absolute_url(base_url, url)
    URI.parse(base_url).merge(url).to_s
  end

  def self.normalize_url(url)
    uri = URI.parse(url).normalize
    unless uri.scheme
      uri = URI.parse("http://#{url}").normalize
    end
    uri.to_s
  end

  # == Cleaning ==
  
  def self.single_line_clean(s)
    s.gsub(/[\r\n\t]/, ' ').squeeze(' ').strip
  end

  def self.multi_line_clean(s)
    s.squeeze(' ').strip
  end

  # Note: earlier iterations of importer utilities (for Ruby 1.8) would
  # commonly use the following code to get rid of "not understood"
  # characters. Now that I've read more about character encodings, I realize
  # that doing this was probably just a hack.
  #
  #   s.gsub(/[\x80-\xFF]/, '')

  # == Fetching ==

  def self.fetch(uri, options = {})
    quiet = options.delete(:quiet) || true
    encoding = options.delete(:encoding) || "UTF-8"
    puts "Fetching #{uri}..." unless quiet
    c = Curl::Easy.perform(uri) do |curl|
      curl.headers["User-Agent"] = "National Data Catalog Importer/2.0.0"
      curl.verbose = !quiet
    end
    c.body_str.force_encoding(encoding)
  end

  def self.remove_fetch_options(options = {})
    [:quiet, :encoding].each do |opt|
      options.delete(opt)
    end
  end

  # == Parsing ===

  def self.parse_file_or_uri(format, file, uri, options = {})
    force_fetch = options.delete(:force_fetch) || false
    if force_fetch || !File.exist?(file)
      parse_uri(format, uri, options)
    else
      remove_fetch_options(options)
      parse_file(format, file, options)
    end
  end

  def self.parse_file(format, file, options = {})
    File.open(file) { |f| parse(f.read, options) }
  end

  def self.parse_uri(format, uri, options = {})
    parse(fetch(uri, options), options)
  end

  def self.parse(data, options = {})
    case format
    when :csv  ; CSV.parse(data, options)
    when :xml  ; Nokogiri::XML::Document.parse(data)
    when :json ; JSON.parse(data)
    when :html ; Nokogiri::HTML::Document.parse(data)
    else raise "Unexpected format : #{format.inspect}"
    end
  end

  # == YAML

  # To load YAML use: YAML::load_file(file)

  def self.write_yaml(file, contents)
    File.open(file, 'w') { |f| YAML::dump(contents, f) }
  end

end
