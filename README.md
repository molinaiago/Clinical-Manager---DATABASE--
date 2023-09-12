# Clinical Manager
 A small activity involving functions and procedures in the subject of database programming.

Sistema de Gestão de Clínica Médica

❏ Seu grupo foi designado para desenvolver um sistema de gestão para uma clínica médica. O sistema deve permitir o gerenciamento de pacientes, médicos, agendamentos de consultas e históricos médicos. 
❏ Tabelas:
❏ Patients: Armazena informações dos pacientes, incluindo nome, data de nascimento e contato.
❏ Doctors: Mantém dados sobre os médicos da clínica, como nome, especialidade e horários de atendimento.
❏ Appointments: Registra os agendamentos de consultas, incluindo data, hora, paciente e médico responsável.
❏ MedicalHistory: Armazenar os históricos médicos dos pacientes, contendo diagnósticos, tratamentos e prescrições. 

❏ Procedures: 
❏ ScheduleAppointment: Uma procedure para agendar uma nova consulta, verificando a disponibilidade do médico e registrando o agendamento.
❏ CancelAppointment: Uma procedure que cancela um agendamento, liberando o horário do médico. 
❏ UpdateMedicalHistory: Uma procedure que atualiza o histórico médico de um paciente, inserindo novos registros. 

❏ Functions: 
❏ CalculatePatientAge: Uma função que, dada a data de nascimento de um paciente, calcula a idade atual.
❏ GetNextAppointment: Uma função que retorna a próxima consulta agendada para um paciente.
