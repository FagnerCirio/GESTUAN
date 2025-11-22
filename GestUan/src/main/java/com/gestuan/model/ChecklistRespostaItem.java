// /model/ChecklistRespostaItem.java
package com.gestuan.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Column;

import com.fasterxml.jackson.annotation.JsonBackReference;

@Entity
public class ChecklistRespostaItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Link para o "cabeçalho" da resposta
    @ManyToOne
    @JoinColumn(name = "checklist_resposta_id", nullable = false)
    @JsonBackReference // Evita loop infinito no JSON
    private ChecklistResposta checklistResposta;

    // Link para a "pergunta" original
    @ManyToOne
    @JoinColumn(name = "checklist_item_id", nullable = false)
    private ChecklistItem checklistItem;

    @Column(nullable = false)
    private String resposta; // "C", "NC" ou "NA"

    @Column(length = 2048) // Mesmo tamanho da pergunta
    private String observacao;

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public ChecklistResposta getChecklistResposta() { return checklistResposta; }
    public void setChecklistResposta(ChecklistResposta checklistResposta) { this.checklistResposta = checklistResposta; }
    public ChecklistItem getChecklistItem() { return checklistItem; }
    public void setChecklistItem(ChecklistItem checklistItem) { this.checklistItem = checklistItem; }
    public String getResposta() { return resposta; }
    public void setResposta(String resposta) { this.resposta = resposta; }
    public String getObservacao() { return observacao; }
    public void setObservacao(String observacao) { this.observacao = observacao; }
}