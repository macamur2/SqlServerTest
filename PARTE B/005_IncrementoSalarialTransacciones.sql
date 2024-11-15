/*
    Hay que modificar el BusinessEntityID (XXXXX) por el departamento que se requiera.
    En principio la operación se realizará haciendo uso de transacciones y con un rollback en caso de errores.
*/

BEGIN TRY
    BEGIN TRANSACTION;
    -- Realizar las actualizaciones en la tabla
    UPDATE HumanResources.EmployeePayHistory
    SET Rate = Rate + (Rate * 0.05)
    WHERE BusinessEntityID = XXXXX;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
--> Puede gestionarse las salida de los errores con un mensaje
    PRINT 'Ha ocurrido un error en la actualización: ' + ERROR_MESSAGE();
END CATCH