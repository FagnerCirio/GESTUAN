// /controller/ChecklistRespostaController.java
package com.gestuan.controller; 

import com.gestuan.model.ChecklistResposta;
import com.gestuan.model.ChecklistRespostaItem;
import com.gestuan.model.Unidade;
import com.gestuan.model.Usuario; 
import com.gestuan.model.ChecklistItem;
import com.gestuan.repository.ChecklistRespostaRepository;
import com.gestuan.repository.UnidadeRepository;
import com.gestuan.repository.UsuarioRepository; 
import com.gestuan.repository.ChecklistItemRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/checklist-respostas")
public class ChecklistRespostaController {

    @Autowired
    private ChecklistRespostaRepository checklistRespostaRepository;

    @Autowired
    private UnidadeRepository unidadeRepository; 

    @Autowired
    private UsuarioRepository usuarioRepository; 

    @Autowired
    private ChecklistItemRepository checklistItemRepository; 

    @PostMapping("/salvar")
    public ResponseEntity<ChecklistResposta> salvarRespostas(@RequestBody ChecklistResposta resposta) {
        try {
            // 1. "Hidratar" os objetos principais (Unidade e Usuário)
            Unidade unidade = unidadeRepository.findById(resposta.getUnidade().getId())
                    .orElseThrow(() -> new RuntimeException("Unidade não encontrada com id: " + resposta.getUnidade().getId()));
            
            // Lógica .getCrn() que já tínhamos definido
            Usuario usuario = usuarioRepository.findById(resposta.getUsuario().getCrn()) 
                    .orElseThrow(() -> new RuntimeException("Usuário não encontrado com crn: " + resposta.getUsuario().getCrn()));

            resposta.setUnidade(unidade);
            resposta.setUsuario(usuario); 

            // 2. Setar a data atual
            resposta.setDataPreenchimento(LocalDate.now());

            // 3. "Hidratar" os itens filhos (ChecklistItem)
            if (resposta.getRespostas() != null) {
                // Esta linha (e as seguintes) falhavam por não encontrar o 'ChecklistRespostaItem'
                for (ChecklistRespostaItem itemResposta : resposta.getRespostas()) { 
                    
                    ChecklistItem itemOriginal = checklistItemRepository.findById(itemResposta.getChecklistItem().getId())
                            .orElseThrow(() -> new RuntimeException("Item de Checklist não encontrado com id: " + itemResposta.getChecklistItem().getId()));
                    
                    itemResposta.setChecklistItem(itemOriginal);

                    // 4. Manter a consistência bidirecional
                    itemResposta.setChecklistResposta(resposta);
                }
            }

            // 5. Salvar
            ChecklistResposta respostaSalva = checklistRespostaRepository.save(resposta);

            return ResponseEntity.ok(respostaSalva);

        } catch (Exception e) {
            e.printStackTrace(); 
            return ResponseEntity.status(500).body(null);
        }
    }
}