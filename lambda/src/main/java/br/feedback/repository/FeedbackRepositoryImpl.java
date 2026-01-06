package br.feedback.repository;

import br.feedback.entity.FeedbackEntity;
import io.smallrye.mutiny.Uni;
import io.vertx.mutiny.sqlclient.Pool;
import io.vertx.mutiny.sqlclient.Tuple;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class FeedbackRepositoryImpl implements FeedbackRepository {

    @Inject
    Pool client;


    @Override
    public Uni<Void> persist(FeedbackEntity feedback) {
        if (feedback == null) {
            return Uni.createFrom().failure(new IllegalArgumentException("Feedback não pode ser nulo"));
        }

        String sql = """
            INSERT INTO feedback_entity (id, descricao, nota, data_envio, urgencia)
            VALUES ($1, $2, $3, $4, $5)
            """;

        return client.preparedQuery(sql)
                .execute(Tuple.of(
                        feedback.getId(),
                        feedback.getDescricao(),
                        feedback.getNota(),
                        feedback.getDataEnvio(),
                        feedback.getUrgencia().name()
                ))
                .onItem().ignore().andContinueWithNull();
    }
}