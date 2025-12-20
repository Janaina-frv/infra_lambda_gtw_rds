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

    @Override
    public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent event, Context context) {

        try {
            // 1️⃣ Ler o body exatamente como veio
            String rawBody = event.getBody();

            // 2️⃣ Converter JSON → objeto
            ItemRequest request = mapper.readValue(rawBody, ItemRequest.class);

            // 3️⃣ Gravar no banco
            salvarNoBanco(request);

            // 4️⃣ Retornar exatamente o JSON recebido
            return APIGatewayV2HTTPResponse.builder()
                    .withStatusCode(201)
                    .withHeaders(Map.of("Content-Type", "application/json"))
                    .withBody(rawBody)
                    .build();

        } catch (Exception e) {
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

        try (Connection conn = DriverManager.getConnection(url, user, pass);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, item.getDescricao());
            stmt.setDouble(2, item.getNota());
            stmt.executeUpdate();
        }
    }
}
