class EmbeddingGenerator
  def initialize(model: "text-embedding-ada-002")
    @model = model
    @client = OpenAI::Client.new
  end

  def call(text:)
    response = @client.embeddings(
      parameters: {
        model: @model, 
        input: text
      }
    )
    response['data'][0]['embedding']
  end
end