defmodule InstructionReader do
  def read_intructions(port) do
    input = "input.txt"

    File.stream!(input)
    |> Stream.map(fn line -> process_line(port, line) end)
    |> Stream.run()

    :ok
  end

  def process_line(port, line) do
    cond do
      String.contains?(line, "[") -> process_line(port, line, :position)
      String.trim(line) == "" -> process_line(port, line, :empty)
      String.contains?(line, "move") -> process_line(port, line, :movement)
      true -> true
    end
  end

  def process_line(port, line, :position) do
    String.codepoints(line)
    |> Enum.chunk_every(4)
    |> Enum.map(fn e -> Enum.at(e, 1) end)
    |> Enum.with_index()
    |> Enum.filter(fn {e, i} -> e != " " end)
    |> Enum.map(fn {e, i} -> Port.add_crate(port, i + 1, e) end)
  end

  def process_line(port, _, :empty) do
    Port.reverse_all_crates(port)
  end

  def process_line(port, line, :movement) do
    [_, count, _, from, _, to] =
      String.split(line, " ")
      |> Enum.map(fn e -> Integer.parse(e) end)
      |> Enum.map(fn
        {number, _} -> number
        _ -> nil
      end)

    Port.move_crates(port, count, from, to)
  end
end

defmodule Port do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_crates(agent) do
    Agent.get(agent, fn state -> state end)
  end

  def add_crate(agent, key, value) do
    Agent.update(agent, fn state -> add_element_to_map_list(state, key, value) end)
  end

  def take_crate(agent, key) do
    crates = Agent.get(agent, fn state -> Map.get(state, key) end)

    case crates do
      [] ->
        nil

      [head | _] ->
        Agent.update(agent, fn state -> pop_element_from_map_list(state, key) end)
        head
    end
  end

  def reverse_all_crates(agent) do
    Agent.update(agent, fn state -> reverse_all_lists_in_map(state) end)
  end

  def move_crates(agent, count, from, to) do
    Enum.map(1..count, fn _ -> Port.take_crate(agent, from) end)
    |> Enum.each(fn crate -> Port.add_crate(agent, to, crate) end)
  end

  defp add_element_to_map_list(map, key, value) do
    list = Map.get(map, key)

    cond do
      list == nil -> Map.put(map, key, [value])
      true -> Map.put(map, key, [value | list])
    end
  end

  defp pop_element_from_map_list(map, key) do
    [_ | rest] = Map.get(map, key)
    Map.put(map, key, rest)
  end

  defp reverse_all_lists_in_map(map) do
    Map.to_list(map)
    |> Enum.map(fn {key, value} -> {key, Enum.reverse(value)} end)
    |> Map.new()
  end
end

defmodule Main do
  def main do
    {:ok, port} = Port.start_link()
    :ok = InstructionReader.read_intructions(port)

    Port.get_crates(port)
    |> Map.to_list()
    |> Enum.map(fn {_, crates} -> Enum.at(crates, 0) end)
    |> Enum.join("")
    |> IO.inspect()
  end
end

Main.main()
