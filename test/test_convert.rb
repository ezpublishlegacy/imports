require './lib/inports'
Bundler.require(:test)

class TestConvert < MiniTest::Unit::TestCase
  include Convert

  def setup
    file = File.open('./test/mocks/example_source_content.htm')
    @converted = to_ezp file.read
  end


  def test_returns_a_string
    assert_kind_of String, @converted
  end


  def test_carriage_returns_stripped_from_output
    refute_match /&#13;/, @converted
  end


  def test_title_is_removed
    refute_match '<title>Technology Curriculum Support: Introduction</title>', @converted
  end


  def test_top_level_heading_is_removed
    refute_match '<p class="header">Technology Curriculum Support</p>', @converted
  end


  def test_em_converted_to_emphasize
    refute_match '<em>', @converted
    assert_match '<emphasize>', @converted
  end


  def test_strong_remain
    assert_match '<strong>', @converted
  end


  def test_lists_remain
    assert_match '<ul>', @converted
    assert_match '<li>', @converted
  end


  def test_glossary_box_to_tag
    refute_match '<div class="glossarybox">', @converted
    assert_match '<custom name="glossarybox">', @converted
  end


  def test_p_to_paragraph
    refute_match '<p>', @converted
    assert_match '<paragraph>', @converted
  end


  def test_subheads_to_level_2_heading
    refute_match '<p class="subhead">Introduction</p>', @converted
    assert_match '<heading level="2">Introduction</heading>', @converted
  end


  def test_anchor_endpoints_to_anchor
    refute_match '<a name="curriculum" id="curriculum">', @converted
    assert_match '<anchor name="curriculum">', @converted
  end


  def test_a_to_link_for_unproblematic_links
    refute_match '<a href="#', @converted
    refute_match '<a href="http', @converted
    refute_match '<a href="mailto', @converted

    assert_match '<link href="#', @converted
    assert_match '<link href="http', @converted
    assert_match '<link href="mailto', @converted
  end


  def test_subsubhead_converted_to_heading3
    refute_match '<p class="subsubhead">', @converted
    assert_match '<heading level="3">', @converted
  end


  def test_heading_converted_without_redundant_strong
    refute_match %r{<heading level="3">\n?<strong>}, @converted
    refute_match %r{<heading level="2">\n?<strong>}, @converted
  end


  def test_no_empty_paragraphs
    refute_match %r{<paragraph>\s*<\/paragraph>}, @converted
  end
end
