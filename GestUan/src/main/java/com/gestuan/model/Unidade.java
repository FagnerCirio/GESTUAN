package com.gestuan.model;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.CascadeType; // Importação adicionada
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany; // Importação adicionada

@Entity
public class Unidade {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String endereco;
    private String cnpj;

    // 1. RELACIONAMENTO PARA CHECKLISTRESPOSTA (Corrigido no passo anterior)
    @OneToMany(mappedBy = "unidade", cascade = CascadeType.REMOVE, orphanRemoval = true)
    @JsonIgnore 
    private List<ChecklistResposta> checklistRespostas;

    // 2. RELACIONAMENTO PARA DESPERDICIO (NOVA CORREÇÃO)
    // O CascadeType.REMOVE garante que os registros de Desperdício sejam excluídos
    // ANTES da Unidade, resolvendo o último erro de Foreign Key.
    @OneToMany(mappedBy = "unidade", cascade = CascadeType.REMOVE, orphanRemoval = true)
    @JsonIgnore 
    private List<Desperdicio> desperdicios;
    
    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }
    @ManyToOne(optional = true) 
    @JoinColumn(name = "empresa_cnpj")
    private Empresa empresa;

    @ManyToMany(mappedBy = "unidades", fetch = FetchType.EAGER)
    private List<Usuario> usuarios;

    public Unidade() {}
    
    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }
    public Empresa getEmpresa() { return empresa; }
    public void setEmpresa(Empresa empresa) { this.empresa = empresa; }
    
    @JsonIgnore
    public List<Usuario> getUsuarios() { return usuarios; }
    public void setUsuarios(List<Usuario> usuarios) { this.usuarios = usuarios; }

    // Getters e Setters para Checklist Respostas
    public List<ChecklistResposta> getChecklistRespostas() {
        return checklistRespostas;
    }

    public void setChecklistRespostas(List<ChecklistResposta> checklistRespostas) {
        this.checklistRespostas = checklistRespostas;
    }

    // Getters e Setters para Desperdicios (NOVO)
    public List<Desperdicio> getDesperdicios() {
        return desperdicios;
    }

    public void setDesperdicios(List<Desperdicio> desperdicios) {
        this.desperdicios = desperdicios;
    }
}