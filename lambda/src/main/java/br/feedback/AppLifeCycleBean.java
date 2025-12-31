package br.feedback;

import io.quarkus.runtime.Startup;
import io.quarkus.runtime.StartupEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Startup
@ApplicationScoped
public class AppLifeCycleBean {

    private static final Logger LOG =
            LoggerFactory.getLogger(AppLifeCycleBean.class);

    void onStart(@Observes StartupEvent ev) {
        // Código executado na inicialização da aplicação
        System.out.println("Aplicação iniciada.");
    }
}
