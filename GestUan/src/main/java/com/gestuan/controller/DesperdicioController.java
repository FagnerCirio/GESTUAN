// DesperdicioController.java
package com.gestuan.controller;

import com.gestuan.model.Desperdicio;
import com.gestuan.repository.DesperdicioRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.gestuan.model.DesperdicioStatsDTO;

import java.util.List;


@RestController
@RequestMapping("/api/unidades/{unidadeId}/desperdicio")
@Transactional
public class DesperdicioController {

    @Autowired
    private DesperdicioRepository desperdicioRepository;

    // Busca registros de desperdício de uma unidade específica
    @GetMapping("/stats")
    public List<DesperdicioStatsDTO> getDesperdicioStats(@PathVariable Long unidadeId) {
        return desperdicioRepository.findDesperdicioStatsByUnidade(unidadeId);
    }


    // Adiciona um registro de desperdício a uma unidade específica
    @PostMapping
    public Desperdicio adicionarRegistro(@PathVariable Long unidadeId, @RequestBody Desperdicio desperdicio) {
        // A lógica para associar a unidade ao desperdicio será feita no service ou aqui
        // Por simplicidade, o frontend enviará o objeto Unidade aninhado
        return desperdicioRepository.save(desperdicio);
    }
    
    // O delete pode continuar separado ou aqui, mas vamos simplificar por agora
}