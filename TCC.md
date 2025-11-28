# 🎓 GEST-UAN – APLICATIVO PARA GESTÃO DE UNIDADE DE ALIMENTAÇÃO E NUTRIÇÃO (UAN)

## Centro Universitário UNIFACVEST | Curso de Ciência da Computação
---
### Autor: FÁGNER BERTO CIRIO
### Coorientador: Márcio José Sembay
### LAGES 2025

***

# RESUMO

O GEST-UAN foi um aplicativo multiplataforma desenvolvido para otimizar a gestão de Unidades de Alimentação e Nutrição (UAN), oferecendo maior controle sobre **desperdícios**, **higiene** e **segurança alimentar**. A pesquisa utilizou revisão bibliográfica como base teórica e análise de dados operacionais para validar o sistema. A **metodologia foi quali-quantitativa**, integrando percepções de profissionais e dados coletados durante o uso da ferramenta.

O sistema, implementado com **Dart**, **Flutter**, **H2 Database** e **Java**, apresentou importantes funcionalidades como:
* Monitoramento de desperdício
* Checklists digitais conforme as Boas Práticas de Fabricação (BPF)
* Cálculo per capita
* Relatórios gerenciais

Os resultados mostraram que o GEST-UAN contribuiu efetivamente para **reduzir perdas** e apoiar decisões estratégicas relevantes.

**Palavras-chave:** Gestão de UAN; Desperdício alimentar; Checklists digitais; Cálculo per capita; Automação.

## ABSTRACT

GEST-UAN was a multiplatform application developed to optimize the management of Food and Nutrition Units (UAN), offering greater control over waste, hygiene, and food safety. The research used a literature review as a theoretical basis and operational data analysis to validate the system. The methodology was qualitative-quantitative, integrating professionals' perceptions and data collected during the use of the tool.

The system, implemented with **Dart**, **Flutter**, **H2 Database**, and **Java**, presented important features such as waste monitoring, digital checklists in accordance with GMP, per capita calculation, and management reports. The results showed that it effectively contributed to reducing losses and supporting relevant strategic decisions.

**Keywords:** UAN management; Food waste; Digital checklists; Per capita calculation; Automation.

***

# 1. INTRODUÇÃO

As **Unidades de Alimentação e Nutrição (UAN)** desempenham um papel fundamental na promoção da segurança alimentar e na administração eficiente dos recursos destinados à alimentação coletiva. Historicamente, a administração dessas unidades era baseada em processos manuais, o que dificultava o controle de desperdícios e a padronização de procedimentos.

> De acordo com Proença et al. (2005), as Unidades de Alimentação e Nutrição têm como função principal a elaboração de cardápios que atendam às necessidades nutricionais, mantendo rígidos padrões de qualidade.

A crescente demanda por controle rigoroso na segurança alimentar e a necessidade de otimizar custos operacionais impulsionaram o uso da tecnologia. Segundo Campos e Spinelli (2021), "a eficiência na operação de UANs depende de um acompanhamento sistemático das atividades e da aplicação de métricas para avaliar seu desempenho".

Diante desse cenário, este estudo propôs o desenvolvimento de um **aplicativo multiplataforma** (GEST-UAN) para auxiliar na gestão de UANs, buscando otimizar a gestão de recursos e fornecer embasamento para a tomada de decisões estratégicas.

## 1.1. Objetivo Geral

Desenvolver um aplicativo multiplataforma para a gestão de Unidades de Alimentação e Nutrição (UAN) permitindo maior controle sobre desperdício alimentar, higiene e segurança, bem como a eficiência no uso de insumos, por meio da análise de dados e geração de relatórios.

## 1.2. Objetivos Específicos

* Implementar um sistema de monitoramento e relatórios sobre desperdício alimentar, auxiliando na redução de perdas.
* Desenvolver um checklist digital para controle de higiene e segurança, garantindo conformidade com as normas da **BPF (Boas Práticas de Fabricação)**.
* Criar um módulo de **cálculo de per capita alimentar** e geração de gráficos gerenciais para otimização do planejamento e redução de custos.

***

# 2. FUNDAMENTAÇÃO TEÓRICA

## 2.1. Unidade de Alimentação e Nutrição (UAN)

As UANs são espaços fundamentais para garantir uma alimentação de qualidade, equilibrada e dentro dos padrões sanitários.

> Segundo Proença et al. (2005, p. 27), "essas unidades são responsáveis pela elaboração de cardápios que atendem às necessidades nutricionais dos consumidores, além de manter rigorosos controles de qualidade".

A gestão eficaz de uma UAN envolve planejamento estratégico, gestão financeira e, crucialmente, **controle de desperdícios** (Campos e Spinelli, 2021).

## 2.2. O Papel do Nutricionista na UAN

O nutricionista é uma peça-chave que atua na prevenção de desperdícios e na garantia da qualidade.

> "Esse profissional deve assegurar que todas as etapas do processo estejam em conformidade com as normas sanitárias e nutricionais" (Resolução CFN nº 600/2018).

O profissional também precisa dominar áreas como gestão de equipes e logística de insumos, sendo a capacitação contínua indispensável (Proença et al., 2005).

## 2.3. Controle de Desperdício

O desperdício de alimentos é um dos grandes desafios, impactando custos e sustentabilidade.

> Segundo Alexandre et al. (2020), "uma gestão eficiente deve identificar e minimizar os pontos de desperdício para garantir maior eficiência produtiva e financeira".

**Ferramentas de controle utilizadas:**
* **Ciclo PDCA:** Para melhoria contínua dos processos.
* **Diagrama de Ishikawa:** Para identificação das causas principais.
* **Método 5W2H:** Para definição de ações corretivas e preventivas.

## 2.4. Cálculo Per Capita

Recurso essencial para otimizar a quantidade de ingredientes e garantir que a produção atenda à demanda sem excessos.

> "O cálculo per capita auxilia na redução de desperdícios e na melhoria da eficiência operacional, garantindo um melhor aproveitamento dos recursos disponíveis" (Araújo et al., 2020, p. 12).

## 2.5. Tecnologia Aplicada à Gestão de UAN

A digitalização otimiza processos, com ferramentas como aplicativos de checklist para BPF, controle de estoque e análise financeira.

> "A automação na gestão de UANs permite maior controle das atividades, reduzindo falhas e tornando a tomada de decisão mais ágil" (Mello e Morimoto, 2018, p. 21).

## 2.6. Checklists de Higiene e Qualidade

Ferramenta indispensável para **padronizar processos** e minimizar riscos sanitários. A digitalização facilita auditorias internas e assegura o cumprimento das normas vigentes (Mello e Morimoto, 2018).

## 2.7. Importância da Visualização de Dados

A utilização de gráficos e relatórios permite que gestores identifiquem padrões de consumo, ajustem pedidos e implementem estratégias.

> "A análise de dados gerenciais contribui para a tomada de decisões mais precisas e ágeis" (Araújo et al., 2020, p. 35).

***

# 3. METODOLOGIA

## 3.1. Metodologia Científica

A pesquisa bibliográfica forneceu a base teórica, utilizando livros, artigos e normas reguladoras (Gil, 2002; Severino, 2007).

A abordagem foi **quali-quantitativa**:
* **Qualitativa:** Focada na interpretação dos padrões de desperdício e nos *feedbacks* dos nutricionistas.
* **Quantitativa:** Concentrada nos dados extraídos pelo sistema, como métricas de desperdício alimentar e consumo médio.

## 3.2. Metodologia Computacional

| Ferramentas Utilizadas | Descrição | Referências |
| :--- | :--- | :--- |
| **Git Hub** | Plataforma que permite controle de versão, colaboração e gerenciamento de código. | (GITHUB, 2025) |
| **Dart** | Linguagem para desempenho elevado, produtividade e segurança com tipagem opcional. | (DART, 2025) |
| **Flutter** | Framework para desenvolvimento rápido e nativo de interfaces modernas com uma única base de código. | (FLUTTER, 2025) |
| **H2 DataBase** | Banco de dados desenvolvido em Java, rápido, leve e de fácil integração, utilizado como banco relacional embarcado. | (H2 DATABASE, 2025) |
| **Java** | Linguagem amplamente utilizada no mundo devido à sua versatilidade, alto desempenho e capacidade de integração. | (ORACLE, 2025) |

***

# 4. RESULTADOS

O sistema desenvolvido demonstrou ser capaz de realizar o controle do desperdício alimentar, o acompanhamento das práticas de higiene e a geração de relatórios gerenciais e documentos em PDF, atendendo aos objetivos propostos.

## 4.1. Interface de Navegação (Figura 1)

A Figura 1 apresenta a **tela inicial do sistema** após a autenticação, com um painel principal e menu lateral para acesso a módulos como controle de desperdício, gráficos e gestão de contratos.


## 4.2. Módulo de Registro (Figura 2)

O módulo de **registro de desperdício alimentar** permite informar o número de refeições, o tipo de desperdício (resto ingesta ou sobras limpas), o peso e o destino final do resíduo.


## 4.3. Gráficos Gerenciais (Figura 3)

Os dados cadastrados são processados automaticamente e exibidos em **gráficos gerenciais de desperdício**, permitindo a visualização da composição do peso total dos resíduos e a separação por tipo e destino.


## 4.4. Checklist BPF (Figura 4)

O **checklist digital de Boas Práticas de Fabricação (BPF)** permite que o responsável técnico avalie os itens de higiene e segurança, marcando conforme, não conforme ou não aplicável, e inserindo observações.


## 4.5. Relatórios em PDF (Figuras 5 e 6)

O sistema gera **relatórios em PDF** a partir do checklist (Figura 5), contendo percentual de conformidade e observações, além da **Declaração de Doação de Resíduos Orgânicos** (Figura 6).



***

# 5. CONSIDERAÇÕES FINAIS

O desenvolvimento do aplicativo GEST-UAN permitiu alcançar integralmente o objetivo geral proposto, oferecendo uma solução multiplataforma para otimizar a gestão de UAN.

* Todos os **objetivos específicos** (monitoramento de desperdício, checklist digital, cálculo per capita e gráficos gerenciais) foram atendidos com êxito.
* Os testes demonstraram que o sistema é **estável, intuitivo** e facilita o registro de dados em tempo real.
* A análise das informações evidenciou melhorias significativas no acompanhamento das rotinas e no **controle do desperdício**.

Conclui-se que o GEST-UAN é uma ferramenta funcional e inovadora, alinhada às necessidades reais da UAN.

**Perspectivas futuras:** Expansão para incluir módulos adicionais, como controle de estoque e relatórios avançados.

***

# 6. REFERÊNCIAS

* ABREU, E. S. de; SPINELLI, M. G. N.; PINTO, A. M. de S. **Gestão de Unidades de Alimentação e Nutrição: um modo de fazer**. 7. ed. São Paulo: Metha, 2019.
* ALEXANDRE, L. de S. et al. Utilização das ferramentas de qualidade para redução de desperdícios de alimentos em redes de fast-food. **Brazilian Journal of Development**, v. 6, n. 7, p. 52108–52124, 2020. [Acesso]
* ARAÚJO, A. G. G. de et al. Utilização de ferramenta estratégica no controle de estoque em unidades de alimentação e nutrição. **Revista Ciência Plural**, v. 6, n. 3, p. 74–92, 2020. [Acesso]
* BEZERRA, B. D. et al. Aplicação de ferramentas da qualidade na área de estoque. **XII Fateclog**, Fatec Mogi das Cruzes, São Paulo, 2021. [Acesso]
* CAMPOS, E. M. C.; SPINELLI, M. G. N. Utilização das ferramentas de gestão por gerentes de Unidades de Alimentação e Nutrição do município de São Paulo. **Disciplinarum Scientia**, v. 22, n. 1, p. 1–15, 2021. [Acesso]
* CONSELHO FEDERAL DE NUTRICIONISTAS (CFN). **Resolução CFN nº 600**, de 25 de fevereiro de 2018. [Acesso]
* DART. **What is Dart?**. Dart Dev, 2024. [Acesso]
* FAVERI, A.; BORBA, M. **Planejamento e gestão de UAN**. Indaial: UNIASSELVI, 2021. [Acesso]
* FLUTTER. **Sobre o Flutter**. Flutter Dev, 2024. [Acesso]
* GITHUB. **Sobre o GitHub**. GitHub Docs, 2024. [Acesso]
* H2 Database. **H2 Database Engine Documentation**. [Acesso]
* ORACLE. **The Java Programming Language**. Oracle, 2024. [Acesso]
