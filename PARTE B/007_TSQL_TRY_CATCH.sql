/*
   Se puede utilizar como ejemplo el ejercicio 005 realizado anteriormente.

   Ésta query tiene varias secciones bien diferenciadas, haciendo uso de bloqueos de manera de errores dentro de una transacción.
   Esto significa que todas las operaciones de la transacción se tratarán como una unidad. Si todo en la transacción tiene éxito, se confirma con COMMIT TRANSACTION
   Si ocurre algún error, la transacción se deshace completamente con ROLLBACK TRANSACTION, asegurando que no queden cambios parciales.

   Si ocurre un error durante la ejecución del UPDATE o cualquier otra instrucción dentro del bloque TRY, lo que ésto hace:
      - Se ejecute el bloque CATCH
      - Dentro del CATCH se llama a ROLLBACK TRANSACTION, revirtiendo los cambios realizados en la transacción, asegurande que la base de datos quede en el estado
      original antes de que se iniciara la transacción.

      Adicionalmente, utilizo la función ERROR_MESSAGE() como función del sistema que devuelve una descripción del error que ha ocurrido.
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