require 'rails_helper'

RSpec.describe Nps, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:touchpoint) }
    it { is_expected.to validate_presence_of(:score) }
    it do
      is_expected.to validate_inclusion_of(:score).
        in_range(0..10).
        with_message('must be a number between 0 and 10')
    end
  end
end
