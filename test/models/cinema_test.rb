# == Schema Information
#
# Table name: cinemas
#
#  id         :integer          not null, primary key
#  name       :string
#  city_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  cite_index :integer
#

require 'test_helper'

class CinemaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
