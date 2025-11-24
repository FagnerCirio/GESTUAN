package com.gestuan.model;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.CascadeType; // Importação adicionada
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany; // Importação adicionada

@Entity
public class Empresa {

    @Id
    private String cnpj;

    private String nome;
    private String endereco;
    
    // NOVO RELACIONAMENTO: Mapeamento Um-para-Muitos para Unidade
    // O CascadeType.REMOVE garante que todas as Unidades vinculadas a esta Empresa
    // sejam excluídas antes que a Empresa seja removida, resolvendo a Foreign Key.
    @OneToMany(mappedBy = "empresa", cascade = CascadeType.REMOVE, orphanRemoval = true)
    @JsonIgnore // Recomendado para evitar loops de serialização JSON
    private List<Unidade> unidades; // O nome da variável é 'unidades'

    // Getters e Setters
    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    // Getters e Setters para Unidades (NOVOS MÉTODOS)
    public List<Unidade> getUnidades() {
        return unidades;
    }

    public void setUnidades(List<Unidade> unidades) {
        this.unidades = unidades;
    }
}