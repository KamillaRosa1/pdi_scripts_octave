# Processamento Digital de Imagens (PDI)

## Descrição do Projeto

Este repositório é primariamente um ambiente de **desenvolvimento e estudo** focado no domínio das funcionalidades e sintaxe do GNU Octave, utilizando PDI como alvo de aplicação, visando ser uma **coleção de scripts** de Processamento Digital de Imagens.

O primeiro módulo implementado é o Editor de Imagens Sépia, que serve como demonstração da aplicação da GUI e do pacote `image`.

## Requisitos de Sistema

O software requer as seguintes dependências e ambiente:

1.  **GNU Octave:** Versão utilizada 10.2.0.
2.  **Pacote `image`:** Necessário para as funções `imread`, `imwrite`, `imshow` e `rgb2ntsc`.

### Instalação de Dependências

É obrigatório que o pacote `image` esteja carregado antes da execução do script.

```octave
pkg install -forge image

```

## Módulos Disponíveis
 - Editor Sépia: Interface gráfica para carregamento e aplicação de filtros de tonalidade sépia com 3 variações. (editor_sepia.m)
 - _Pendente_(editor_negativo_contrast.m)
