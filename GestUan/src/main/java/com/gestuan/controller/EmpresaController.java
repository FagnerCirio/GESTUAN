package com.gestuan.controller;

import com.gestuan.model.Empresa;
import com.gestuan.repository.EmpresaRepository;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
// Mapeamento correto para resolver o erro 404
@RequestMapping("/api/empresas") 
@Transactional
public class EmpresaController {

    @Autowired
    private EmpresaRepository empresaRepository;

    @GetMapping
    public List<Empresa> listarTodasAsEmpresas() {
        return empresaRepository.findAll();
    }

    @GetMapping("/{cnpj}")
    public ResponseEntity<Empresa> buscarEmpresaPorCnpj(@PathVariable String cnpj) {
        // Uso correto do map no Optional
        return empresaRepository.findById(cnpj)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Empresa criarEmpresa(@RequestBody Empresa empresa) {
        return empresaRepository.save(empresa);
    }

    @PutMapping("/{cnpj}")
    public ResponseEntity<Empresa> atualizarEmpresa(@PathVariable String cnpj, @RequestBody Empresa detalhesEmpresa) {
        return empresaRepository.findById(cnpj)
                .map(empresaExistente -> {
                    // Copia os dados do corpo da requisição para a entidade existente
                    empresaExistente.setNome(detalhesEmpresa.getNome());
                    empresaExistente.setEndereco(detalhesEmpresa.getEndereco());
                    
                    Empresa empresaAtualizada = empresaRepository.save(empresaExistente);
                    return ResponseEntity.ok(empresaAtualizada);
                }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{cnpj}")
    public ResponseEntity<?> deletarEmpresa(@PathVariable String cnpj) {
        return empresaRepository.findById(cnpj)
                .map(empresa -> {
                    empresaRepository.delete(empresa);
                    // Retorna 204 No Content para indicar sucesso na exclusão sem corpo de resposta
                    return ResponseEntity.noContent().build(); 
                }).orElse(ResponseEntity.notFound().build());
    }
}