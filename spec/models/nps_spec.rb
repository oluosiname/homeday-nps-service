require 'rails_helper'

RSpec.describe Nps, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:touchpoint) }
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_presence_of(:object_id) }
    it { is_expected.to validate_presence_of(:object_class) }
    it { is_expected.to validate_presence_of(:respondent_class) }
    it { is_expected.to validate_presence_of(:respondent_id) }
    it do
      is_expected.to validate_inclusion_of(:score).
        in_range(0..10).
        with_message('must be a number between 0 and 10')
    end
    context 'uniqueness validation' do
      subject { Nps.create(touchpoint: 'realtor-feedback') }
      it do
        is_expected.to validate_uniqueness_of(:score)
          .scoped_to([:touchpoint, :object_class, :object_id, :respondent_class, :respondent_id])
          .with_message('already recorded')
      end
    end
  end
end
