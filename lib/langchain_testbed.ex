defmodule LangchainTestbed do
  alias LangChain.ChatModels.ChatGoogleAI
  alias LangChain.Chains.LLMChain
  alias LangChain.Message




  def start(_type, _args) do
    run()
    {:ok, self()}
  end

  def run do
    IO.puts("Starting Gemini Explorer...")

    # Add a callback to receive streaming deltas
    streaming_handler = %{
      on_llm_new_delta: fn _model, delta ->
        IO.write("STREAM_DELTA: #{delta.content}")
      end,
      on_llm_new_message: fn _model, message ->
        IO.inspect(message, label: "MESSAGE COMPLETED")
      end
    }

    llm = ChatGoogleAI.new!(%{
      model: "gemini-pro",
      temperature: 0.9,
      stream: true,
      callbacks: [streaming_handler]
    })

    chain =
      LLMChain.new!(%{llm: llm})
      |> LLMChain.add_message(Message.new_user!("What are 3 facts about the moon?"))

    case LLMChain.run(chain) do
      {:ok, result_chain} ->
        IO.puts("Successfully generated content")

        case result_chain.last_message.content do
          [%{content: content}] ->
            IO.puts("Generated content: #{content}")

          content when is_binary(content) ->
            IO.puts("Generated content: #{content}")

          _ ->
            IO.puts("Unexpected content type")
        end

      {:error, _chain, %LangChain.LangChainError{message: message}} ->
        IO.puts("Error generating content: #{message}")
    end

    #:timer.sleep(:infinity)
  end



end
