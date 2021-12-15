# frozen_string_literal: true

RSpec.describe ResourceStruct do
  it "has a version number" do
    expect(ResourceStruct::VERSION).not_to be nil
  end
end
