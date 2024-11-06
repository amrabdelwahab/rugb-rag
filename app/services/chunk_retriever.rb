# app/services/chunk_retriever.rb
class ChunkRetriever
  def initialize(question:)
    @question = question
    @embedding = EmbeddingGenerator.new.call(text: @question)
  end

  def retrieve_chunks
    # Fetch document chunks sorted by cosine similarity
    DocumentChunk
      .includes(:document)
      .nearest_neighbors(:embedding, @embedding, distance: "cosine")
      .first(12)
      .filter { |neighbor| neighbor.neighbor_distance <= 0.2 }

      ###
      ### SELECT "document_chunks"."id", "document_chunks"."content",
      ### "document_chunks"."document_id", "document_chunks"."embedding", 
      ### "document_chunks"."created_at", "document_chunks"."updated_at",
      ### "document_chunks"."embedding" <=> $EMBEDDING
      ### LIMIT 12
      #
  end
end
