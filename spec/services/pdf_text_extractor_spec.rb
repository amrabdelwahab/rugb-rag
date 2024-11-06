require 'rails_helper'

RSpec.describe PdfTextExtractor, type: :service do
  let(:file) { instance_double(ActiveStorage::Blob) }
  subject { described_class.new(file: file).call }

  before do
     allow(file)
      .to receive(:download)
      .and_return(File.read(Rails.root.join("spec/fixtures/sample.pdf")))
  end

  it { is_expected.to eq "This is just a sample pdf."}
end
