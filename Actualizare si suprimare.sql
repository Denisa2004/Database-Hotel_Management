--1. 

UPDATE INVENTAR_PRODUS
SET Pret_Unitar = Pret_Unitar * 1.1  
WHERE ID_Angajat IN (
    SELECT ID_Angajat
    FROM PERSONAL
    WHERE ID_Departament = (
        SELECT ID_Departament
        FROM DEPARTAMENTE
        WHERE Nume_Departament = 'Curatenie'
    )
);

--2.

UPDATE REZERVARI
SET Data_CheckOut = Data_CheckOut + INTERVAL '2' DAY
WHERE 
    ID_Client = 2 
    AND Status_Rezervare = 'confirmata'
    AND Data_CheckIn > SYSDATE;


--3. 

DELETE FROM RECENZII
WHERE ID_Client IN (
    SELECT ID_Client
    FROM REZERVARI
    WHERE Status_Rezervare = 'anulata'
);












