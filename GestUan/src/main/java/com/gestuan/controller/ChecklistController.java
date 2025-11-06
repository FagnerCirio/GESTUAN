// ChecklistController.java
package com.gestuan.controller;

import com.gestuan.model.ChecklistItem;
import com.gestuan.repository.ChecklistItemRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/checklists")
@Transactional
public class ChecklistController {

    @Autowired
    private ChecklistItemRepository checklistItemRepository;

    // MÉTODO ATUALIZADO para receber o tipo de checklist
    // Ex: GET /api/checklists/items?type=LIMPEZA
    @GetMapping("/items")
    public List<ChecklistItem> getChecklistItemsByType(@RequestParam String type) {
        return checklistItemRepository.findByChecklistType(type);
    }
}