FactoryBot.define do
  factory :np, class: 'Nps' do
    touchpoint { 'realtor_feedback' }
    object_id { 1 }
    object_class { 'realtor' }
    respondent_id { 1 }
    respondent_class { 'seller' }
    score { 3 }
  end
end
