package com.gestuan.repository;

import com.gestuan.model.Desperdicio;
import com.gestuan.model.DesperdicioStatsDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface DesperdicioRepository extends JpaRepository<Desperdicio, Long> {

List<Desperdicio> findByUnidadeId(Long unidadeId);

@Query("SELECT new com.gestuan.model.DesperdicioStatsDTO(d.tipo, d.destino, SUM(d.peso), SUM(d.numeroRefeicoes)) " +
"FROM Desperdicio d " +
"WHERE d.unidade.id = :unidadeId " +
"GROUP BY d.tipo, d.destino")

List<DesperdicioStatsDTO> findDesperdicioStatsByUnidade(Long unidadeId);
}