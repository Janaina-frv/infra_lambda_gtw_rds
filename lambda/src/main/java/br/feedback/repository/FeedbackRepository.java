package br.feedback.repository;

import br.feedback.entity.FeedbackEntity;
import io.smallrye.mutiny.Uni;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public interface FeedbackRepository {
    
    Uni<Void> persist(FeedbackEntity feedback);

}
