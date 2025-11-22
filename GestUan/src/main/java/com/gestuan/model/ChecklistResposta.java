// /model/ChecklistResposta.java
package com.gestuan.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;

import java.time.LocalDate;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;

@Entity
public class ChecklistResposta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Link para a Unidade que foi auditada
    @ManyToOne
    @JoinColumn(name = "unidade_id", nullable = false)
    private Unidade unidade;

    // Link para o Usuário que preencheu
    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario; // (Assumindo que sua entidade de usuário se chama 'User')

    @Column(nullable = false)
    private LocalDate dataPreenchimento;

    @Column(nullable = false)
    private String checklistType; // Ex: "AUDITORIA_QUALIDADE"

    private double pontuacaoFinal;

    // Lista de todas as respostas detalhadas
    @OneToMany(mappedBy = "checklistResposta", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference // Evita loop infinito no JSON
    private List<ChecklistRespostaItem> respostas;

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Unidade getUnidade() { return unidade; }
    public void setUnidade(Unidade unidade) { this.unidade = unidade; }
    public Usuario getUsuario() { return usuario; }
    public void setUsuario(Usuario usuario) { this.usuario = usuario; }
    public LocalDate getDataPreenchimento() { return dataPreenchimento; }
    public void setDataPreenchimento(LocalDate dataPreenchimento) { this.dataPreenchimento = dataPreenchimento; }
    public String getChecklistType() { return checklistType; }
    public void setChecklistType(String checklistType) { this.checklistType = checklistType; }
    public double getPontuacaoFinal() { return pontuacaoFinal; }
    public void setPontuacaoFinal(double pontuacaoFinal) { this.pontuacaoFinal = pontuacaoFinal; }
    public List<ChecklistRespostaItem> getRespostas() { return respostas; }
    public void setRespostas(List<ChecklistRespostaItem> respostas) { this.respostas = respostas; }
}