# spec/requests/documents_spec.rb
require 'rails_helper'


RSpec.describe "Documents", type: :request do
  let(:file) { fixture_file_upload(Rails.root.join("spec/fixtures/sample.pdf"), "application/pdf") }

  describe "GET /index" do
    it "returns a successful response and displays documents" do
      document = Document.create!(name: "Sample Document", file: file)
      get documents_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include(document.name)
    end
  end

  describe "POST /create" do
    it "creates a new document with the uploaded file", :aggregate_failures do
      expect {
        post documents_path, params: { document: { file: file } }
      }.to change(Document, :count).by(1).and change(Sidekiq::Queues["default"], :size).by(1)

      document = Document.last
      expect(document.name).to eq "sample"     
    end

    it "redirects to the index page after creating a document" do
      post documents_path, params: { document: { file: file } }
      expect(response).to redirect_to(document_path(Document.first))
    end
  end

  describe "GET /show" do
    let(:document) { Document.create!(name: "Sample Document", file: file) }

    it "returns a successful response and displays the document details" do
      get document_path(document, file: file)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(document.name)
    end
  end

  describe "DELETE /destroy" do
    let!(:document) { Document.create!(name: "Sample Document", file: file) }

    it "deletes the document" do
      expect {
        delete document_path(document)
      }.to change(Document, :count).by(-1)
    end

    it "redirects to the index page after deletion" do
      delete document_path(document)
      expect(response).to redirect_to(documents_path)
    end
  end
end
