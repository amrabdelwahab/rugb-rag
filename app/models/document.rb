# app/models/document.rb
class Document < ApplicationRecord
  has_one_attached :file

  validates :name, presence: true
  validates :file, presence: true
  
  has_many :document_chunks, dependent: :destroy
end