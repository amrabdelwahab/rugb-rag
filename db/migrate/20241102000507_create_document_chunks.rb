class CreateDocumentChunks < ActiveRecord::Migration[7.2]
  def change
    create_table :document_chunks do |t|
      t.text :content
      t.references :document, null: false, foreign_key: true
      t.vector :embedding, limit: 1536 # Define vector with 1536 dimensions
      t.timestamps  
    end
  end
end
