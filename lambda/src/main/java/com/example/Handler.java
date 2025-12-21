package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Map;

public class Handler implements RequestHandler<APIGatewayV2HTTPEvent, APIGatewayV2HTTPResponse> {

    private static final ObjectMapper mapper = new ObjectMapper();

    private void criarTabelaSeNaoExistir(Connection conn) throws SQLException {
        String sql = """
        CREATE TABLE IF NOT EXISTS items (
            id SERIAL PRIMARY KEY,
            descricao VARCHAR(255) NOT NULL,
            nota DOUBLE PRECISION NOT NULL
        )
        """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.execute();
        }
    }


    @Override
    public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent event, Context context) {

        try {
            context.getLogger().log("Evento recebido: " + event);
            context.getLogger().log("Body recebido: " + event.getBody());

            String rawBody = event.getBody();

            if (rawBody == null || rawBody.isEmpty()) {
                throw new RuntimeException("Body está vazio ou null");
            }

            ItemRequest request = mapper.readValue(rawBody, ItemRequest.class);

            context.getLogger().log("Item: " + request.getDescricao() + " | " + request.getNota());

            salvarNoBanco(request);

            return APIGatewayV2HTTPResponse.builder()
                    .withStatusCode(201)
                    .withHeaders(Map.of("Content-Type", "application/json"))
                    .withBody(rawBody)
                    .build();

        } catch (Exception e) {
            context.getLogger().log("ERRO: " + e.toString());
            for (StackTraceElement s : e.getStackTrace()) {
                context.getLogger().log(s.toString());
            }

            return APIGatewayV2HTTPResponse.builder()
                    .withStatusCode(500)
                    .withBody("{\"erro\":\"Erro ao processar requisição\"}")
                    .build();
        }
    }


    private void salvarNoBanco(ItemRequest item) throws Exception {

        String url = "jdbc:postgresql://" + System.getenv("DB_HOST") + ":5432/" + System.getenv("DB_NAME");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");

        String sql = "INSERT INTO items (descricao, nota) VALUES (?, ?)";

        try (Connection conn = DriverManager.getConnection(url, user, pass)) {
            // 1️⃣ cria a tabela se não existir
            criarTabelaSeNaoExistir(conn);

            // 2️⃣ insere o item
            String sqlInsert = "INSERT INTO items (descricao, nota) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sqlInsert)) {
                stmt.setString(1, item.getDescricao());
                stmt.setDouble(2, item.getNota());
                stmt.executeUpdate();
            }
        }

    }
}
