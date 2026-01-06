package br.feedback.config;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseConfig {
    
    public static void createTableIfNotExists(DataSource dataSource) {
        String sql = """
            CREATE TABLE IF NOT EXISTS feedback_entity (
                id UUID PRIMARY KEY,
                descricao TEXT NOT NULL,
                nota DECIMAL NOT NULL,
                data_envio TIMESTAMP NOT NULL,
                urgencia VARCHAR(20) NOT NULL
            )
            """;
            
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to create table", e);
        }
    }
}
