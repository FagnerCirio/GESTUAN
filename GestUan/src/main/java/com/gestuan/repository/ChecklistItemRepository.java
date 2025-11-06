// ChecklistItemRepository.java
package com.gestuan.repository;

import com.gestuan.model.ChecklistItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List; // Importar

@Repository
public interface ChecklistItemRepository extends JpaRepository<ChecklistItem, Long> {

    // Novo método para buscar itens por tipo de checklist
    List<ChecklistItem> findByChecklistType(String checklistType);
}