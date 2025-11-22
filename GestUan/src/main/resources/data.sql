-- ==================================================================================
-- 1. LIMPEZA SEGURA DA BASE DE DADOS (Ordem Obrigatória)
-- ==================================================================================

-- Primeiro: Apaga as respostas dos itens (o nível mais baixo da hierarquia)
DELETE FROM checklist_resposta_item;

-- Segundo: Apaga o cabeçalho das respostas
DELETE FROM checklist_resposta;

-- Terceiro: AGORA SIM, pode apagar as perguntas (itens do checklist)
DELETE FROM checklist_item;

-- (Opcional) Se quiser limpar unidades e empresas para evitar conflitos antigos:
-- DELETE FROM unidade;
-- DELETE FROM empresa;

-- ==================================================================================
-- 2. INSERÇÃO DOS DADOS (Seus Checklists)
-- ==================================================================================

-- CHECKLIST: AUDITORIA DE QUALIDADE

-- Seção: ESTRUTURA
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Piso de material impermeável, de fácil higienização, e em adequado estado de conservação, livres de rachaduras, trincas, goteiras, vazamentos, dentre outros e não transmitem contaminantes aos alimentos.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Paredes apresentam revestimentos lisos, impermeáveis, de cores claras, de fácil higienização, sem cortinas e adequado estado de conservação, livres de rachaduras, trincas, goteiras, vazamentos, infiltrações, bolores, descascamentos, dentre outros e não transmitem contaminantes aos alimentos.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Teto de material impermeável, de fácil higienização, de cor clara, em adequado estado de conservação, livres de rachaduras, trincas, goteiras, vazamentos, infiltrações, bolores, descascamentos, dentre outros e não transmitem contaminantes aos alimentos.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Portas das áreas de produção de alimentos possuem superfície lisa, de cores claras, de fácil higienização, bem conservadas e ajustadas aos batentes, com fechamento automático (mola ou similar).'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Janelas estão ajustadas aos batentes, possuem telas milimétricas limpas, sem furos, rasgos e em bom estado de conservação.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Iluminação adequada, uniforme, sem ofuscamento e não altera as características sensoriais dos alimentos. As luminárias localizadas sobre a área de preparação dos alimentos são apropriadas e estão protegidas contra explosão e quedas acidentais.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Ventilação garante a renovação do ar e a manutenção do ambiente livre de fungos, gases, fumaça, pós, partículas em suspensão, condensação de vapores, dentre outros. Possui sistema de exaustão com coifa limpa e em bom estado de conservação e funcionamento. Filtros de ar estão limpos.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Instalações sanitárias e vestiários dos manipuladores de alimentos estão conservados, organizados e limpos. Não se comunicam diretamente com a área de preparação e armazenamento dos alimentos ou refeitórios. Portas externas possuem fechamento automático.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Os produtos saneantes utilizados estão regularizados pelo Ministério da Saúde e são utilizados respeitando diluições e tempo de contato recomendados pelo fabricante.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Os utensílios e equipamentos utilizados na higienização estão em bom estado de conservação e são mantidos separados para cada finalidade (ex: piso, bancadas).'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'O estabelecimento dispõe de reservatório de água com tampa e em adequado estado de conservação e limpeza. É realizada análise da potabilidade da água semestralmente.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'O gelo utilizado em alimentos é fabricado a partir de água potável, mantido em condições higiênico-sanitárias que evitem sua contaminação. O vapor, quando utilizado em contato direto com alimentos ou com superfícies que entram em contato com alimentos, deve ser produzido a partir de água potável.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'Caixas de gordura são periodicamente limpas e estão localizadas fora da área de manipulação e armazenamento de alimentos.'),
('AUDITORIA_QUALIDADE', 'ESTRUTURA', 'O lixo é retirado frequentemente da área de manipulação e acondicionado adequadamente em sacos bem fechados e lixeiras tampadas.');

-- Seção: MANIPULADORES
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Os uniformes estão limpos, conservados e são utilizados somente nas dependências da UAN?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Apresentam-se com bom asseio corporal (banho, barba e bigode aparados)?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Estão com unhas curtas, limpas e sem esmalte?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Não utilizam adornos (anéis, alianças, brincos, pulseiras, relógios, etc.)?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Cabelos estão protegidos por redes ou toucas?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Não falam, cantam, tossem ou espirram sobre os alimentos?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Não manipulam dinheiro?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Lavam as mãos corretamente e com a frequência necessária?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Apresentam comprovante de saúde em dia (ASO)?'),
('AUDITORIA_QUALIDADE', 'MANIPULADORES', 'Possuem treinamento em Boas Práticas de Manipulação?');

-- Seção: EQUIPAMENTOS E UTENSÍLIOS
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'EQUIPAMENTOS E UTENSÍLIOS', 'Os equipamentos e utensílios estão em bom estado de conservação e higiene?'),
('AUDITORIA_QUALIDADE', 'EQUIPAMENTOS E UTENSÍLIOS', 'A manutenção programada e periódica dos equipamentos é realizada?'),
('AUDITORIA_QUALIDADE', 'EQUIPAMENTOS E UTENSÍLIOS', 'Os utensílios são guardados em local limpo e protegido?'),
('AUDITORIA_QUALIDADE', 'EQUIPAMENTOS E UTENSÍLIOS', 'As lixeiras são dotadas de tampa e pedal?'),
('AUDITORIA_QUALIDADE', 'EQUIPAMENTOS E UTENSÍLIOS', 'Os equipamentos de refrigeração possuem termômetro e estão com a temperatura adequada?'),
('AUDITORIA_QUALIDADE', 'EQUIPAMENTOS E UTENSÍLIOS', 'O local possui lavatórios exclusivos para higiene das mãos na área de manipulação, em posições estratégicas em relação ao fluxo de preparo dos alimentos e em número suficiente de modo a atender toda a área de preparação? Os lavatórios estão em bom estado de conservação e funcionamento, possuem sabonete líquido, papel toalha não reciclado e lixeira com tampa e acionamento por pedal?');

-- Seção: PRODUÇÃO
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'A matéria-prima é inspecionada no recebimento (embalagem, validade, temperatura, etc)?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'São utilizadas matérias-primas dentro do prazo de validade?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'Os alimentos são armazenados corretamente (temperatura, empilhamento, PVPS)?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'A higienização de hortifrutigranjeiros é realizada corretamente?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'O descongelamento dos alimentos é feito de forma adequada (refrigeração ou micro-ondas)?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'A manipulação dos alimentos evita contaminação cruzada (utensílios separados para crus e cozidos)?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'A temperatura de cocção dos alimentos atinge o mínimo recomendado (ex: 74°C no centro geométrico)?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'Os alimentos preparados são mantidos na temperatura correta até a distribuição (quentes acima de 60°C, frios abaixo de 5°C)?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'O óleo de fritura é trocado com a frequência necessária e descartado corretamente?'),
('AUDITORIA_QUALIDADE', 'PRODUÇÃO', 'As sobras de alimentos são gerenciadas corretamente (reaproveitamento seguro ou descarte)?');

-- Seção: DISTRIBUIÇÃO
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'DISTRIBUIÇÃO', 'Os equipamentos de distribuição (balcões térmicos, refrigerados) estão limpos e na temperatura correta?'),
('AUDITORIA_QUALIDADE', 'DISTRIBUIÇÃO', 'Os utensílios de serviço (pratos, talheres, copos) estão limpos e bem conservados?'),
('AUDITORIA_QUALIDADE', 'DISTRIBUIÇÃO', 'Os funcionários da distribuição estão devidamente uniformizados e higienizados?'),
('AUDITORIA_QUALIDADE', 'DISTRIBUIÇÃO', 'Há protetores salivares nos balcões de distribuição?'),
('AUDITORIA_QUALIDADE', 'DISTRIBUIÇÃO', 'Há controle para evitar que os clientes retornem ao buffet com pratos já utilizados?');

-- Seção: CONTROLE DE PRAGAS
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'CONTROLE DE PRAGAS', 'O estabelecimento possui comprovante de controle de pragas emitido por empresa especializada e licenciada?'),
('AUDITORIA_QUALIDADE', 'CONTROLE DE PRAGAS', 'Não há evidências de infestação por pragas (insetos, roedores)?'),
('AUDITORIA_QUALIDADE', 'CONTROLE DE PRAGAS', 'As medidas preventivas (telas, ralos sifonados, vedação) estão adequadas?');

-- Seção: DOCUMENTAÇÃO E REGISTROS
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'DOCUMENTAÇÃO E REGISTROS', 'Possui Manual de Boas Práticas e POPs (Procedimentos Operacionais Padronizados)?'),
('AUDITORIA_QUALIDADE', 'DOCUMENTAÇÃO E REGISTROS', 'Os registros de temperatura dos equipamentos são mantidos atualizados?'),
('AUDITORIA_QUALIDADE', 'DOCUMENTAÇÃO E REGISTROS', 'Os registros de higienização de equipamentos e instalações são mantidos?'),
('AUDITORIA_QUALIDADE', 'DOCUMENTAÇÃO E REGISTROS', 'Os registros de controle de pragas estão disponíveis?');

-- Seção: CONTROLE DE SAÚDE DOS MANIPULADORES
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'CONTROLE DE SAÚDE DOS MANIPULADORES', 'Existem cartazes de orientação aos manipuladores sobre a correta lavagem das mãos e demais hábitos de higiene, em locais de fácil visualização, inclusive nas instalações sanitárias e lavatórios?'),
('AUDITORIA_QUALIDADE', 'CONTROLE DE SAÚDE DOS MANIPULADORES', 'Existe supervisão da saúde dos manipuladores?');

-- Seção: TRANSPORTE DO ALIMENTO PREPARADO (Se aplicável)
INSERT INTO checklist_item (checklist_type, secao, item_avaliado) VALUES
('AUDITORIA_QUALIDADE', 'TRANSPORTE DO ALIMENTO PREPARADO', 'Os veículos são apropriados ao transporte de alimentos e encontram-se em adequado estado de conservação e higiene?'),
('AUDITORIA_QUALIDADE', 'TRANSPORTE DO ALIMENTO PREPARADO', 'Os alimentos são acondicionados em recipientes hermeticamente fechados e de material apropriado?'),
('AUDITORIA_QUALIDADE', 'TRANSPORTE DO ALIMENTO PREPARADO', 'A temperatura do alimento preparado no início e ao final do transporte é monitorada?');

-- ==================================================================================
-- CHECKLIST: CONTROLE DE EPIs (Baseado na NR-6)
-- ==================================================================================

-- Seção: PROTEÇÃO BÁSICA E UNIFORMES
INSERT INTO checklist_item (checklist_type, secao, item_avaliado, legislacao_de_referencia) VALUES
('CHECKLIST_EPI', 'PROTEÇÃO BÁSICA', 'Todos os manipuladores estão utilizando uniforme completo (calça, camisa/jaleco) limpo e em bom estado?', 'NR-6 / RDC 216'),
('CHECKLIST_EPI', 'PROTEÇÃO BÁSICA', 'Os calçados de segurança são fechados, antiderrapantes e estão em bom estado de conservação?', 'NR-6'),
('CHECKLIST_EPI', 'PROTEÇÃO BÁSICA', 'O uso de toucas ou redes de proteção para cabelos está sendo cumprido por todos na área de produção?', 'RDC 216');

-- Seção: EPIs PARA ATIVIDADES ESPECÍFICAS (Térmico e Químico)
INSERT INTO checklist_item (checklist_type, secao, item_avaliado, legislacao_de_referencia) VALUES
('CHECKLIST_EPI', 'ATIVIDADES ESPECÍFICAS', 'As luvas de proteção térmica (para fornos e panelas quentes) estão disponíveis e sem furos ou desgaste excessivo?', 'NR-6'),
('CHECKLIST_EPI', 'ATIVIDADES ESPECÍFICAS', 'Existe jaqueta térmica com capuz e calça para acesso às câmaras frias (se aplicável)?', 'NR-6'),
('CHECKLIST_EPI', 'ATIVIDADES ESPECÍFICAS', 'Luvas de borracha cano longo e aventais impermeáveis estão disponíveis para a equipe de higienização pesada e lavagem de panelas?', 'NR-6'),
('CHECKLIST_EPI', 'ATIVIDADES ESPECÍFICAS', 'Óculos de proteção estão disponíveis para manipulação de produtos químicos fortes (ex: desincrustantes)?', 'NR-6');

-- Seção: GESTÃO E DOCUMENTAÇÃO
INSERT INTO checklist_item (checklist_type, secao, item_avaliado, legislacao_de_referencia) VALUES
('CHECKLIST_EPI', 'GESTÃO E REGISTROS', 'A Ficha de Entrega de EPIs está assinada e atualizada para todos os funcionários?', 'NR-6 - 6.6.1'),
('CHECKLIST_EPI', 'GESTÃO E REGISTROS', 'Os EPIs possuem Certificado de Aprovação (CA) válido?', 'NR-6'),
('CHECKLIST_EPI', 'GESTÃO E REGISTROS', 'É realizado treinamento periódico sobre o uso correto, guarda e conservação dos EPIs?', 'NR-6 - 6.6.1');