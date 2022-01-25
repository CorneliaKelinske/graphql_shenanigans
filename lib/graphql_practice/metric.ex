defmodule GraphqlPractice.Metric do
  use Agent

  def start_link([]) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_count(request) do
    Agent.get(__MODULE__, & Map.get(&1, request, 0))
  end

  def increment_count(request) do
    Agent.update(__MODULE__, fn state ->
      Map.update(state, request, 1, & &1 + 1)
    end)

  end
end
