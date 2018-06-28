# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  cinema_id  :integer
#  open       :boolean          default(TRUE)
#  time       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
