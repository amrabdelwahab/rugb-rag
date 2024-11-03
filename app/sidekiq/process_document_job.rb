# app/workers/process_document_job.rb
require 'pdf-reader'
require 'tokenizers'
require 'openai'

class ProcessDocumentJob
  include Sidekiq::Worker

  SLIDING_WINDOW_TOKENS = 100  # Number of tokens per chunk
  OVERLAP_TOKENS = 20          # Overlap in tokens between chunks

  def perform(document_id)
    document = Document.find(document_id)
    text = extract_text_from_document(document) # Extract text from the PDF file

    # Chunk the text using token-based sliding window
    chunks = chunk_text(text)

    # Process each chunk to generate embeddings and save them
    client = OpenAI::Client.new
    print(client.access_token)

    chunks.each do |chunk|
      embedding = generate_embedding(chunk, client)
      document.document_chunks.create!(content: chunk, embedding: embedding)
    end
  end

  private

  def extract_text_from_document(document)
    text = ""
    io = StringIO.new(document.file.download) # Handle cloud storage

    PDF::Reader.new(io).pages.each do |page|
      text += page.text
    end

    text
  end

  def chunk_text(text)
    tokenizer = Tokenizers.from_pretrained("gpt2") # Use a model tokenizer compatible with your LLM
    encoding = tokenizer.encode(text)

    token_ids = encoding.ids # Use token IDs for chunking
    chunks = []
    index = 0

    while index < token_ids.length
      # Get the token ID slice for the current window
      chunk_token_ids = token_ids[index, SLIDING_WINDOW_TOKENS]
      chunk_text = tokenizer.decode(chunk_token_ids) # Decode token IDs back to text

      chunks << chunk_text
      index += SLIDING_WINDOW_TOKENS - OVERLAP_TOKENS
    end

    chunks
  end

  def generate_embedding(text, client)
    response = client.embeddings(
      parameters: {
        model: "text-embedding-ada-002", # Replace with your embedding model
        input: text
      }
    )
    response['data'][0]['embedding']
  end
end
