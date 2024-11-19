CREATE VIEW VizualizareComplexa AS
WITH 
Organizari AS (
    SELECT O.ID_Eveniment, E.Nume_Eveniment, E.Data_Inceput, E.Data_Sfarsit, E.Locatie, D.Nume_Departament
    FROM ORGANIZEAZA O
    JOIN EVENIMENTE E ON O.ID_Eveniment = E.ID_Eveniment
    JOIN PERSONAL P ON O.ID_Angajat = P.ID_Angajat
    JOIN DEPARTAMENTE D ON P.ID_Departament = D.ID_Departament
    WHERE D.Nume_Departament = 'Receptie'
)
SELECT C.ID_Client, C.Nume, C.Prenume, C.Email, O.Nume_Eveniment, O.Data_Inceput, O.Data_Sfarsit, O.Locatie, R.Data_CheckIn, R.Data_CheckOut
FROM CLIENTI C
JOIN PARTICIPA P ON C.ID_Client = P.ID_Client
JOIN Organizari O ON P.ID_Eveniment = O.ID_Eveniment
JOIN REZERVARI R ON C.ID_Client = R.ID_Client
WHERE R.Status_Rezervare = 'confirmata';


DELETE FROM PARTICIPA
WHERE ID_Client = (SELECT ID_Client FROM VizualizareComplexa WHERE Nume = 'Georgescu' AND Prenume = ' Andrei')
AND ID_Eveniment = (SELECT ID_Eveniment FROM VizualizareComplexa WHERE Nume_Eveniment = 'Nunt?');

INSERT INTO VizualizareComplexa (ID_Client, Nume, Prenume, Email, Nume_Eveniment, Data_Inceput, Data_Sfarsit, Locatie, Data_CheckIn, Data_CheckOut)
VALUES (6, 'Maria', 'Ionescu', 'maria.ionescu@example.com', 'Workshop de Tehnologie', '2024-06-13', '2024-06-17', 'Sala Mare', '2024-06-15', '2024-06-16');



















