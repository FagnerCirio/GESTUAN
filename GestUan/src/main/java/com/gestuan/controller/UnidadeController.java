// UnidadeController.java
package com.gestuan.controller;

import com.gestuan.model.Unidade;
import com.gestuan.model.Empresa; // 🎯 Necessário para a busca
import com.gestuan.repository.UnidadeRepository;
import com.gestuan.repository.EmpresaRepository; // 🎯 Necessário para a busca

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.persistence.EntityNotFoundException; // Necessário para a exceção

import java.util.List;
import java.util.Optional; 

@RestController
// 🎯 CORREÇÃO 1: Adicionar '/api' para resolver o erro 404
@RequestMapping("/api/unidades")
@Transactional
public class UnidadeController {

    @Autowired
    private UnidadeRepository unidadeRepository;
    // 🎯 Necessário para buscar a Empresa
    @Autowired 
    private EmpresaRepository empresaRepository; 

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

    // 🎯 MÉTODO POST CORRIGIDO (Lógica de busca por CNPJ restaurada)
    @PostMapping
    public Unidade criarUnidade(@RequestBody Unidade unidade) {
        
        // 1. EXTRAÇÃO SEGURA DO CNPJ para garantir que é 'final' para o lambda
        final String cnpjEmpresa = (unidade.getEmpresa() != null) 
                                 ? unidade.getEmpresa().getCnpj() 
                                 : null;
        
        // 2. Checa obrigatoriedade (Lança a exceção do erro 500 original)
        if (cnpjEmpresa == null || cnpjEmpresa.isEmpty()) {
            throw new EntityNotFoundException("O CNPJ da Empresa é obrigatório para cadastrar a unidade.");
        }
        
        // 3. BUSCA A EMPRESA COMPLETA NO BANCO PELO CNPJ (ID)
        Empresa empresaCompleta = empresaRepository.findById(cnpjEmpresa) 
            .orElseThrow(() -> new EntityNotFoundException("Empresa não encontrada com CNPJ: " + cnpjEmpresa));

        // 4. Associa a entidade COMPLETA e PERSISTIDA
        unidade.setEmpresa(empresaCompleta);
            
        // 5. Salva a Unidade
        return unidadeRepository.save(unidade);
    }
    
    // 🎯 MÉTODO PUT CORRIGIDO (Também precisa da lógica de busca)
    @PutMapping("/{id}")
    public ResponseEntity<Unidade> atualizarUnidade(@PathVariable Long id, @RequestBody Unidade detalhesUnidade) {
        return unidadeRepository.findById(id)
                .map(unidadeExistente -> {
                    unidadeExistente.setNome(detalhesUnidade.getNome());
                    unidadeExistente.setEndereco(detalhesUnidade.getEndereco());

                    final String cnpjEmpresa = (detalhesUnidade.getEmpresa() != null)
                                             ? detalhesUnidade.getEmpresa().getCnpj()
                                             : null;

                    // Atualização da Empresa
                    if (cnpjEmpresa != null && !cnpjEmpresa.isEmpty()) {
                        Empresa empresaCompleta = empresaRepository.findById(cnpjEmpresa)
                            .orElseThrow(() -> new EntityNotFoundException("Empresa não encontrada para atualização."));
                        unidadeExistente.setEmpresa(empresaCompleta);
                    } else {
                        throw new EntityNotFoundException("O CNPJ da Empresa é obrigatório para atualizar a unidade.");
                    }

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