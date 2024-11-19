--12.--

-- 1.  Sa se extraga informatii despre clientii care au rezervari de camere confirmate si care au participat la evenimente 
-- organizate de angajati din departamentul "Administrativ".

WITH Participari AS (
    SELECT DISTINCT P.ID_Client, P.ID_Eveniment
    FROM PARTICIPA P
),
Organizari AS (
    SELECT O.ID_Eveniment, E.Nume_Eveniment, E.Data_Inceput, E.Data_Sfarsit, E.Locatie, D.Nume_Departament
    FROM ORGANIZEAZA O
    JOIN EVENIMENTE E ON O.ID_Eveniment = E.ID_Eveniment
    JOIN PERSONAL P ON O.ID_Angajat = P.ID_Angajat
    JOIN DEPARTAMENTE D ON P.ID_Departament = D.ID_Departament
    WHERE D.Nume_Departament = 'Administrativ'
),
RezervariConfirmate AS (
    SELECT R.ID_Client, R.ID_Camera, R.Data_CheckIn, R.Data_CheckOut
    FROM REZERVARI R
    WHERE R.Status_Rezervare = 'confirmata'
)
SELECT C.ID_Client, C.Nume, C.Prenume, O.Nume_Eveniment, O.Data_Inceput, O.Data_Sfarsit, O.Locatie, R.Data_CheckIn, R.Data_CheckOut
FROM CLIENTI C
JOIN Participari P ON C.ID_Client = P.ID_Client
JOIN Organizari O ON P.ID_Eveniment = O.ID_Eveniment
JOIN RezervariConfirmate R ON C.ID_Client = R.ID_Client
ORDER BY C.ID_Client, O.Data_Inceput;


-- 2. Sa se extraga informatii (ID, nume, prenume, departament – coloana se va numi “DEPARTAMENT_ORGANIZATOR”) despre angajatii hotelului 
-- care au organizat evenimente la care numarul total de participanti este maxim. Sa se extraga si ID-ul si numele acestor evenimente.

WITH AngajatiOrganizatori AS (
    SELECT DISTINCT P.ID_Angajat, P.Nume, P.Prenume, D.Nume_Departament
    FROM ORGANIZEAZA O
    JOIN PERSONAL P ON O.ID_Angajat = P.ID_Angajat
    JOIN DEPARTAMENTE D ON P.ID_Departament = D.ID_Departament
),
EvenimenteParticipanti AS (
    SELECT O.ID_Eveniment, E.Nume_Eveniment, COUNT(DISTINCT P.ID_Client) AS Numar_Participanti
    FROM PARTICIPA P
    JOIN ORGANIZEAZA O ON P.ID_Eveniment = O.ID_Eveniment
    JOIN EVENIMENTE E ON O.ID_Eveniment = E.ID_Eveniment
    GROUP BY O.ID_Eveniment, E.Nume_Eveniment
)

SELECT 
    AO.ID_Angajat, AO.Nume, AO.Prenume,  AO.Nume_Departament AS "DEPARTAMENT_ORGANIZATOR", 
    PE.ID_Eveniment, PE.Nume_Eveniment, PE.Numar_Participanti
FROM AngajatiOrganizatori AO
JOIN (
    SELECT E.ID_Eveniment, E.Nume_Eveniment, E.Numar_Participanti
    FROM EvenimenteParticipanti E
    WHERE E.Numar_Participanti = (
        SELECT MAX(EP.Numar_Participanti)
        FROM EvenimenteParticipanti EP
    )
) PE ON EXISTS (
    SELECT 1
    FROM ORGANIZEAZA O
    WHERE O.ID_Angajat = AO.ID_Angajat AND O.ID_Eveniment = PE.ID_Eveniment
)
GROUP BY AO.ID_Angajat, AO.Nume, AO.Prenume, AO.Nume_Departament, PE.ID_Eveniment, PE.Nume_Eveniment, PE.Numar_Participanti;


-- 3. Sa se obtina o lista detaliata a angajatilor si produselor pe care acestia le-au gestionat. Pentru fiecare angajat, dorim sa afisam 
-- numele si prenumele sau, numarul total de produse gestionate si valoarea totala a produselor pe care le-au gestionat. Daca un angajat 
-- nu a gestionat niciun produs, vom afisa valoarea 0 în locul valorii totale a produselor. Vom ordona rezultatele în ordine descrescatoare 
-- dupa valoarea totala a produselor gestionate. În plus, sa se utilizeze DECODE pentru a atribui un rating angajatului în functie de 
-- numarul de produse gestionate. Se presupune ca un angajat care a gestionat mai mult de 10 produse primeste ratingul "Excelent", intre 
-- 5 si 10 produse ratingul "Bun", iar sub 5 produse ratingul "Satisfacator".

SELECT 
    P.ID_Angajat,
    P.Nume,
    P.Prenume,
    D.Nume_Departament,
    COUNT(IP.ID_Produs) AS Numar_Produse_Gestionate,
    NVL(SUM(IP.Cantitate * IP.Pret_Unitar), 0) AS Valoare_Totala_Produse,
    DECODE(COUNT(IP.ID_Produs),
            0, 'F?r? activitate',
            1, 'Satisf?c?tor',
            2, 4, 'Bun',
            5, 10, 'Excelent',
            'Excelent') AS Rating_Angajat,
    CASE 
        WHEN P.Telefon LIKE '07%' THEN 'Telefon validat'
        ELSE 'Telefon nevalidat'
    END AS Validare_Telefon
FROM PERSONAL P
LEFT JOIN INVENTAR_PRODUS IP ON P.ID_Angajat = IP.ID_Angajat
JOIN DEPARTAMENTE D ON P.ID_Departament = D.ID_Departament
GROUP BY P.ID_Angajat, P.Nume, P.Prenume, D.Nume_Departament, P.Telefon
ORDER BY Valoare_Totala_Produse DESC;


-- 4. Pentru fiecare client care a efectuat cel putin o rezervare confirmata, sa afisam urmatoarele informatii: ID-ul clientului, Numele complet 
-- al clientului (concatenarea numelui si prenumelui), Numele clientului din adresa de email, Numarul total de servicii utilizate in rezervarile 
-- sale, Evaluarea medie a recenziilor primite de la clienti, Lungimea numelui clientului (considerând ca un nume este lung daca are mai mult 
-- de 7 caractere), Primele 5 cifre din numarul de telefon, inlocuind celelalte cifre cu asteriscuri, Data de check-in a rezervarilor in formatul 
-- "zi.luna (cifre).an", Indicatorul daca clientul a lasat mai mult de o recenzie sau nu. Datele sa fie ordonate descrescator dupa numarul de servicii.

SELECT 
    C.ID_Client,
    CONCAT(CONCAT(C.NUME,' '), C.PRENUME) AS NUMELE_INTREG,
    SUBSTR(C.Email, 1, INSTR(C.Email, '@') - 1) AS Nume_Din_Email,
    COUNT(RS.ID_Rezervare_Serviciu) AS Numar_Servicii_Utilizate,
    AVG(RE.Evaluare) AS Evaluare_Medie_Recenzii,
    CASE 
        WHEN LENGTH(C.Nume) > 7 THEN 'Nume lung'
        ELSE 'Nume scurt sau mediu'
    END AS Lungime_Nume,
    SUBSTR(C.Telefon, 1, 5) || '*****' AS Primele_5_Cifre_Telefon,
    TO_CHAR(R.Data_CheckIn, 'DD.MM.YYYY') AS Data_CheckIn_Formatata,
    CASE 
        WHEN COUNT(RE.ID_Recenzie) > 1 THEN 'Da'
        ELSE 'Nu'
    END AS Mai_Multe_Recenzii
FROM 
    CLIENTI C
LEFT JOIN 
    REZERVARI R ON C.ID_Client = R.ID_Client
LEFT JOIN 
    REZERVARI_SERVICII RS ON R.ID_Rezervare = RS.ID_Rezervare
LEFT JOIN 
    RECENZII RE ON R.ID_Rezervare = RE.ID_Rezervare
WHERE 
    R.Status_Rezervare = 'confirmata'
GROUP BY 
    C.ID_Client,C.Nume, C.Prenume, SUBSTR(C.Email, 1, INSTR(C.Email, '@') - 1), C.Telefon, R.Data_CheckIn
ORDER BY 
    Numar_Servicii_Utilizate DESC;


-- 5. Sa se extraga numele complet al clientului, numarul total de nopti petrecute in rezervarile recente, suma totala cheltuita si numarul total de rezervari 
-- facute pentru clientii cu o activitate diversificata (adica cei cu cel putin trei inregistrari diferite in baza de date). Clientii vor fi clasificati ca 
-- 'Nou' sau 'Vechi' in functie de numarul de rezervari(>=2). Datele vor fi sortate descrescator dupa suma totala cheltuita


WITH RezervariRecent AS (
    SELECT 
        r.ID_Client,
        (r.Data_CheckOut - r.Data_CheckIn) AS Nopti,
        f.Total AS Suma,
        r.ID_Rezervare
    FROM 
        REZERVARI r
    JOIN 
        FACTURI f ON r.ID_Rezervare = f.ID_Rezervare
    WHERE 
        r.Data_CheckIn >= ADD_MONTHS(SYSDATE, -6)
), 
RezervariClient AS (
    SELECT
        ID_Client,
        COUNT(ID_Rezervare) AS NumarRezervari,
        SUM(Nopti) AS TotalNopti,
        SUM(Suma) AS SumaTotala
    FROM 
        RezervariRecent
    GROUP BY 
        ID_Client
)
SELECT
    c.ID_Client,
    c.Nume || ' ' || c.Prenume AS NumeComplet,
    rc.TotalNopti,
    rc.SumaTotala,
    rc.NumarRezervari,
    CASE 
        WHEN rc.NumarRezervari >= 2 THEN 'Vechi'
        ELSE 'Nou'
    END AS TipClient
FROM 
    CLIENTI c
JOIN 
    RezervariClient rc ON c.ID_Client = rc.ID_Client
HAVING
    (
        SELECT COUNT(DISTINCT t.ID_Tabela) 
        FROM (
            SELECT ID_Client AS ID_Tabela FROM RezervariRecent
            UNION ALL
            SELECT ID_Rezervare AS ID_Tabela FROM RezervariRecent
            UNION ALL
            SELECT ID_Factura AS ID_Tabela FROM FACTURI
        ) t
    ) >= 3
ORDER BY 
    rc.SumaTotala DESC;


--13.--

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



--14.--

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
AND ID_Eveniment = (SELECT ID_Eveniment FROM VizualizareComplexa WHERE Nume_Eveniment = 'Nuntă');

INSERT INTO VizualizareComplexa (ID_Client, Nume, Prenume, Email, Nume_Eveniment, Data_Inceput, Data_Sfarsit, Locatie, Data_CheckIn, Data_CheckOut)
VALUES (6, 'Maria', 'Ionescu', 'maria.ionescu@example.com', 'Workshop de Tehnologie', '2024-06-13', '2024-06-17', 'Sala Mare', '2024-06-15', '2024-06-16');



--15.--
--O cerere ce utilizează operația outerjoin pe minimum 4 tabele 
--Formulare: Să se creeze o cerere pentru a obține informații despre clienți, rezervările lor, recenziile pe care le-au lăsat și eventualele servicii rezervate în cadrul șederii lor,  folosind LEFT OUTER JOIN pentru a include toate rezervările, chiar și acelea care nu au recenzii sau servicii asociate.

SELECT 
    C.ID_Client, C.Nume, C.Prenume, C.Email,
    R.ID_Rezervare, R.Data_CheckIn, R.Data_CheckOut, R.Status_Rezervare,
    REC.Evaluare, REC.Comentariu,
    S.Nume_Serviciu, RS.Cantitate
FROM 
    CLIENTI C
LEFT OUTER JOIN 
    REZERVARI R ON C.ID_Client = R.ID_Client
LEFT OUTER JOIN 
    RECENZII REC ON R.ID_Rezervare = REC.ID_Rezervare
LEFT OUTER JOIN 
    REZERVARI_SERVICII RS ON R.ID_Rezervare = RS.ID_Rezervare
LEFT OUTER JOIN 
    SERVICII S ON RS.ID_Serviciu = S.ID_Serviciu
ORDER BY 
    C.ID_Client, R.ID_Rezervare;


