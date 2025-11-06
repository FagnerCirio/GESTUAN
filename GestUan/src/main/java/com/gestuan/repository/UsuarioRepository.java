package com.gestuan.repository;

import com.gestuan.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UsuarioRepository extends JpaRepository<Usuario, String> {
    // O tipo do ID é String porque usei o  CRN como identificador
}
