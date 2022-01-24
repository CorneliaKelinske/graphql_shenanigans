defmodule GraphqlPractice.Metric do
  use Agent

  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_count(request) do
    Agent.get(__MODULE__, fn state ->
      Map.get(state, request)
    end)
  end

  def increment_count(request) do
    Agent.update(__MODULE__, fn state ->
      case Map.get(state, request) do
        nil -> Map.put(state, request, 1)
        count -> Map.put(state, request, count + 1)
      end
    end)
  end
end
