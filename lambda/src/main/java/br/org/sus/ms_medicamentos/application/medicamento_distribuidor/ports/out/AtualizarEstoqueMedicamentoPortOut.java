package br.org.sus.ms_medicamentos.application.medicamento_distribuidor.ports.out;

import br.org.sus.ms_medicamentos.domain.MedicamentoDistribuidor;

import java.util.UUID;

public interface AtualizarEstoqueMedicamentoPortOut {

    MedicamentoDistribuidor adicionarQuantidade(UUID uuidMedicamentoDistribuidor, int qtdAdicionada);
}
