defmodule DesafioCliTest do
  use ExUnit.Case
  use ExUnit.Callbacks

  setup_all do
    binary_file = "desafio_cli"
    project_dir = File.cwd() |> elem(1)
    [binary_path: "#{project_dir}/#{binary_file}"]
  end

  describe "Testes de tipo/modo de entrada e validação de regras de entrada" do
    test "Passando argumentos - Lista de nomes", %{binary_path: binary_path} do
      input = "pedro pedro pedro"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} #{input}"
        ])

      expected_output = "pedro I\npedro II\npedro III\n\n"
      assert output == expected_output
    end

    test "Passando argumentos - Lista de nomes - com multiplos espaços entre os nomes", %{
      binary_path: binary_path
    } do
      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} pedro    pedro          pedro"
        ])

      expected_output = "pedro I\npedro II\npedro III\n\n"
      assert output == expected_output
    end

    test "Passando texto pelo stdin", %{binary_path: binary_path} do
      input = "pedro\npedro\npedro"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "echo -n '#{input}' | #{binary_path} -i"
        ])

      expected_output = "pedro I\npedro II\npedro III\n\n"
      assert output == expected_output
    end

    test "Lendo texto de um arquivo", %{binary_path: binary_path} do
      input = "./test/files/input"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} -f #{input}"
        ])

      expected_output =
        "paulo I\nmaicon I\nmanoel I\nmiguel I\njoao I\nmaicon II\nmaicon III\nmaicon IV\n\n"

      assert output == expected_output
    end

    test "Lendo arquivo inexistente", %{binary_path: binary_path} do
      input = "./test/files/nao_existe"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} -f #{input}"
        ])

      expected_output = "./test/files/nao_existe não existe ou não é um arquivo válido!\n"
      assert output == expected_output
    end

    test "Lendo um diretório", %{binary_path: binary_path} do
      input = "./test/files/"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} -f #{input}"
        ])

      expected_output = "Erro ao ler ./test/files/: por illegal operation on a directory\n"
      assert output == expected_output
    end

    test "Lendo um arquivo com 10_000 itens", %{binary_path: binary_path} do
      input = "./test/files/eduardo"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} -f #{input}"
        ])

      expected_output = File.read!("./test/files/eduardo.expect")
      assert output == expected_output
    end

    test "Lendo um arquivo com 100_000 itens", %{binary_path: binary_path} do
      input = "./test/files/eduardox10"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} -f #{input}"
        ])

      expected_output = File.read!("./test/files/eduardox10.expect")
      assert output == expected_output
    end

    test "Homônimos com caracteres em caixas diferentes", %{binary_path: binary_path} do
      input = "pedro Pedro PEDRO"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} #{input}"
        ])

      expected_output = "pedro I\nPedro I\nPEDRO I\n\n"
      assert output == expected_output
    end

    test "Caracteres incomuns e numerais", %{binary_path: binary_path} do
      input = "XÆA-12"

      {output, 0} =
        System.cmd("sh", [
          "-c",
          "#{binary_path} #{input}"
        ])

      expected_output = "XÆA-12 I\n\n"
      assert output == expected_output
    end
  end
end
