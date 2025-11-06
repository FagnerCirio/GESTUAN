package com.gestuan.controller;

import com.gestuan.model.Empresa;
import com.gestuan.repository.EmpresaRepository;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/empresas")
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
                    empresaExistente.setNome(detalhesEmpresa.getNome());
                    // AJUSTE AQUI: Adicionando a atualização do endereço
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
                    return ResponseEntity.ok().build();
                }).orElse(ResponseEntity.notFound().build());
    }
}