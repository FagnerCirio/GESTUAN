// /repository/ChecklistRespostaRepository.java
package com.gestuan.repository; 

import com.gestuan.model.ChecklistResposta;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChecklistRespostaRepository extends JpaRepository<ChecklistResposta, Long> {

    // Método para buscar checklists de uma unidade (este está correto)
    List<ChecklistResposta> findByUnidadeId(Long unidadeId);

    
    List<ChecklistResposta> findByUsuarioCrn(String crn);
}