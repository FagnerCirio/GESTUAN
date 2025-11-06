package com.gestuan.model;

// Este é o DTO (Data Transfer Object) que usamos para os gráficos
public class DesperdicioStatsDTO {
    private String tipo;
    private Double totalPeso;
    private Long totalRefeicoes; // NOVO CAMPO ADICIONADO

    // CONSTRUTOR ATUALIZADO
    public DesperdicioStatsDTO(String tipo, Double totalPeso, Long totalRefeicoes) {
        this.tipo = tipo;
        this.totalPeso = totalPeso;
        this.totalRefeicoes = totalRefeicoes;
    }

    // Getters e Setters
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public Double getTotalPeso() { return totalPeso; }
    public void setTotalPeso(Double totalPeso) { this.totalPeso = totalPeso; }
    
    // GETTER E SETTER PARA O NOVO CAMPO
    public Long getTotalRefeicoes() { return totalRefeicoes; }
    public void setTotalRefeicoes(Long totalRefeicoes) { this.totalRefeicoes = totalRefeicoes; }
}
