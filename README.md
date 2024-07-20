# Desafio CLI Cumbuca

> Esse é o [link](https://github.com/appcumbuca/desafios/blob/master/desafio-eng-suporte.md) da descrição do problema.

## Relatório do desafio

> ### Pré-requisitos
> 
> Primeiro, será necessário [instalar o Elixir](https://elixir-lang.org/install.html)
> em versão igual ou superior a 1.16.
> Com o Elixir instalado, você terá a ferramenta de build `mix`.
> 
> Para buildar o projeto, use o comando `mix escript.build` nesta pasta.
> Isso irá gerar um binário com o mesmo nome do projeto na pasta.
> Executando o binário, (default: desafio_cli) sua CLI será executada.

### Problema(s)

O desafio consiste em desenvolver uma ferramenta de linha de comando que,
interativamente, recebe uma lista de strings que consiste em nomes de monarcas
hipotéticos como entrada e deve retornar uma versão processada dessa lista.

O processamento deve concatenar os nomes com 'n' em numeral romano, sendo 'n'
igual à enésima ocorrência desse nome na lista.

### Soluções e resumo da ferramenta desenvolvida

#### Algoritmo 
A solução algorítmica do problema foi modelada da seguinte forma:

- Um algoritmo de recursão foi utilizado para a conversão dos numerais equivalentes à enésima ocorrência do nome em algarismos romanos.
- Um hashmap foi utilizado como contador: transcorremos a lista e os nomes da lista são acessados/adicionados como chaves,
e seus valores correspondem ao número da ocorrência do nome. A primeira ocorrência do nome inicializa a entrada, ocorrências
subsequentes incrementam esse valor.
- Tendo acesso ao nome e sua enésima ocorrência, podemos concatenar nome e numeral "romanizado"
e adicionar essa string a uma lista, essa lista é utilizada na saída do programa.

#### Usabilidade

O programa oferece instruções de uso com `$ ./desafio_cli -h`.

A descrição do desafio tinha como requisito de funcionamento da ferramenta o seguinte:

> Ao iniciar o binário, ele deve primeiro exibir uma breve explicação de seu uso. Ele irá então esperar o usuário inserir uma lista de nomes. 
> Os nomes serão inseridos um por linha, e a lista será considerada terminada quando for lida uma linha em branco.

O trecho acima descreve um modo de usabilidade interativo, modo padrão de execução do programa caso ele seja executado sem argumentos. 
Em geral esse é um approach mais orgânico e natural,
mas que corre o risco de ser ineficiente no caso de entradas mais extensas.

Para oferecer uma solução para esse problema de escala, foram implementados,
além da opção de providenciar a lista de nomes como argumentos para o comando,
um modo de entrada que lê arquivos, e outro que aceita
o padrão UNIX de piping de argumentos para stdin:

``` 
$ cat lista_de_nomes.txt | executavel_cli -i   
```

Ou:

```
$ executavel_cli  <  lista_de_nomes.txt
```

#### Testes

Por conta do approach quanto aos modos de usabilidade, os testes implementados foram
quase inteiramente funcionais, fazendo uso da função System.cmd() para executar o binário
em suas diversas modos de operação, testando assim volume de entrada, formato de entrada,
comportamento da validação de dados, comportamento do processamento das opções e alguns outros fatores.

Os testes são executados com `mix test` a partir da raiz do diretório do projeto.

### Texto original do Template
> ## Template para Desafio CLI
> 
> Este template tem o objetivo de servir como 
> ponto de partida para a implementação de desafios
> de contratação da Cumbuca que envolvam implementar
> uma interface de linha de comando em Elixir.
> 
> ### Pré-requisitos
> 
> Primeiro, será necessário [instalar o Elixir](https://elixir-lang.org/install.html)
> em versão igual ou superior a 1.16.
> Com o Elixir instalado, você terá a ferramenta de build `mix`.
> 
> Para buildar o projeto, use o comando `mix escript.build` nesta pasta.
> Isso irá gerar um binário com o mesmo nome do projeto na pasta.
> Executando o binário, sua CLI será executada.
