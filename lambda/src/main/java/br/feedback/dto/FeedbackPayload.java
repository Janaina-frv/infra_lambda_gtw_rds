package br.feedback.dto;

import br.feedback.service.Urgencia;

public record FeedbackPayload(
        String descricao,
        Double nota,
        Urgencia urgencia
) {
}
