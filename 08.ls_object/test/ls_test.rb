# frozen_string_literal: true

require 'minitest/autorun'
require '~/ruby-practices/08.ls_object/bin/main'

class LsCommandTest < Minitest::Test
  TARGET_PATHNAME = Pathname('~/ruby-practices/08.ls_object/test')
  WIDTH = 80

  def test_run_ls
    expected = <<~TEXT.chomp
      12345                aa                   defghijk
      123456789            aaa                  derectory
      9999                 aaaa                 ls_test.rb
      AAAAAAAAAAAAAAA      aaaaa                practice_taiyaki.rb
      Yusuke               abc
      a                    bowling.rb
    TEXT
    assert_equal expected, LsCommandExecution.new(TARGET_PATHNAME).run_ls
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
    assert_equal expected, LsCommandExecution.new(TARGET_PATHNAME, reverse: true).run_ls
  end

  def test_run_ls_dot_much
    expected = <<~TEXT.chomp
      .                    Yusuke               abc
      ..                   a                    bowling.rb
      12345                aa                   defghijk
      123456789            aaa                  derectory
      9999                 aaaa                 ls_test.rb
      AAAAAAAAAAAAAAA      aaaaa                practice_taiyaki.rb
    TEXT
    assert_equal expected, LsCommandExecution.new(TARGET_PATHNAME, dot_match: true).run_ls
  end

  def test_run_ls_long_format
    expected = <<~TEXT.chomp
      total 32
      -rw-r--r--  1 yusuke  staff     0  6 22 17:34 12345
      -rw-r--r--  1 yusuke  staff     0  6 22 17:34 123456789
      -rw-r--r--  1 yusuke  staff     0  6 22 17:34 9999
      -rw-r--r--  1 yusuke  staff     0  6 21 22:35 AAAAAAAAAAAAAAA
      -rw-r--r--  1 yusuke  staff     0  6 21 22:35 Yusuke
      -rw-r--r--  1 yusuke  staff     0  6 21 22:34 a
      -rw-r--r--  1 yusuke  staff     0  6 21 22:34 aa
      -rw-r--r--  1 yusuke  staff     0  6 21 22:34 aaa
      -rw-r--r--  1 yusuke  staff     0  6 21 22:34 aaaa
      -rw-r--r--  1 yusuke  staff     0  6 21 22:34 aaaaa
      -rw-r--r--  1 yusuke  staff     0  6 22 17:35 abc
      -rw-r--r--  1 yusuke  staff   828  7  5 10:16 bowling.rb
      -rw-r--r--  1 yusuke  staff     0  6 21 22:34 defghijk
      -rw-r--r--  1 yusuke  staff     0  6 21 22:34 derectory
      -rw-r--r--  1 yusuke  staff  4216  7 11 19:45 ls_test.rb
      -rw-r--r--  1 yusuke  staff  1536  7  5 10:26 practice_taiyaki.rb
    TEXT
    # expected = `ls -l #{TARGET_PATHNAME}`.chomp
    assert_equal expected, LsCommandExecution.new(TARGET_PATHNAME, long_format: true).run_ls
  end

  def test_run_ls_all_options # rubocop:disable all
    expected = <<~TEXT.chomp
      total 32
      -rw-r--r--   1 yusuke  staff  1536  7  5 10:26 practice_taiyaki.rb
      -rw-r--r--   1 yusuke  staff  4216  7 11 19:45 ls_test.rb
      -rw-r--r--   1 yusuke  staff     0  6 21 22:34 derectory
      -rw-r--r--   1 yusuke  staff     0  6 21 22:34 defghijk
      -rw-r--r--   1 yusuke  staff   828  7  5 10:16 bowling.rb
      -rw-r--r--   1 yusuke  staff     0  6 22 17:35 abc
      -rw-r--r--   1 yusuke  staff     0  6 21 22:34 aaaaa
      -rw-r--r--   1 yusuke  staff     0  6 21 22:34 aaaa
      -rw-r--r--   1 yusuke  staff     0  6 21 22:34 aaa
      -rw-r--r--   1 yusuke  staff     0  6 21 22:34 aa
      -rw-r--r--   1 yusuke  staff     0  6 21 22:34 a
      -rw-r--r--   1 yusuke  staff     0  6 21 22:35 Yusuke
      -rw-r--r--   1 yusuke  staff     0  6 21 22:35 AAAAAAAAAAAAAAA
      -rw-r--r--   1 yusuke  staff     0  6 22 17:34 9999
      -rw-r--r--   1 yusuke  staff     0  6 22 17:34 123456789
      -rw-r--r--   1 yusuke  staff     0  6 22 17:34 12345
      drwxr-xr-x   7 yusuke  staff   224  7 11 12:39 ..
      drwxr-xr-x  18 yusuke  staff   576  7 11 12:39 .
    TEXT
    # expected = `ls -lar #{TARGET_PATHNAME}`.chomp
    assert_equal expected, LsCommandExecution.new(TARGET_PATHNAME, long_format: true, reverse: true, dot_match: true).run_ls
  end
end
