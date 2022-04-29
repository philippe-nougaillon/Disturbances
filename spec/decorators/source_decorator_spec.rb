# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SourceDecorator do
  let(:source) { Source.new.extend SourceDecorator }
  subject { source }
  it { should be_a Source }
end
