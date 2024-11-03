# spec/models/document_spec.rb
require 'rails_helper'

RSpec.describe Document, type: :model do
  let(:document) { Document.new(name: "Sample Document") }

  context "validations" do
    it "is valid with a name and an attached file" do
      document.file.attach(
        io: File.open(Rails.root.join("spec/fixtures/sample.pdf")),
        filename: "sample.pdf",
        content_type: "application/pdf"
      )

      expect(document).to be_valid
    end

    it "is invalid without a name" do
      document.name = nil
      expect(document).to_not be_valid
    end

    it "is invalid without an attached file" do
      expect(document).to_not be_valid
    end
  end
end