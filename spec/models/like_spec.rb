require 'rails_helper'

RSpec.describe Like, type: :model do
  it { should belong_to(:likable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :rating }
  it { should validate_numericality_of(:rating).only_integer }
  it { should validate_inclusion_of(:rating).in_range(-1..1) }
end
