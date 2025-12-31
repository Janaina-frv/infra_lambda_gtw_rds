package br.feedback;

import io.quarkus.runtime.Startup;
import io.quarkus.runtime.StartupEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import org.jboss.logging.Logger;

@Startup
@ApplicationScoped
public class AppLifeCycleBean {

    private static final Logger LOG = Logger.getLogger(AppLifeCycleBean.class);

    void onStart(@Observes StartupEvent ev) {
        LOG.info("Aplicação iniciada");
    }
}
