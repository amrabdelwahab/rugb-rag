class TextChunker
  def initialize(text:, sliding_window_tokens: 400, overlap_tokens: 100 )
    @text = text
    @sliding_window_tokens = sliding_window_tokens
    @overlap_tokens = overlap_tokens
  end

  def call
    tokenizer = Tokenizers.from_pretrained("gpt2") # Use a model tokenizer compatible with your LLM
    encoding = tokenizer.encode(@text)

    token_ids = encoding.ids # Use token IDs for chunking
    chunks = []
    index = 0

    while index < token_ids.length
      # Get the token ID slice for the current window
      chunk_token_ids = token_ids[index, @sliding_window_tokens]
      chunk_text = tokenizer.decode(chunk_token_ids) # Decode token IDs back to text

      chunks << chunk_text
      index += @sliding_window_tokens - @overlap_tokens
    end

    chunks
  end
end