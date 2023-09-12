-- Criação de tabelas:  -----------------------------------------------------------------------------------------------------------------
CREATE TABLE Patients (
    patient_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    contact VARCHAR(255)
);

CREATE TABLE Doctors (
    doctor_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(255) NOT NULL,
    office_hours VARCHAR(255)
);

CREATE TABLE Appointments (
    appointment_id SERIAL PRIMARY KEY,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    patient_id INT REFERENCES Patients(patient_id),
    doctor_id INT REFERENCES Doctors(doctor_id)
);

CREATE TABLE MedicalHistory (
    record_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patients(patient_id),
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT
);

-- PROCEDURES ---------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ScheduleAppointment(
    p_patient_id INT,
    p_doctor_id INT,
    p_appointment_date DATE,
    p_appointment_time TIME
) AS $$
BEGIN
    -- Verificar a disponibilidade do médico na data e hora especificadas
    IF EXISTS (
        SELECT 1
        FROM Appointments
        WHERE doctor_id = p_doctor_id
          AND appointment_date = p_appointment_date
          AND appointment_time = p_appointment_time
    ) THEN
        RAISE EXCEPTION 'O médico não está disponível nesse horário.';
    ELSE
        -- Agendar a consulta se o médico estiver disponível
        INSERT INTO Appointments (appointment_date, appointment_time, patient_id, doctor_id)
        VALUES (p_appointment_date, p_appointment_time, p_patient_id, p_doctor_id);
    END IF;
END;
$$ LANGUAGE plpgsql;


--Procedure "CancelAppointment" (Cancelar Consulta):
CREATE OR REPLACE PROCEDURE CancelAppointment(p_appointment_id INT) AS $$
BEGIN
    -- Verificar se o agendamento existe
    IF NOT EXISTS (
        SELECT 1
        FROM Appointments
        WHERE appointment_id = p_appointment_id
    ) THEN
        RAISE EXCEPTION 'Agendamento não encontrado.';
    ELSE
        -- Remover o agendamento se ele existir
        DELETE FROM Appointments WHERE appointment_id = p_appointment_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Procedure "UpdateMedicalHistory" (Atualizar Histórico Médico)
CREATE OR REPLACE PROCEDURE UpdateMedicalHistory(
    p_patient_id INT,
    p_diagnosis TEXT,
    p_treatment TEXT,
    p_prescription TEXT
) AS $$
BEGIN
    -- Inserir um novo registro no histórico médico
    INSERT INTO MedicalHistory (patient_id, diagnosis, treatment, prescription)
    VALUES (p_patient_id, p_diagnosis, p_treatment, p_prescription);
END;
$$ LANGUAGE plpgsql;

-- FUNCTIONS  ---------------------------------------------------------------------------------------------------------------------------

-- Calcula idade do paciente
CREATE OR REPLACE FUNCTION CalculatePatientAge(
    birthdate DATE
)
RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM age(current_date, birthdate));
END;
$$ LANGUAGE plpgsql;

-- Obter próxima consulta agendada
CREATE OR REPLACE FUNCTION GetNextAppointment(
    p_patient_id INT
)
RETURNS TABLE (
    appointment_date DATE,
    appointment_time TIME,
    doctor_name VARCHAR(255)
) AS $$
BEGIN
    RETURN QUERY (
        SELECT a.appointment_date, a.appointment_time, d.name
        FROM Appointments a
        INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
        WHERE a.patient_id = p_patient_id
        AND a.appointment_date >= current_date
        ORDER BY a.appointment_date, a.appointment_time
        LIMIT 1
    );
END;
$$ LANGUAGE plpgsql;

-- INSERTS ------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Patients (name, date_of_birth, contact) VALUES
    ('Maria Silva', '1990-05-10', 'maria@example.com'),
    ('João Santos', '1985-08-20', 'joao@example.com'),
    ('Ana Ferreira', '1995-02-15', 'ana@example.com'),
    ('Carlos Oliveira', '1980-11-30', 'carlos@example.com'),
    ('Isabel Martins', '1992-07-05', 'isabel@example.com'),
    ('Ricardo Mendes', '1988-04-18', 'ricardo@example.com'),
    ('Sofia Pereira', '1975-12-25', 'sofia@example.com'),
    ('Pedro Sousa', '1998-09-08', 'pedro@example.com'),
    ('Luisa Costa', '1993-03-12', 'luisa@example.com'),
    ('António Fernandes', '1970-06-28', 'antonio@example.com');
	
INSERT INTO Doctors (name, specialty, office_hours) VALUES
    ('Dr. Silva', 'Cardiologia', 'Segunda a Sexta, 09:00 - 17:00'),
    ('Dr. Santos', 'Dermatologia', 'Segunda a Sexta, 08:30 - 16:30'),
    ('Dra. Ferreira', 'Ginecologia', 'Terça e Quinta, 10:00 - 18:00'),
    ('Dra. Oliveira', 'Ortopedia', 'Quarta e Sexta, 08:00 - 16:00'),
    ('Dr. Martins', 'Pediatria', 'Segunda e Quarta, 08:00 - 16:00'),
    ('Dr. Mendes', 'Neurologia', 'Terça e Quinta, 09:30 - 17:30'),
    ('Dra. Pereira', 'Oftalmologia', 'Segunda a Sexta, 10:30 - 18:30'),
    ('Dr. Sousa', 'Psiquiatria', 'Terça e Quinta, 11:00 - 19:00'),
    ('Dra. Costa', 'Oncologia', 'Quarta e Sexta, 09:30 - 17:30'),
    ('Dr. Fernandes', 'Urologia', 'Segunda a Sexta, 08:00 - 16:00');
	
-- SELECTS E TESTES ---------------------------------------------------------------------------------------------------------------------

select * from Patients;
select * from Doctors;
select * from Appointments;
select * from MedicalHistory;

-- Agendar com procedure
-- Parâmetros: p_patient_id, p_doctor_id, p_appointment_date, p_appointment_time
CALL ScheduleAppointment(2, 2, '2023-09-15', '11:00:00');

-- Chamando a procedure para cancelar uma consulta ( lembrar de usar o ID da consulta )
CALL CancelAppointment(1);

-- Procedure para testar o Update Histórico Médico
-- Parameters: p_patient_id, p_diagnosis, p_treatment, p_prescription
CALL UpdateMedicalHistory(1, 'Febre alta', 'Antibióticos prescritos', 'Amoxicilina');

-- Function Calculate idade! ( DATA DE NASCIMENTO COMO ARGUMENTO )
SELECT CalculatePatientAge('1990-01-15') AS patient_age;

-- Chamando a função para obter a próxima consulta agendada para um paciente ( ID DO PACIENTE DE ARGUMENTO )
SELECT * FROM GetNextAppointment(2);





