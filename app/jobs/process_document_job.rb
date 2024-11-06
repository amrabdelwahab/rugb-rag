# app/workers/process_document_job.rb
require 'pdf-reader'
require 'tokenizers'
require 'openai'

class ProcessDocumentJob
  include Sidekiq::Worker

  def perform(document_id)
    document = Document.find(document_id)
    text = PdfTextExtractor.new(file: document.file).call # Extract text from the PDF file

    # Chunk the text using token-based sliding window
    chunks = TextChunker.new(text: text).call

    # Process each chunk to generate embeddings and save them
    chunks.each do |chunk|
      embedding = EmbeddingGenerator.new.call(text: chunk)
      document.document_chunks.create!(content: chunk, embedding: embedding)
    end
  end
end
