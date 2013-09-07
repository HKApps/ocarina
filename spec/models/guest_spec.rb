require 'spec_helper'

describe Guest do
  let(:guest) { FactoryGirl.build(:guest) }

  # Attributes
  it { should respond_to :user_id }
  it { should respond_to :playlist_id }

  # Associations
  it { should respond_to :user }
  it { should respond_to :playlist }
end
