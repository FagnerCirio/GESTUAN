// UsuarioController.java
package com.gestuan.controller;

import com.gestuan.model.Usuario;
import com.gestuan.repository.UsuarioRepository;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usuarios")
@Transactional 
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping
    public List<Usuario> listarTodosOsUsuarios() {
        return usuarioRepository.findAll();
    }

    @GetMapping("/{crn}")
    public ResponseEntity<Usuario> buscarUsuarioPorCrn(@PathVariable String crn) {
        return usuarioRepository.findById(crn)
                .map(usuario -> ResponseEntity.ok().body(usuario))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Usuario> criarUsuario(@RequestBody Usuario usuario) {
        if (usuarioRepository.existsById(usuario.getCrn())) {
            return ResponseEntity.status(409).build(); 
        }
        
        String senhaCodificada = passwordEncoder.encode(usuario.getSenha());
        usuario.setSenha(senhaCodificada);
        Usuario novoUsuario = usuarioRepository.save(usuario);
        return ResponseEntity.status(201).body(novoUsuario);
    }

    @PutMapping("/{crn}")
    public ResponseEntity<Usuario> atualizarUsuario(@PathVariable String crn, @RequestBody Usuario detalhesUsuario) {
        return usuarioRepository.findById(crn)
                .map(usuarioExistente -> {
                    usuarioExistente.setNome(detalhesUsuario.getNome());
                    usuarioExistente.setEmail(detalhesUsuario.getEmail());

                    if (detalhesUsuario.getSenha() != null && !detalhesUsuario.getSenha().isEmpty()) {
                        usuarioExistente.setSenha(passwordEncoder.encode(detalhesUsuario.getSenha()));
                    }

                    Usuario usuarioAtualizado = usuarioRepository.save(usuarioExistente);
                    return ResponseEntity.ok(usuarioAtualizado);
                }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{crn}")
    public ResponseEntity<?> deletarUsuario(@PathVariable String crn) {
        return usuarioRepository.findById(crn)
                .map(usuario -> {
                    usuarioRepository.delete(usuario);
                    return ResponseEntity.noContent().build();
                }).orElse(ResponseEntity.notFound().build());
    }
}