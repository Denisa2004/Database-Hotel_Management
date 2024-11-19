-- Crearea tabelelor 

CREATE TABLE DEPARTAMENTE (
    ID_Departament INT PRIMARY KEY,
    Nume_Departament VARCHAR(50),
    Descriere VARCHAR(255)
);

CREATE TABLE PERSONAL (
    ID_Angajat INT PRIMARY KEY,
    Nume VARCHAR(50),
    Prenume VARCHAR(50),
    Telefon VARCHAR(15),
    ID_Departament INT,
    FOREIGN KEY (ID_Departament) REFERENCES DEPARTAMENTE(ID_Departament)
);

CREATE TABLE INVENTAR_PRODUS (
    ID_Produs INT PRIMARY KEY,
    Nume_Produs VARCHAR(50),
    Categorie VARCHAR(50),
    Cantitate INT,
    Pret_Unitar DECIMAL(10,2),
    ID_Angajat INT,
    FOREIGN KEY (ID_Angajat) REFERENCES PERSONAL(ID_Angajat)
);

CREATE TABLE EVENIMENTE (
    ID_Eveniment INT PRIMARY KEY,
    Nume_Eveniment VARCHAR(100),
    Data_Inceput DATE,
    Data_Sfarsit DATE,
    Descriere VARCHAR(500),
    Locatie VARCHAR(100)
);

CREATE TABLE ORGANIZEAZA (
    ID_Angajat INT,
    ID_Eveniment INT,
    PRIMARY KEY (ID_Angajat, ID_Eveniment),
    FOREIGN KEY (ID_Angajat) REFERENCES PERSONAL(ID_Angajat),
    FOREIGN KEY (ID_Eveniment) REFERENCES EVENIMENTE(ID_Eveniment)
);

CREATE TABLE CLIENTI (
    ID_Client INT PRIMARY KEY,
    Nume VARCHAR(50),
    Prenume VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Telefon VARCHAR(15),
    Adresa VARCHAR(255)
);

CREATE TABLE PARTICIPA (
    ID_Client INT,
    ID_Eveniment INT,
    PRIMARY KEY (ID_Client, ID_Eveniment),
    FOREIGN KEY (ID_Client) REFERENCES CLIENTI(ID_Client),
    FOREIGN KEY (ID_Eveniment) REFERENCES EVENIMENTE(ID_Eveniment)
);

CREATE TABLE CAMERE (
    ID_Camera INT PRIMARY KEY,
    Numar_Camera INT UNIQUE,
    Tip_Camera VARCHAR(30),
    Capacitate INT,
    Pret_Noapte DECIMAL(10,2),
    Status VARCHAR(20)
);

CREATE TABLE REZERVARI (
    ID_Rezervare INT PRIMARY KEY,
    ID_Client INT,
    ID_Camera INT,
    Data_CheckIn DATE,
    Data_CheckOut DATE,
    Status_Rezervare VARCHAR(20),
    FOREIGN KEY (ID_Client) REFERENCES CLIENTI(ID_Client),
    FOREIGN KEY (ID_Camera) REFERENCES CAMERE(ID_Camera)
);

CREATE TABLE RECENZII (
    ID_Recenzie INT PRIMARY KEY,
    ID_Client INT,
    ID_Rezervare INT,
    Evaluare INT,
    Comentariu VARCHAR(500),
    FOREIGN KEY (ID_Client) REFERENCES CLIENTI(ID_Client),
    FOREIGN KEY (ID_Rezervare) REFERENCES REZERVARI(ID_Rezervare)
);

CREATE TABLE SERVICII (
    ID_Serviciu INT PRIMARY KEY,
    Nume_Serviciu VARCHAR(50),
    Descriere VARCHAR(255),
    Pret DECIMAL(10,2)
);

CREATE TABLE REZERVARI_SERVICII (
    ID_Rezervare_Serviciu INT PRIMARY KEY,
    ID_Rezervare INT,
    ID_Serviciu INT,
    Cantitate INT,
    FOREIGN KEY (ID_Rezervare) REFERENCES REZERVARI(ID_Rezervare),
    FOREIGN KEY (ID_Serviciu) REFERENCES SERVICII(ID_Serviciu)
);

CREATE TABLE FACTURI (
    ID_Factura INT PRIMARY KEY,
    ID_Rezervare INT,
    Data_Emitere DATE,
    Total DECIMAL(10,2),
    FOREIGN KEY (ID_Rezervare) REFERENCES REZERVARI(ID_Rezervare)
);

CREATE TABLE PLATI (
    ID_Plata INT PRIMARY KEY,
    ID_Factura INT,
    Data_Plata DATE,
    Suma DECIMAL(10,2),
    Metoda_Plata VARCHAR(30),
    FOREIGN KEY (ID_Factura) REFERENCES FACTURI(ID_Factura)
);


-- Inserarea datelor

INSERT INTO CLIENTI (ID_Client, Nume, Prenume, Email, Telefon, Adresa) VALUES (clienti_seq.NEXTVAL, 'Popescu', 'Ion', 'ion.popescu@example.com', '0712345678', 'Strada Mare 1');
INSERT INTO CLIENTI (ID_Client, Nume, Prenume, Email, Telefon, Adresa) VALUES (clienti_seq.NEXTVAL, 'Ionescu', 'Maria', 'maria.ionescu@example.com', '0722345678', 'Strada Mica 2');
INSERT INTO CLIENTI (ID_Client, Nume, Prenume, Email, Telefon, Adresa) VALUES (clienti_seq.NEXTVAL, 'Georgescu', 'Andrei', 'andrei.georgescu@example.com', '0732345678', 'Strada Mediana 3');
INSERT INTO CLIENTI (ID_Client, Nume, Prenume, Email, Telefon, Adresa) VALUES (clienti_seq.NEXTVAL, 'Vasilescu', 'Ana', 'ana.vasilescu@example.com', '0742345678', 'Strada Noua 4');
INSERT INTO CLIENTI (ID_Client, Nume, Prenume, Email, Telefon, Adresa) VALUES (clienti_seq.NEXTVAL, 'Dumitrescu', 'Radu', 'radu.dumitrescu@example.com', '0752345678', 'Strada Veche 5');

INSERT INTO CAMERE (ID_Camera, Numar_Camera, Tip_Camera, Capacitate, Pret_Noapte, Status) VALUES (camere_seq.NEXTVAL, 101, 'Single', 1, 100.00, 'libera');
INSERT INTO CAMERE (ID_Camera, Numar_Camera, Tip_Camera, Capacitate, Pret_Noapte, Status) VALUES (camere_seq.NEXTVAL, 102, 'Double', 2, 150.00, 'libera');
INSERT INTO CAMERE (ID_Camera, Numar_Camera, Tip_Camera, Capacitate, Pret_Noapte, Status) VALUES (camere_seq.NEXTVAL, 103, 'Suite', 4, 250.00, 'ocupata');
INSERT INTO CAMERE (ID_Camera, Numar_Camera, Tip_Camera, Capacitate, Pret_Noapte, Status) VALUES (camere_seq.NEXTVAL, 104, 'Single', 1, 100.00, 'in curatenie');
INSERT INTO CAMERE (ID_Camera, Numar_Camera, Tip_Camera, Capacitate, Pret_Noapte, Status) VALUES (camere_seq.NEXTVAL, 105, 'Double', 2, 150.00, 'libera');

INSERT INTO REZERVARI (ID_Rezervare, ID_Client, ID_Camera, Data_CheckIn, Data_CheckOut, Status_Rezervare) VALUES (rezervari__seq.NEXTVAL, 1, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-05', 'YYYY-MM-DD'), 'anulata');
INSERT INTO REZERVARI (ID_Rezervare, ID_Client, ID_Camera, Data_CheckIn, Data_CheckOut, Status_Rezervare) VALUES (rezervari__seq.NEXTVAL, 2, 2, TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-06-06', 'YYYY-MM-DD'), 'confirmata');
INSERT INTO REZERVARI (ID_Rezervare, ID_Client, ID_Camera, Data_CheckIn, Data_CheckOut, Status_Rezervare) VALUES (rezervari__seq.NEXTVAL, 3, 3, TO_DATE('2024-06-03', 'YYYY-MM-DD'), TO_DATE('2024-06-07', 'YYYY-MM-DD'), 'confirmata');
INSERT INTO REZERVARI (ID_Rezervare, ID_Client, ID_Camera, Data_CheckIn, Data_CheckOut, Status_Rezervare) VALUES (rezervari__seq.NEXTVAL, 4, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-06-08', 'YYYY-MM-DD'), 'anulata');
INSERT INTO REZERVARI (ID_Rezervare, ID_Client, ID_Camera, Data_CheckIn, Data_CheckOut, Status_Rezervare) VALUES (rezervari__seq.NEXTVAL, 5, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-09', 'YYYY-MM-DD'), 'in asteptare');

INSERT INTO PERSONAL (ID_Angajat, Nume, Prenume, Telefon, ID_Departament) VALUES (personal_seq.NEXTVAL, 'Marin', 'Elena', '0712345679', 1);
INSERT INTO PERSONAL (ID_Angajat, Nume, Prenume, Telefon, ID_Departament) VALUES (personal_seq.NEXTVAL, 'Dobre', 'Cristian', '0722345679', 2);
INSERT INTO PERSONAL (ID_Angajat, Nume, Prenume, Telefon, ID_Departament) VALUES (personal_seq.NEXTVAL, 'Radu', 'Alexandra', '0732345679', 3);
INSERT INTO PERSONAL (ID_Angajat, Nume, Prenume, Telefon, ID_Departament) VALUES (personal_seq.NEXTVAL, 'Nicoara', 'Vlad', '0742345679', 4);
INSERT INTO PERSONAL (ID_Angajat, Nume, Prenume, Telefon, ID_Departament) VALUES (personal_seq.NEXTVAL, 'Ionescu', 'Dana', '0752345679', 5);

INSERT INTO DEPARTAMENTE (ID_Departament, Nume_Departament, Descriere) VALUES (departamente_seq.NEXTVAL, 'Administrativ', 'Gestioneaza administrarea hotelului');
INSERT INTO DEPARTAMENTE (ID_Departament, Nume_Departament, Descriere) VALUES (departamente_seq.NEXTVAL, 'Receptie', 'Receptioneaza si asista clientii');
INSERT INTO DEPARTAMENTE (ID_Departament, Nume_Departament, Descriere) VALUES (departamente_seq.NEXTVAL, 'Curatenie', 'Asigura curatenia in hotel');
INSERT INTO DEPARTAMENTE (ID_Departament, Nume_Departament, Descriere) VALUES (departamente_seq.NEXTVAL, 'Bucatarie', 'Pregateste ?i serveste masa');
INSERT INTO DEPARTAMENTE (ID_Departament, Nume_Departament, Descriere) VALUES (departamente_seq.NEXTVAL, 'Securitate', 'Asigura securitatea in hotel');

INSERT INTO SERVICII (ID_Serviciu, Nume_Serviciu, Descriere, Pret) VALUES (servicii_seq.NEXTVAL, 'Room Service', 'Serviciu de masa in camer?', 50.00);
INSERT INTO SERVICII (ID_Serviciu, Nume_Serviciu, Descriere, Pret) VALUES (servicii_seq.NEXTVAL, 'Spa', 'Acces la spa si masaj', 100.00);
INSERT INTO SERVICII (ID_Serviciu, Nume_Serviciu, Descriere, Pret) VALUES (servicii_seq.NEXTVAL, 'Fitness', 'Acces la sala de fitness', 30.00);
INSERT INTO SERVICII (ID_Serviciu, Nume_Serviciu, Descriere, Pret) VALUES (servicii_seq.NEXTVAL, 'Transfer Aeroport', 'Serviciu de transfer de la/la aeroport', 75.00);
INSERT INTO SERVICII (ID_Serviciu, Nume_Serviciu, Descriere, Pret) VALUES (servicii_seq.NEXTVAL, 'Curatatorie', 'Serviciu de curatatorie si spalatorie', 20.00);

INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 1, 1, 2);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 2, 2, 1);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 3, 3, 3);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 4, 4, 2);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 5, 5, 4);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 1, 2, 1);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 2, 1, 3);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 3, 5, 1);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 4, 4, 2);
INSERT INTO REZERVARI_SERVICII (ID_Rezervare_Serviciu, ID_Rezervare, ID_Serviciu, Cantitate) VALUES (rezervari_servicii_seq.NEXTVAL, 5, 3, 4);

INSERT INTO FACTURI (ID_Factura, ID_Rezervare, Data_Emitere, Total) VALUES (facturi_seq.NEXTVAL, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 250.00);
INSERT INTO FACTURI (ID_Factura, ID_Rezervare, Data_Emitere, Total) VALUES (facturi_seq.NEXTVAL, 2, TO_DATE('2024-06-03', 'YYYY-MM-DD'), 450.00);
INSERT INTO FACTURI (ID_Factura, ID_Rezervare, Data_Emitere, Total) VALUES (facturi_seq.NEXTVAL, 3, TO_DATE('2024-06-02', 'YYYY-MM-DD'), 650.00);
INSERT INTO FACTURI (ID_Factura, ID_Rezervare, Data_Emitere, Total) VALUES (facturi_seq.NEXTVAL, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), 200.00);
INSERT INTO FACTURI (ID_Factura, ID_Rezervare, Data_Emitere, Total) VALUES (facturi_seq.NEXTVAL, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), 150.00);

INSERT INTO PLATI (ID_Plata, ID_Factura, Data_Plata, Suma, Metoda_Plata) VALUES (plati_seq.NEXTVAL, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 250.00, 'Card');
INSERT INTO PLATI (ID_Plata, ID_Factura, Data_Plata, Suma, Metoda_Plata) VALUES (plati_seq.NEXTVAL, 2, TO_DATE('2024-06-03', 'YYYY-MM-DD'), 450.00, 'Card');
INSERT INTO PLATI (ID_Plata, ID_Factura, Data_Plata, Suma, Metoda_Plata) VALUES (plati_seq.NEXTVAL, 3, TO_DATE('2024-06-02', 'YYYY-MM-DD'), 650.00, 'Cash');
INSERT INTO PLATI (ID_Plata, ID_Factura, Data_Plata, Suma, Metoda_Plata) VALUES (plati_seq.NEXTVAL, 4, TO_DATE('2024-06-04', 'YYYY-MM-DD'), 200.00, 'Transfer Bancar');
INSERT INTO PLATI (ID_Plata, ID_Factura, Data_Plata, Suma, Metoda_Plata) VALUES (plati_seq.NEXTVAL, 5, TO_DATE('2024-06-05', 'YYYY-MM-DD'), 150.00, 'Card');

INSERT INTO RECENZII (ID_Recenzie, ID_Client, ID_Rezervare, Evaluare, Comentariu) VALUES (recenzii_seq.NEXTVAL, 1, 1, 5, 'Excelent!');
INSERT INTO RECENZII (ID_Recenzie, ID_Client, ID_Rezervare, Evaluare, Comentariu) VALUES (recenzii_seq.NEXTVAL, 2, 2, 4, 'Foarte bun.');
INSERT INTO RECENZII (ID_Recenzie, ID_Client, ID_Rezervare, Evaluare, Comentariu) VALUES (recenzii_seq.NEXTVAL, 3, 3, 3, 'Mediocru.');
INSERT INTO RECENZII (ID_Recenzie, ID_Client, ID_Rezervare, Evaluare, Comentariu) VALUES (recenzii_seq.NEXTVAL, 4, 4, 2, 'Nu prea bun.');
INSERT INTO RECENZII (ID_Recenzie, ID_Client, ID_Rezervare, Evaluare, Comentariu) VALUES (recenzii_seq.NEXTVAL, 5, 5, 1, 'Foarte slab.');

INSERT INTO INVENTAR_PRODUS (ID_Produs, Nume_Produs, Categorie, Cantitate, Pret_Unitar, ID_Angajat) VALUES (inventar_produs_seq.NEXTVAL, 'Sampon', 'Igiena', 100, 10.00, 1);
INSERT INTO INVENTAR_PRODUS (ID_Produs, Nume_Produs, Categorie, Cantitate, Pret_Unitar, ID_Angajat) VALUES (inventar_produs_seq.NEXTVAL, 'Prosop', 'Lenjerie', 50, 20.00, 2);
INSERT INTO INVENTAR_PRODUS (ID_Produs, Nume_Produs, Categorie, Cantitate, Pret_Unitar, ID_Angajat) VALUES (inventar_produs_seq.NEXTVAL, 'Sapun', 'Igiena', 200, 5.00, 3);
INSERT INTO INVENTAR_PRODUS (ID_Produs, Nume_Produs, Categorie, Cantitate, Pret_Unitar, ID_Angajat) VALUES (inventar_produs_seq.NEXTVAL, 'Halat', 'Lenjerie', 30, 50.00, 4);
INSERT INTO INVENTAR_PRODUS (ID_Produs, Nume_Produs, Categorie, Cantitate, Pret_Unitar, ID_Angajat) VALUES (inventar_produs_seq.NEXTVAL, 'Papuci', 'Accesorii', 70, 15.00, 5);

INSERT INTO EVENIMENTE (ID_Eveniment, Nume_Eveniment, Data_Inceput, Data_Sfarsit, Descriere, Locatie) VALUES (evenimente_seq.NEXTVAL, 'Conferinta de IT', TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-03', 'YYYY-MM-DD'), 'Conferinta internationala de IT', 'Sala Mare');
INSERT INTO EVENIMENTE (ID_Eveniment, Nume_Eveniment, Data_Inceput, Data_Sfarsit, Descriere, Locatie) VALUES (evenimente_seq.NEXTVAL, 'Nunta', TO_DATE('2024-06-04', 'YYYY-MM-DD'), TO_DATE('2024-06-05', 'YYYY-MM-DD'), 'Ceremonie si receptie de nunta', 'Sala de Bal');
INSERT INTO EVENIMENTE (ID_Eveniment, Nume_Eveniment, Data_Inceput, Data_Sfarsit, Descriere, Locatie) VALUES (evenimente_seq.NEXTVAL, 'Workshop Marketing', TO_DATE('2024-06-05', 'YYYY-MM-DD'), TO_DATE('2024-06-09', 'YYYY-MM-DD'), 'Workshop de marketing digital', 'Sala Conferinte');
INSERT INTO EVENIMENTE (ID_Eveniment, Nume_Eveniment, Data_Inceput, Data_Sfarsit, Descriere, Locatie) VALUES (evenimente_seq.NEXTVAL, 'Bal caritabil', TO_DATE('2024-06-02', 'YYYY-MM-DD'), TO_DATE('2024-06-04', 'YYYY-MM-DD'), 'Bal caritabil pentru strangere de fonduri', 'Sala Mare');
INSERT INTO EVENIMENTE (ID_Eveniment, Nume_Eveniment, Data_Inceput, Data_Sfarsit, Descriere, Locatie) VALUES (evenimente_seq.NEXTVAL, 'Lansare de produs', TO_DATE('2024-06-06', 'YYYY-MM-DD'), TO_DATE('2024-06-09', 'YYYY-MM-DD'), 'Lansare noului produs tehnologic', 'Sala de Bal');

INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (1, 1);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (2, 2);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (3, 3);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (4, 4);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (5, 5);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (1, 2);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (2, 3);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (3, 4);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (4, 5);
INSERT INTO ORGANIZEAZA (ID_Angajat, ID_Eveniment) VALUES (5, 1);

INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (1, 2);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (2, 2);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (3, 3);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (2, 3);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (5, 3);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (2, 4);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (5, 4);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (4, 4);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (5, 5);
INSERT INTO PARTICIPA (ID_Eveniment, ID_Client) VALUES (3, 1);





