# Otimização de Árvores SAD com Somadores Rápidos em VHDL

Este projeto tem como objetivo analisar e validar diferentes arquiteturas de somadores rápidos aplicadas a uma **SAD Tree (Sum of Absolute Differences Tree)**. O foco é avaliar o impacto dessas arquiteturas no desempenho de circuitos utilizados em sistemas de processamento e codificação de vídeo.

A validação funcional dos circuitos é realizada por meio de simulações utilizando o **GHDL**, um simulador de código VHDL de código aberto.

---

## Linguagem Utilizada

### VHDL

O projeto foi desenvolvido em **VHDL (VHSIC Hardware Description Language)**, uma linguagem de descrição de hardware amplamente utilizada para modelagem, simulação e síntese de circuitos digitais.

Com o VHDL é possível descrever:

* Componentes de hardware;
* Fluxo de dados;
* Comportamentos de circuitos digitais;
* Arquiteturas para implementação em FPGA e ASIC.

---

## O que é SAD?

### Sum of Absolute Differences (SAD)

A técnica **Sum of Absolute Differences (SAD)** é amplamente utilizada em algoritmos de processamento de imagens e codificação de vídeo, especialmente em processos de estimação de movimento.

O cálculo consiste em:

1. Comparar dois blocos de pixels;
2. Calcular a diferença absoluta entre cada par de pixels correspondentes;
3. Somar todas as diferenças obtidas.

Matematicamente:

[
SAD = \sum |A(i,j) - B(i, j)|
]

Onde:

* **A** representa o bloco de referência;
* **B** representa o bloco comparado.

Quanto menor o valor do SAD, maior a similaridade entre os blocos.

---

## O que é uma SAD Tree?

Uma **SAD Tree** é a estrutura responsável por realizar a soma das diferenças absolutas geradas pelo cálculo do SAD.

Em vez de realizar todas as somas sequencialmente, as diferenças são organizadas em uma árvore de somadores, permitindo:

* Maior paralelismo;
* Menor atraso de propagação;
* Melhor desempenho do circuito.

Neste projeto é utilizada uma **SAD Tree 4x4**.

---

## Somadores Avaliados

Os experimentos deste repositório utilizam diferentes arquiteturas de somadores rápidos para compor a SAD Tree, permitindo analisar características como:

* Tempo de propagação;
* Área ocupada;
* Consumo de potência;
* Eficiência geral da arquitetura.

* Somadores utilizados nos testes:
* Ripple Carry Adder
* Carry Select Adder
* Carry Look-Ahead Adder
* Carry Save Adder

---

## Simulação e Validação

### GHDL

O **GHDL** é um simulador de VHDL de código aberto que permite:

* Compilar projetos VHDL;
* Executar testbenches;
* Validar o comportamento funcional dos circuitos;
* Gerar formas de onda para análise.

---

## Como Executar

### 1. Analisar os arquivos

```bash
ghdl -a *.vhd
```

### 2. Elaborar o projeto

```bash
ghdl -e nome_do_testbench
```

### 3. Executar a simulação

```bash
ghdl -r nome_do_testbench
```
---

## Objetivo

Comparar o comportamento de diferentes arquiteturas de somadores rápidos quando aplicadas a uma SAD Tree 4x4, verificando sua corretude funcional através de simulações em VHDL utilizando o GHDL.
