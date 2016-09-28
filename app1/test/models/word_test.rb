#require 'test_helper'

#class WordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
#end

def test_word_is_english_and_polish
  word = Word.new :eng=>'never', :pl=>'nigdy'
  assert_equal 'never', word.eng
  assert_equal 'nigdy', word.pl
end
