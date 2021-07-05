# frozen_string_literal: true

require 'minitest/autorun'
require '~/ruby-practices/08.ls_object/lib/ls'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = Pathname('~/ruby-practices/08.ls_object/test/fixtures/sample_files')

  def test_run_ls
    expected = <<~TEXT.chomp
      12345                aa                   defghijk
      123456789            aaa                  derectory
      9999                 aaaa                 ls_test.rb
      AAAAAAAAAAAAAAA      aaaaa                practice_taiyaki.rb
      Yusuke               abc
      a                    bowling.rb
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 80)
  end

  def test_run_ls_reverse
    expected = <<~TEXT.chomp
      practice_taiyaki.rb  aaaaa                AAAAAAAAAAAAAAA
      ls_test.rb           aaaa                 9999
      derectory            aaa                  123456789
      defghijk             aa                   12345
      bowling.rb           a
      abc                  Yusuke
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 80, reverse: true)
  end

  def test_run_ls_dot_much
    expected = <<~TEXT.chomp
      ./                   Yusuke               abc
      ../                  a                    bowling.rb
      12345                aa                   defghijk
      123456789            aaa                  derectory
      9999                 aaaa                 ls_test.rb
      AAAAAAAAAAAAAAA      aaaaa                practice_taiyaki.rb
    TEXT
    assert_equal expected, run_ls(TARGET_PATHNAME, width: 80, dot_match: true)
  end

  def test_run_ls_long_format
    expected = `ls -l #{TARGET_PATHNAME}`.chomp
    assert_equal expected, run_ls(TARGET_PATHNAME, long_format: true)
  end

  def test_run_ls_all_options
    expected = `ls -lar #{TARGET_PATHNAME}`.chomp
    assert_equal expected, run_ls(TARGET_PATHNAME, long_format: true, reverse: true, dot_match: true)
  end
end
