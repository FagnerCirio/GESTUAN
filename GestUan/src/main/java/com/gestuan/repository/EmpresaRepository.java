package com.gestuan.repository;

import com.gestuan.model.Empresa;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EmpresaRepository extends JpaRepository<Empresa, String> {
    // O tipo do ID é String porque usamos o CNPJ como identificador
}