require './lib/inports'
Bundler.require(:test)

class TestLogger < MiniTest::Unit::TestCase
  def teardown
    FileUtils.rm './log/just-testing.log'
  end


  def test_warning_creates_log_file_based_on_argument
    Logger.warning('somepath', 'just-testing')
    assert_includes Dir.glob('./log/*.log'), './log/just-testing.log'
  end


  def test_logfile_name_normalized
    Logger.warning('somepath', 'Just Testing')
    assert_includes Dir.glob('./log/*.log'), './log/just-testing.log'
  end


  def test_logfile_contains_paths
    Logger.warning('somepath', 'Just Testing')
    Logger.warning('anotherpath', 'Just Testing')

    file = File.open('./log/just-testing.log')
    contents = file.read

    exp = "somepath\nanotherpath\n"

    assert_equal contents, exp
  end
end
