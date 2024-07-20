defmodule DesafioCli do
  @moduledoc """
  Ponto de entrada para a CLI.
  """

  @doc """
  A função main recebe os argumentos e opções passados na linha de
  comando. Argumentos são recebidos como strings. Executar o programa
  sem argumentos o inicia em modo interativo.

  O programa aceita opções que possibilitam diferentes tipos de inputs:

  -i ou --input para ler o stdin 
        ex1: cat lista_de_nomes | ./desafio_cli -i
        ex2: ./desafio_cli.ex < lista_de_nomes

  -f ou --file para ler um arquivo
        ex: ./desafio_cli -f lista_de_nomes.txt

  O programa diferencia nomes iguais em caixas diferentes
  e aceita caracteres incomuns para nomes.
  (vai que o filho de Elon Musk é um desses reis)
  """

  def main(args) do
    opts = [
      strict: [
        input: :boolean,
        file: :string,
        help: :boolean
      ],
      aliases: [
        i: :input,
        f: :file,
        h: :help
      ]
    ]

    case OptionParser.parse(args, opts) do
      {[], [], []} ->
        print_interactive_instructions()

        read_stdin_interactive([])
        |> String.split("\n", trim: true)
        |> cumbuquize()
        |> IO.puts()

      {[], args, []} ->
        IO.puts(cumbuquize(args))

      {opts, _args, []} ->
        handle_options(opts)

      {[], [], _errors} ->
        IO.puts(
          ~c"Erro ao processar as opções utilizadas, use \"./desafio_cli -h\" para mais instruções"
        )
    end
  end

  defp print_instructions do
    IO.puts("""
    Olá! Essa é uma ferramenta para corrigir nomes monárquicos!
    Uso: "./desafio_cli" para iniciar o modo interativo ou "./desafio_cli [Lista de Nomes]"

    Com "./desafio_cli -h--help para saber métodos adicionais de entrada de dados
    """)
  end

  defp print_complete_instructions do
    IO.puts("""
    Olá! Essa é uma ferramenta para corrigir nomes monárquicos!
    Uso: "./desafio_cli" para iniciar o modo interativo ou "./desafio_cli [Lista de Nomes]"

    O programa aceita opções que possibilitam diferentes tipos de inputs:

    -i ou --input para ler o stdin 
        ex1: cat lista_de_nomes | ./desafio_cli -i
        ex2: ./desafio_cli.ex < lista_de_nomes

    -f ou --file para ler um arquivo
        ex: ./desafio_cli -f lista_de_nomes.txt
    """)
  end

  defp print_interactive_instructions do
    IO.puts("""
    Olá! Você já pode digitar a lista de nomes de monarcas que deseja corrigir.
    Uma linha em branco encerra a entrada e inicia o processamento da lista.
    (use -h ou --help ao executar o programa para saber sobre as outras opções de entrada de dados!)
    """)
  end

  defp handle_options(options) do
    cond do
      Keyword.has_key?(options, :help) -> print_complete_instructions()
      Keyword.has_key?(options, :input) -> read_stdin()
      file_path = Keyword.get(options, :file) -> cumbuquize_file(file_path)
    end
  end

  defp read_stdin_interactive(acc) do
    input = IO.gets(">>>")

    case String.trim(input) do
      "" -> Enum.reverse(acc) |> Enum.join("\n")
      line -> read_stdin_interactive([line | acc])
    end
  end

  defp read_stdin do
    case IO.read(:all) do
      :eof ->
        print_instructions()

      data ->
        data
        |> String.split(["\n", " "], trim: true)
        |> cumbuquize
        |> IO.puts()
    end
  end

  defp cumbuquize_file(file_path) do
    case File.read(file_path) do
      {:ok, content} ->
        content
        |> String.split(["\n", " "], trim: true)
        |> cumbuquize()
        |> IO.puts()

      {:error, :enoent} ->
        IO.puts("#{file_path} não existe ou não é um arquivo válido!")

      {:error, reason} ->
        IO.puts("Erro ao ler #{file_path}: por #{:file.format_error(reason)}")
    end
  end

  defp cumbuquize(names) do
    Enum.reduce(names, {[], %{}}, &process_name/2)
    |> elem(0)
    |> Enum.reverse()
  end

  defp process_name(name, {acc, counter}) do
    new_counter = Map.update(counter, name, 1, &(&1 + 1))
    new_name = "#{name} #{romanize(new_counter[name])}\n"
    {[new_name | acc], new_counter}
  end

  defp romanize(num) when num >= 100000, do: String.duplicate("M",100) <> romanize(num - 100000)
  defp romanize(num) when num >= 10000, do: String.duplicate("M",10) <> romanize(num - 10000)
  defp romanize(num) when num >= 1000, do: "M" <> romanize(num - 1000)
  defp romanize(num) when num >= 900, do: "CM" <> romanize(num - 900)
  defp romanize(num) when num >= 500, do: "D" <> romanize(num - 500)
  defp romanize(num) when num >= 400, do: "CD" <> romanize(num - 400)
  defp romanize(num) when num >= 100, do: "C" <> romanize(num - 100)
  defp romanize(num) when num >= 90, do: "XC" <> romanize(num - 90)
  defp romanize(num) when num >= 50, do: "L" <> romanize(num - 50)
  defp romanize(num) when num >= 40, do: "XL" <> romanize(num - 40)
  defp romanize(num) when num >= 10, do: "X" <> romanize(num - 10)
  defp romanize(num) when num >= 9, do: "IX" <> romanize(num - 9)
  defp romanize(num) when num >= 5, do: "V" <> romanize(num - 5)
  defp romanize(num) when num >= 4, do: "IV" <> romanize(num - 4)
  defp romanize(num) when num >= 1, do: "I" <> romanize(num - 1)
  defp romanize(_), do: ""
end
