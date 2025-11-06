package com.gestuan.repository;

import com.gestuan.model.Unidade;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UnidadeRepository extends JpaRepository<Unidade, Long> {
    // O tipo do ID é Long porque usamos @GeneratedValue na entidade Unidade
}
