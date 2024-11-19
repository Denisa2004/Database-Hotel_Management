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
