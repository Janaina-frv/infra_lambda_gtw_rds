package br.feedback.domain;

import java.time.Instant;
import java.util.UUID;

public class Feedback {
    private UUID id;
    private String descricao;
    private double nota;
    private Instant dataEnvio;

    public Feedback() {}

    public Feedback(UUID id, String descricao, double nota, Instant dataEnvio) {
        this.id = id;
        this.descricao = descricao;
        this.nota = nota;
        this.dataEnvio = dataEnvio;
    }

    // getters / setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public double getNota() { return nota; }
    public void setNota(double nota) { this.nota = nota; }

    public Instant getDataEnvio() { return dataEnvio; }
    public void setDataEnvio(Instant dataEnvio) { this.dataEnvio = dataEnvio; }
}
