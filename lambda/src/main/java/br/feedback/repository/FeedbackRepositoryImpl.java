package br.feedback.repository;

import br.feedback.entity.FeedbackEntity;
import jakarta.enterprise.context.ApplicationScoped;

import java.util.UUID;

@ApplicationScoped
public class FeedbackRepositoryImpl implements FeedbackRepository {

    public FeedbackEntity findById(UUID id) {
        return find("id", id).firstResult();
    }
}
