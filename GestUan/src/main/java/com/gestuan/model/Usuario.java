package com.gestuan.model;

import java.util.ArrayList;
import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;

@Entity
public class Usuario {
    @Id
    private String crn;
    private String nome;
    private String email;
    private String senha;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
      name = "usuario_unidade",
      joinColumns = @JoinColumn(name = "usuario_crn"),
      inverseJoinColumns = @JoinColumn(name = "unidade_id"))
    private List<Unidade> unidades = new ArrayList<>();

    public Usuario() {}

    // Getters e Setters
    public String getCrn() { return crn; }
    public void setCrn(String crn) { this.crn = crn; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }
    
    @JsonIgnore
    public List<Unidade> getUnidades() { return unidades; }
    public void setUnidades(List<Unidade> unidades) { this.unidades = unidades; }
}