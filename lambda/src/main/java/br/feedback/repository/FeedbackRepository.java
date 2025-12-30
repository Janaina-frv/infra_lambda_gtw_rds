package br.feedback.repository;

import br.feedback.entity.FeedbackEntity;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public interface FeedbackRepository extends PanacheRepository<FeedbackEntity> {



}
