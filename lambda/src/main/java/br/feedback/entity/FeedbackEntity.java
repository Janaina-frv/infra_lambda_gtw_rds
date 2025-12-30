package br.feedback.entity;

import br.feedback.domain.Feedback;
import io.quarkus.hibernate.orm.panache.PanacheEntity;
import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

import java.time.Instant;
import java.util.UUID;

@Entity
public class FeedbackEntity extends PanacheEntityBase {

    @Id
    public UUID id;
    private String descricao;
    private double nota;
    private Instant dataEnvio;

    public static FeedbackEntity fromDomain(Feedback feedback) {
        FeedbackEntity entity = new FeedbackEntity();
        entity.id = feedback.getId();
        entity.descricao = feedback.getDescricao();
        entity.nota = feedback.getNota();
        entity.dataEnvio = feedback.getDataEnvio();
        return entity;
    }
    
}
