# app/services/answer_generator.rb
class AnswerGenerator
  SYSTEM_MESSAGE = <<~SYSTEM
  You are assisting an employee in researching specific information within provided PDF documents.
  You will be given a question to answer, and you should respond strictly based on the information available in these documents.
  If the answer is not found within the documents, respond with "The information is not available in the provided documents."
SYSTEM

# SYSTEM_MESSAGE = <<~SYSTEM
#  You are assisting an employee in finding information specifically within a Ruby on Rails tutorial provided in PDF documents.
#  You will be given a question to answer, and you should respond only based on the information in these tutorial documents.
#  If the answer is not found within the documents, respond with "The information is not available in the provided tutorial."
#  Avoid providing information that isn’t explicitly mentioned in the tutorial.
# SYSTEM



  def initialize(question:, chunks:)
    @question = question
    @chunks = chunks
    @client = OpenAI::Client.new
  end

  def generate
    context = @chunks.join("\n") # Combine chunks into a single context for GPT-4

    response = @client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [
          { role: "system", content: SYSTEM_MESSAGE },
          { role: "user", content: "#{@question}\n\nContext:\n#{context}" }
        ]
      }
    )

    response["choices"][0]["message"]["content"].strip
  end
end
