// /repository/ChecklistRespostaItemRepository.java
package com.gestuan.repository; 
import com.gestuan.model.ChecklistRespostaItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChecklistRespostaItemRepository extends JpaRepository<ChecklistRespostaItem, Long> {
    
}