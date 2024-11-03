# spec/jobs/process_document_job_spec.rb
require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline! # Run jobs immediately for testing

RSpec.describe ProcessDocumentJob, type: :job do
  let(:file) { fixture_file_upload(Rails.root.join("spec/fixtures/sample.pdf"), "application/pdf") }
  let(:document) { Document.create!(name: "Sample Document", file: file) }


  describe "#perform" do
    it "processes a document by chunking and generating embeddings" do
      # Mock the OpenAI API response for embedding generation
      allow_any_instance_of(OpenAI::Client).to receive(:embeddings).and_return({
        'data' => [{ 'embedding' => Array.new(1536) { rand } }]
      })

      expect {
        ProcessDocumentJob.perform_now(document.id)
      }.to change(DocumentChunk, :count).by_at_least(1)

      # Check that chunks are created and associated with the document
      document_chunks = DocumentChunk.where(document_id: document.id)
      expect(document_chunks).not_to be_empty
      expect(document_chunks.first.content).to be_a(String)
      expect(document_chunks.first.embedding).to be_a(Array)
    end

    it "raises an error if document is not found" do
      expect { ProcessDocumentJob.perform_now("") }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
