package br.feedback.service;

import br.feedback.domain.Feedback;
import br.feedback.dto.FeedbackPayload;
import br.feedback.entity.FeedbackEntity;
import br.feedback.repository.FeedbackRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import org.eclipse.microprofile.reactive.messaging.Channel;
import org.eclipse.microprofile.reactive.messaging.Emitter;

import java.time.Instant;
import java.util.UUID;

@ApplicationScoped
public class FeedbackService {

    @Inject
    @Channel("feedbacks-out")
    private Emitter<String> emitter;

    @Inject
    FeedbackRepository repository;

    private final ObjectMapper mapper = new ObjectMapper();

    //@Transactional
    public Feedback avaliar(String descricao, Double nota) throws Exception {
        if (descricao == null || descricao.isBlank()) {
            throw new IllegalArgumentException("Descrição é obrigatória");
        }
        if (nota == null || nota < 0 || nota > 10) {
            throw new IllegalArgumentException("Nota deve ser entre 0 e 10");
        }

        Feedback feedback = new Feedback(UUID.randomUUID(), descricao, nota, Instant.now());

        Urgencia urgencia = calcularUrgencia(nota);

        if (urgencia == Urgencia.URGENTE) {
            FeedbackPayload payload = new FeedbackPayload(feedback.getDescricao(), feedback.getNota(), urgencia);
            String json = mapper.writeValueAsString(payload);
            emitter.send(json);
        }
        salvar(feedback);
        return feedback;
    }

    private Urgencia calcularUrgencia(Double nota) {
        if (nota >= 8.0) return Urgencia.NAO_URGENTE;
        if (nota >= 5.0) return Urgencia.MEDIO;
        return Urgencia.URGENTE;
    }

    @Transactional
    public void salvar(Feedback feedback){
        FeedbackEntity entity = FeedbackEntity.fromDomain(feedback);
        repository.persist(entity);
    }
}
