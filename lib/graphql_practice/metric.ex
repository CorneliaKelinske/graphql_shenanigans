defmodule GraphqlPractice.Metric do
  use Agent

  def start_link(pid) do
    Agent.start_link(fn -> %{} end, name: agent_name(pid))
  end

  def get_count(request, pid) do
    Agent.get(agent_name(pid), &Map.get(&1, request, 0))
  end

  def increment_count(request, pid) do
    Agent.update(agent_name(pid), fn state ->
      Map.update(state, request, 1, &(&1 + 1))
    end)
  end

  if Mix.env() === :test do
    def agent_name(pid), do: :"metric_agent_#{inspect(pid)}"
  else
    def agent_name(_pid), do: :metric_agent
  end
end
