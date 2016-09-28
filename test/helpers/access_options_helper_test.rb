require 'test_helper'

class AccessOptionsHelperTest < ActionView::TestCase
  setup :initialize_vars

  test "full text access link is parseable HTML" do
    assert Nokogiri::HTML.parse(display_fulltext_access_link('http://linnbenton.edu'))
  end
  test "full text access link is a link" do
    assert !(display_fulltext_access_link('http://linnbenton.edu') !~ /<a\b[^>]*>(.*?)<\/a>/i)
  end
  test "access options for documents with url_fulltext_display is parseable HTML" do
    assert Nokogiri::HTML.parse(display_access_options( @short_document ))
  end
  test "access options for documents with url_fulltext_display is a link" do
    assert !(display_access_options(@short_document) !~ /<a\b[^>]*>(.*?)<\/a>/i)
  end
  test "concise access options for documents with url_fulltext_display is parseable HTML" do
    assert Nokogiri::HTML.parse(display_concise_access_options( @short_document ))
  end
  test "concise access options for documents with url_fulltext_display is a link" do
    assert !(display_concise_access_options(@short_document) !~ /<a\b[^>]*>(.*?)<\/a>/i)
  end

  test "mode_of_access is correct for eg documents" do
    assert_equal 'library_holdings', mode_of_access(@long_document)
  end
  test "mode_of_access is correct for e-resource documents" do
    assert_equal 'url', mode_of_access(@short_document)
  end

  private
  def initialize_vars
    create_solr_documents
    @long_document['eg_tcn_t'] = '1234'
    @short_document['url_fulltext_display'] = 'http://duckduckgo.com'
  end
end
