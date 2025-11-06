// ChecklistItem.java
package com.gestuan.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Column;

@Entity
public class ChecklistItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // NOVO CAMPO PARA DIFERENCIAR OS CHECKLISTS
    @Column(nullable = false)
    private String checklistType; // Ex: "AUDITORIA_QUALIDADE", "LIMPEZA", "REFRIGERACAO"

    @Column(nullable = false, length = 1024)
    private String secao;

    @Column(nullable = false, length = 2048)
    private String itemAvaliado;

    private String legislacaoDeReferencia;

    public ChecklistItem() {}

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getChecklistType() { return checklistType; }
    public void setChecklistType(String checklistType) { this.checklistType = checklistType; }
    public String getSecao() { return secao; }
    public void setSecao(String secao) { this.secao = secao; }
    public String getItemAvaliado() { return itemAvaliado; }
    public void setItemAvaliado(String itemAvaliado) { this.itemAvaliado = itemAvaliado; }
    public String getLegislacaoDeReferencia() { return legislacaoDeReferencia; }
    public void setLegislacaoDeReferencia(String legislacaoDeReferencia) { this.legislacaoDeReferencia = legislacaoDeReferencia; }
}