# app/services/answer_generator.rb
class AnswerGenerator
  SYSTEM_MESSAGE = "You are acting as an assitant to an employee doing research on pdfs, You will be provided a question to answer and you can only answer using the provided information only."
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
