# app/services/chunk_retriever.rb
class ChunkRetriever
  def initialize(question:)
    @question = question
    @embedding = EmbeddingGenerator.new.call(text: @question)
  end

  def retrieve_chunks
    # Fetch document chunks sorted by similarity
    # DocumentChunk
    #   .nearest_neighbors(:embedding, @embedding, distance: "cosine")
    #   .first(5)

    DocumentChunk
      .select("*, embedding <-> '#{@embedding}' AS distance")
      .where("embedding <-> '#{@embedding}' <= 0.8") # Adjust the cutoff to your preferred value
      .order("distance")
      .limit(5)
  end
end
