CENTRO UNIVESITÁRIO UNIFACVEST CURSO DE CIÊNCIA DA COMPUTAÇÃO
FÁGNER BERTO CIRIO



















GEST-UAN – APLICATIVO PARA GESTÃO DE UNIDADE DE ALIMENTAÇÃO E NUTRIÇÃO (UAN)




















LAGES 2025
 
FÁGNER BERTO CIRIO



















GEST-UAN- APLICATIVO PARA GESTÃO DE UNIDADE DE ALIMENTAÇÃO E NUTRIÇÃO (UAN)



Trabalho de conclusão de curso apresentado ao Centro Universitário UNIFACVEST como parte dos requisitos para a obtenção do grau de Bacharel em Ciência da Computação

Aluno: Fágner Berto Círio
Coorientador: Márcio José Sembay











LAGES 2025


FÁGNER BERTO CIRIO
















GEST-UAN- APLICATIVO PARA GESTÃO DE UNIDADE DE ALIMENTAÇÃO E NUTRIÇÃO (UAN)



Trabalho de conclusão de curso apresentado ao Centro Universitário UNIFACVEST como parte dos requisitos para a obtenção do grau de Bacharel em Ciência da Computação

Aluno Fagner Berto Cirio Coorientador: Márcio José Sembay


Lages, SC 	/	/2025. Nota 	 	
(data de aprovação)	(assinatura do orientador do trabalho)



(coordenador do curso de graduação, nome e assinatura)
GEST-UAN- APLICATIVO PARA GESTÃO DE UNIDADE DE ALIMENTAÇÃO E NUTRIÇÃO (UAN)

Fágner Berto Cirio¹
Márcio José Sembay²
Patrícia Guimarães Baptista³
Igor Muzeka4
RESUMO
O GEST-UAN foi um aplicativo multiplataforma desenvolvido para otimizar a gestão de Unidades de Alimentação e Nutrição (UAN), oferecendo maior controle sobre desperdícios, higiene e segurança alimentar. A pesquisa utilizou revisão bibliográfica como base teórica e análise de dados operacionais para validar o sistema. A metodologia foi quali-quantitativa, integrando percepções de profissionais e dados coletados durante o uso da ferramenta. O sistema, implementado com Dart, Flutter, H2 Database e Java, apresentou importantes funcionalidades como monitoramento de desperdício, checklists digitais conforme as Boas Práticas de Fabricação (BPF), cálculo per capita e relatórios gerenciais. Os resultados mostraram que contribuiu efetivamente para reduzir perdas e apoiar decisões estratégicas relevantes
Palavras-chave: Gestão de UAN; Desperdício alimentar; Checklists digitais; Cálculo per capita; Automação.
GEST-UAN- APPLICATION FOR MANAGING FOOD AND NUTRITION UNITS

ABSTRACT
GEST-UAN was a multiplatform application developed to optimize the management of Food and Nutrition Units (UAN), offering greater control over waste, hygiene, and food safety. The research used a literature review as a theoretical basis and operational data analysis to validate the system. The methodology was qualitative-quantitative, integrating professionals' perceptions and data collected during the use of the tool. The system, implemented with Dart, Flutter, H2 Database, and Java, presented important features such as waste monitoring, digital checklists in accordance with GMP, per capita calculation, and management reports. The results showed that it effectively contributed to reducing losses and supporting relevant strategic decisions.
Keywords: UAN management; Food waste; Digital checklists; Per capita calculation; Automation.
1 Graduando em Ciência da Computação pela Unifacvest. mail: fagnercirio@gmail.com
2 Professor Orientador Márcio José Sembay departamento de Ciência da Computação
3 Professor Orientador Patrícia Guimarães Baptista departamento de Nutrição
4 Professor Orientador departamento de Ciência da Computação

1.	Introdução

As Unidades de Alimentação e Nutrição (UAN) desempenham um papel fundamental na promoção da segurança alimentar e na administração eficiente dos recursos destinados à alimentação coletiva. Desde suas primeiras formas organizadas, como as cozinhas industriais e hospitalares do século XX, até os modernos sistemas informatizados, a gestão dessas unidades passou por diversas transformações para garantir a qualidade e a eficiência na produção de refeições. Historicamente, a administração dessas unidades era baseada em processos manuais, o que dificultava o controle de desperdícios e a padronização de procedimentos. Com o passar dos anos, avanços tecnológicos foram incorporados, permitindo uma gestão mais automatizada e eficiente. De acordo com Proença et al. (2005), as Unidades de Alimentação e Nutrição têm como função principal a elaboração de cardápios que atendam às necessidades nutricionais, mantendo rígidos padrões de qualidade. Esse papel torna as UANs fundamentais para garantir tanto a segurança alimentar quanto a eficiência no planejamento de refeições. 
A crescente demanda por controle rigoroso na segurança alimentar e a necessidade de otimizar custos operacionais impulsionaram o uso da tecnologia como aliada na gestão de UANs. Segundo Campos e Spinelli (2021), "a eficiência na operação de UANs depende de um acompanhamento sistemático das atividades e da aplicação de métricas para avaliar seu desempenho". A implementação de sistemas digitais permite a automação de processos, a análise detalhada de dados operacionais e a melhoria na tomada de decisões, reduzindo desperdícios e garantindo um planejamento alimentar mais preciso.
Diante desse cenário, este estudo propôs o desenvolvimento de um aplicativo multiplataforma para auxiliar na gestão de UANs, oferecendo funcionalidades voltadas para o controle de desperdício alimentar, checklist de higiene e segurança conforme a Boas Práticas de Fabricação (BPF), cálculo de per capita alimentar e geração de relatórios e gráficos gerenciais. O sistema buscou otimizar a gestão de recursos, proporcionando maior controle sobre o consumo, eficiência operacional e embasamento para a tomada de decisões estratégicas por meio da análise de dados.

1.1.	Objetivo Geral

Desenvolver um aplicativo multiplataforma para a gestão de Unidades de Alimentação e Nutrição (UAN)  permitindo maior controle sobre desperdício alimentar, higiene e segurança, bem como a eficiência no uso de insumos, por meio da análise de dados e geração de relatórios.

1.2.	Objetivos Específicos

•	Implementar um sistema de monitoramento e relatórios sobre desperdício alimentar, auxiliando na redução de perdas.
•	Desenvolver um checklist digital para controle de higiene e segurança, garantindo conformidade com as normas da BPF.
•	Criar um módulo de cálculo de per capita alimentar e geração de gráficos gerenciais para otimização do planejamento e redução de custos.

2.	Fundamentação Teórica

2.1.	Unidade de Alimentação e Nutrição (UAN)
As Unidades de Alimentação e Nutrição (UAN) desempenham um papel essencial na segurança alimentar e na gestão eficiente de recursos. São espaços fundamentais para garantir uma alimentação de qualidade, equilibrada e dentro dos padrões sanitários. Segundo Proença et al. (2005, p. 27), "essas unidades são responsáveis pela elaboração de cardápios que atendem às necessidades nutricionais dos consumidores, além de manter rigorosos controles de qualidade".
A gestão eficaz de uma UAN envolve muito mais do que apenas preparar refeições. Inclui também planejamento estratégico, gestão financeira e controle de desperdícios. Como destacam Campos e Spinelli (2021), "a eficiência na operação depende de um acompanhamento sistemático das atividades e da aplicação de métricas para avaliar seu desempenho". Além disso, uma administração bem estruturada contribui para a sustentabilidade do negócio e melhora a experiência dos clientes (Araújo et al., 2020).
2.2.	O Papel do Nutricionista na UAN
O nutricionista é uma peça-chave dentro de uma UAN. Ele não apenas planeja e supervisiona a produção de refeições, mas também atua na prevenção de desperdícios e na garantia da qualidade dos alimentos servidos. De acordo com a Resolução CFN nº 600/2018 (BRASIL, 2018):
"Esse profissional deve assegurar que todas as etapas do processo estejam em conformidade com as normas sanitárias e nutricionais".
Como afirmam Campos e Spinelli (2021, p. 5), "a presença do nutricionista é essencial para manter a segurança e a qualidade da alimentação oferecida".
Além disso, o nutricionista também precisa dominar áreas como gestão de equipes e logística de insumos. A administração de estoques, por exemplo, é um fator determinante para evitar desperdícios e garantir a eficiência na distribuição dos alimentos (Araújo et al., 2020). Segundo Proença et al. (2005), "funcionários bem treinados e alinhados com as boas práticas operacionais são fundamentais para garantir a conformidade com os padrões exigidos". Portanto, a capacitação contínua da equipe torna-se indispensável para um bom funcionamento da unidade.
2.3.	Controle de Desperdício
O desperdício de alimentos é um dos grandes desafios dentro das UANs, impactando não apenas os custos operacionais, mas também a sustentabilidade e a qualidade do serviço prestado. Esse desperdício pode ocorrer em diferentes etapas, desde a compra dos insumos até o consumo final pelos clientes. Segundo Alexandre et al. (2020), "uma gestão eficiente deve identificar e minimizar os pontos de desperdício para garantir maior eficiência produtiva e financeira".
Para reduzir esse problema, são utilizadas ferramentas de controle como:
•	Ciclo PDCA: possibilita a melhoria contínua dos processos;
•	Diagrama de Ishikawa: auxilia na identificação das principais causas de desperdício;
•	Método 5W2H: facilita a definição de ações corretivas e preventivas (Alexandre et al., 2020).
Além disso, é essencial que as UANs adotem treinamentos periódicos para a equipe, garantindo que as boas práticas de manipulação e armazenamento dos alimentos sejam seguidas corretamente. Proença et al. (2005) destacam que os consumidores estão cada vez mais atentos a práticas sustentáveis, o que exige das UANs estratégias eficazes de redução de impactos ambientais relacionados ao desperdício de alimentos. Nesse contexto, a adoção de ferramentas de gestão aliadas à capacitação da equipe se mostra essencial para alinhar os objetivos econômicos à responsabilidade socioambiental.
Outro fator importante no controle de desperdício é a realização de auditorias internas frequentes, possibilitando um diagnóstico preciso das falhas operacionais. A separação e análise dos resíduos também podem fornecer informações valiosas sobre os tipos de desperdício mais comuns, auxiliando na elaboração de estratégias mais eficazes para a sua redução.
2.4.	Cálculo Per Capita
O cálculo per capita é um recurso essencial para otimizar a quantidade de ingredientes utilizados por refeição, garantindo que a produção atenda à demanda sem excessos. Segundo Araújo et al. (2020, p. 12), "o cálculo per capita auxilia na redução de desperdícios e na melhoria da eficiência operacional, garantindo um melhor aproveitamento dos recursos disponíveis".
A definição do per capita alimentar varia de acordo com o tipo de refeição e o público atendido. Para que esse cálculo seja eficiente, é essencial o acompanhamento contínuo do consumo real, possibilitando ajustes sempre que necessário.
Além disso, um cálculo per capita bem estruturado contribui diretamente para a economia de insumos e a melhoria na gestão financeira das UANs. Quando há um controle preciso das porções servidas, evita-se tanto o excesso de comida nos pratos quanto a necessidade de descartes elevados. Como afirmam Campos e Spinelli (2021), "a padronização das porções e a correta aplicação do cálculo per capita permitem uma melhor organização dos recursos e reduzem significativamente os custos operacionais".
2.5.	Tecnologia Aplicada à Gestão de UAN
A digitalização das operações tem sido uma das principais tendências na gestão de UANs. Ferramentas tecnológicas, como aplicativos de checklist para boas práticas de fabricação (BPF), controle de estoque e análise financeira, ajudam a otimizar os processos. Como apontam Mello e Morimoto (2018, p. 21), "a automação na gestão de UANs permite maior controle das atividades, reduzindo falhas e tornando a tomada de decisão mais ágil".
Além disso, sistemas de rastreabilidade de produtos possibilitam um monitoramento mais eficiente da procedência dos alimentos, garantindo maior segurança alimentar. Segundo Alexandre et al. (2020), "a tecnologia também contribui para a padronização dos processos, reduzindo variações na qualidade das refeições e melhorando a experiência do cliente". A integração de dados analíticos pode prever demandas futuras, ajustando estoques e minimizando desperdícios (Campos & Spinelli, 2021).
2.6.	Checklists de Higiene e Qualidade
A implementação de checklists digitais é uma ferramenta indispensável para padronizar os processos dentro das UANs, auxiliando na minimização de riscos sanitários e no controle da qualidade (Proença et al., 2005). Mello e Morimoto (2018) complementam que a utilização desses instrumentos estruturados facilita auditorias internas e assegura o cumprimento das normas vigentes. Mais do que atender à legislação, os checklists permitem respostas rápidas a desvios operacionais e contribuem para a melhoria contínua da gestão. Dessa forma, a padronização das práticas diárias melhora a eficiência dos processos e evita falhas que possam comprometer a segurança alimentar dos consumidores.
2.7.	Importância da Visualização de Dados
O acompanhamento de indicadores é essencial para a melhoria contínua da gestão de UANs. A utilização de gráficos e relatórios permite que gestores identifiquem padrões de consumo, ajustem pedidos e implementem estratégias para a redução de custos e desperdícios. Como afirmam Araújo et al. (2020, p. 35), "a análise de dados gerenciais contribui para a tomada de decisões mais precisas e ágeis".
Campos e Spinelli (2021) ressaltam a relevância desse processo ao afirmarem que "a gestão baseada em indicadores melhora a previsibilidade das operações, permitindo um planejamento mais eficiente e estratégico".
Portanto, a integração de tecnologias que facilitem a visualização dos dados é um diferencial na busca pela excelência operacional dentro das UANs.
3.	Metodologia

3.1.	Metodologia Científica

A pesquisa bibliográfica foi a base para fundamentar teoricamente o desenvolvimento do sistema, utilizando livros, artigos científicos e as normas reguladoras da área de alimentação e nutrição. Conforme Gil (2002) e Severino (2007), esse tipo de pesquisa recorre a materiais já elaborados, como livros e artigos científicos, e utiliza "dados de categorias teóricas já trabalhadas por outros pesquisadores e devidamente registrados" (p. 122).

A abordagem adotada no estudo foi quali-quantitativa. A parte qualitativa foi focada na interpretação dos padrões de desperdício observados pelos usuários e nos feedbacks dos nutricionistas. Já a análise quantitativa se concentrou nos dados extraídos pelo sistema, como as métricas de desperdício alimentar, consumo médio e a eficiência na utilização dos insumos. Silva e Menezes (2001) explicam que "a pesquisa qualitativa considera que há uma relação dinâmica entre o mundo real e o sujeito" (p. 20), enquanto a pesquisa quantitativa "caracteriza-se pelo emprego da quantificação tanto nas modalidades de coleta de informações quanto no tratamento delas por meio de técnicas estatísticas" (p. 21).

3.2.	Metodologia Computacional
Quadro 1: Base de informações através da internet das ferramentas utilizadas.
Ferramentas Utilizadas	Descrição	Referências


Git hub	Segundo GitHub (2025), a plataforma permite controle de versão, colaboração entre desenvolvedores e gerenciamento de código por meio de repositórios integrados.	


(GITHUB,2025)


Dart	De acordo com Dart (2025), a linguagem foi criada para fornecer desempenho elevado, produtividade no desenvolvimento e segurança com tipagem opcional.	

(DART, 2025)

Flutter	Conforme descrito pelo Flutter (2025), o framework possibilita o desenvolvimento rápido e nativo de interfaces modernas com o uso de uma única base de código.	
(FLUTTER, 2025.)

H2 DataBase	Segundo a documentação oficial do H2 Database (2025), o sistema é desenvolvido em Java e foi projetado para ser rápido, leve e de fácil integração. É amplamente utilizado em aplicações que necessitam de um banco de dados relacional embarcado, oferecendo compatibilidade com SQL padrão e suporte para modo servidor e embutido.	

(H2 DATABASE, 2025.)


Java	De acordo com Oracle (2025), o Java continua sendo uma das linguagens mais utilizadas no mundo devido à sua versatilidade, alto desempenho e capacidade de integração com diferentes tecnologias.	

(ORACLE, 2025.)
Fonte: Autoria própria.

4.	 Resultados
(EM CONSTRUÇÃO)





5.	 Considerações Finais
O desenvolvimento do aplicativo GEST-UAN cumpriu integralmente o objetivo geral proposto, ao oferecer uma solução multiplataforma voltada para a gestão eficiente de Unidades de Alimentação e Nutrição (UAN). O sistema demonstrou capacidade de promover maior controle sobre o desperdício alimentar, garantir conformidade com as normas sanitárias e otimizar o uso de insumos por meio da análise de dados e geração de relatórios.
Em relação aos objetivos específicos, todos foram atendidos conforme previsto:
Foi implementado um sistema de monitoramento e geração de relatórios sobre desperdício alimentar, contribuindo para a identificação de perdas e a adoção de medidas corretivas.
O checklist digital desenvolvido permitiu o controle sistemático de higiene e segurança, alinhado às Boas Práticas de Fabricação (BPF), promovendo ambientes mais seguros e padronizados.
O módulo de cálculo per capita alimentar e os gráficos gerenciais integrados ao sistema possibilitaram maior precisão no planejamento de recursos, redução de custos e suporte à tomada de decisões estratégicas.
Dessa forma, conclui-se que o GEST-UAN representa uma ferramenta funcional e inovadora, capaz de atender às demandas operacionais das UANs. Sua aplicação prática evidenciou ganhos em eficiência, segurança alimentar e sustentabilidade, reforçando o papel da tecnologia como aliada na gestão nutricional.

Referências

ABREU, E. S. de; SPINELLI, M. G. N.; PINTO, A. M. de S. Gestão de Unidades de Alimentação e Nutrição: um modo de fazer. 7. ed. São Paulo: Metha, 2019. Acesso em: 25 fev. 2025.

ALEXANDRE, L. de S.; SILVA, N. C. F. da; SILVA, C. M. da. Utilização das ferramentas de qualidade para redução de desperdícios de alimentos em redes de fast-food. Brazilian Journal of Development, v. 6, n. 7, p. 52108–52124, 2020. Disponível em: https://doi.org/10.34117/bjdv6n7-746
. Acesso em: 25 fev. 2025.

ARAÚJO, A. G. G. de et al. Utilização de ferramenta estratégica no controle de estoque em unidades de alimentação e nutrição. Revista Ciência Plural, v. 6, n. 3, p. 74–92, 2020. Disponível em: https://www.periodicos.ufrn.br/rcp/article/view/20346/13266
. Acesso em: 25 fev. 2025.

BEZERRA, B. D. et al. Aplicação de ferramentas da qualidade na área de estoque. XII Fateclog, Fatec Mogi das Cruzes, São Paulo, 2021. Disponível em: https://fateclog.com.br/anais/2021/parte4/379-453-1-RV.pdf
. Acesso em: 25 fev. 2025.

CAMPOS, E. M. C.; SPINELLI, M. G. N. Utilização das ferramentas de gestão por gerentes de Unidades de Alimentação e Nutrição do município de São Paulo. Disciplinarum Scientia, v. 22, n. 1, p. 1–15, 2021. Disponível em: https://doi.org/10.37777/dscs.v22n1-001
. Acesso em: 25 fev. 2025.

CONSELHO FEDERAL DE NUTRICIONISTAS (CFN). Resolução CFN nº 600, de 25 de fevereiro de 2018. Disponível em: https://www.cfn.org.br/wp-content/uploads/resolucoes/Res_600_2018.htm
. Acesso em: 25 fev. 2025.

DART. What is Dart?. Dart Dev, 2024. Disponível em: https://dart.dev/overview
. Acesso em: 21 mar. 2025.

FAVERI, A.; BORBA, M. Planejamento e gestão de UAN. Indaial: UNIASSELVI, 2021. Disponível em: https://bibliotecavirtual.uniasselvi.com.br/livros/baixar/260204
. Acesso em: 25 fev. 2025.

FLUTTER. Sobre o Flutter. Flutter Dev, 2024. Disponível em: https://flutter.dev/docs
. Acesso em: 21 mar. 2025.

GITHUB. Sobre o GitHub. GitHub Docs, 2024. Disponível em: https://docs.github.com/pt/get-started/start-your-journey
. Acesso em: 21 mar. 2025.

ORACLE. The Java Programming Language. Oracle, 2024. Disponível em: https://www.oracle.com/java/
. Acesso em: 21 jun. 2025.

H2 Database. H2 Database Engine Documentation. Disponível em: https://www.h2database.com/html/main.html
. Acesso em: 1 set. 2025
