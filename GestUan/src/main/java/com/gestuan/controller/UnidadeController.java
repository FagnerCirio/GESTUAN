// UnidadeController.java
package com.gestuan.controller;

import com.gestuan.model.Unidade;
import com.gestuan.repository.UnidadeRepository;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/unidades")
@Transactional
public class UnidadeController {

    @Autowired
    private UnidadeRepository unidadeRepository;

    @GetMapping
    public List<Unidade> listarTodasAsUnidades() {
        return unidadeRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Unidade> buscarUnidadePorId(@PathVariable Long id) {
        return unidadeRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Unidade criarUnidade(@RequestBody Unidade unidade) {
        return unidadeRepository.save(unidade);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Unidade> atualizarUnidade(@PathVariable Long id, @RequestBody Unidade detalhesUnidade) {
        return unidadeRepository.findById(id)
                .map(unidadeExistente -> {
                    unidadeExistente.setNome(detalhesUnidade.getNome());
                    unidadeExistente.setEndereco(detalhesUnidade.getEndereco());
                    unidadeExistente.setEmpresa(detalhesUnidade.getEmpresa());
                    Unidade unidadeAtualizada = unidadeRepository.save(unidadeExistente);
                    return ResponseEntity.ok(unidadeAtualizada);
                }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletarUnidade(@PathVariable Long id) {
        return unidadeRepository.findById(id)
                .map(unidade -> {
                    unidadeRepository.delete(unidade);
                    return ResponseEntity.ok().build();
                }).orElse(ResponseEntity.notFound().build());
    }
}