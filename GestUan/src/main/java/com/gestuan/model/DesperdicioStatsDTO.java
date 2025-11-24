package com.gestuan.model;

// Este é o DTO (Data Transfer Object) que usamos para os gráficos
public class DesperdicioStatsDTO {
    private String tipo;
    private String destino; // <--- CAMPO ADICIONADO PARA AGRUPAMENTO POR DESTINO
    private Double totalPeso;
    private Long totalRefeicoes;

    // CONSTRUTOR ATUALIZADO PARA INCLUIR O DESTINO
    public DesperdicioStatsDTO(String tipo, String destino, Double totalPeso, Long totalRefeicoes) {
        this.tipo = tipo;
        this.destino = destino; // Inicializa o novo campo
        this.totalPeso = totalPeso;
        this.totalRefeicoes = totalRefeicoes;
    }

    // Getters e Setters
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    
    // GETTER E SETTER PARA O NOVO CAMPO 'DESTINO'
    public String getDestino() { return destino; }
    public void setDestino(String destino) { this.destino = destino; }
    
    public Double getTotalPeso() { return totalPeso; }
    public void setTotalPeso(Double totalPeso) { this.totalPeso = totalPeso; }
    
    public Long getTotalRefeicoes() { return totalRefeicoes; }
    public void setTotalRefeicoes(Long totalRefeicoes) { this.totalRefeicoes = totalRefeicoes; }
}