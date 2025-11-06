
package com.gestuan.controller; 

public class LoginRequest {
    private String crn;
    private String senha;

    // Getters e Setters
    public String getCrn() {
        return crn;
    }

    public void setCrn(String crn) {
        this.crn = crn;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }
}