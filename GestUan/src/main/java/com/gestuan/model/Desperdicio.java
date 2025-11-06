package com.gestuan.model;

import java.time.LocalDate;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class Desperdicio {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate data;
    private String tipo; // "Resto Ingesta" ou "Sobras Limpas"
    private Double peso; // Em quilos
    private String destino;

    // NOVO CAMPO ADICIONADO
    private Integer numeroRefeicoes; // Nº de refeições servidas naquele dia/tipo

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "unidade_id", nullable = false)
    private Unidade unidade;

    // Construtor, Getters e Setters
    public Desperdicio() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public LocalDate getData() { return data; }
    public void setData(LocalDate data) { this.data = data; }
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    public Double getPeso() { return peso; }
    public void setPeso(Double peso) { this.peso = peso; }
    public String getDestino() { return destino; }
    public void setDestino(String destino) { this.destino = destino; }

    // GETTER E SETTER PARA O NOVO CAMPO
    public Integer getNumeroRefeicoes() { return numeroRefeicoes; }
    public void setNumeroRefeicoes(Integer numeroRefeicoes) { this.numeroRefeicoes = numeroRefeicoes; }

    public Unidade getUnidade() { return unidade; }
    public void setUnidade(Unidade unidade) { this.unidade = unidade; }
}