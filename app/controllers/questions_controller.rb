# app/controllers/questions_controller.rb
class QuestionsController < ApplicationController
  def new
    # Renders the form for entering a question
  end

  def create
    @question = params[:question]

    # Retrieve relevant document chunks based on the question
    @retrieved_chunks = ChunkRetriever.new(question: @question).retrieve_chunks.includes(:document)

    render :show
  end

  def generate_answer
    @question = params[:question]
    @retrieved_chunks = params[:chunks] # Pass chunks as hidden fields or fetch by ID if persisted
    @answer = AnswerGenerator.new(question: @question, chunks: @retrieved_chunks).generate

    render :answer
  end
end
