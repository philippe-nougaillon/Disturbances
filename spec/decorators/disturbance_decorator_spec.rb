# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisturbanceDecorator do
  let(:disturbance) { Disturbance.new.extend DisturbanceDecorator }
  subject { disturbance }
  it { should be_a Disturbance }
end
