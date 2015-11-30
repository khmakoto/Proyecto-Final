//
//  DBManager.m
//  Bases de datos
//
//  Created by alumno on 20/10/15.
//  Copyright (c) 2015 itesm. All rights reserved.
//

#import "DBManager.h"
#import "sqlite3.h"

@implementation DBManager

// Método constructor de la base de datos que inicializa la base de datos con el nombre mandado.
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    
    // Sí el objeto propio no es nulo.
    if (self) {
        // Establecer el path del directorio de documentos para la propiedad documentsDirectory.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Se guarda el nombre de la base de datos.
        self.databaseFilename = dbFilename;
        
        // Se copia el archivo de la base de datos en el directorio de documentos si es necesario.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    
    return self;
}

// Método que copia el archivo de la base de datos en el directorio de documentos si es necesario.
-(void)copyDatabaseIntoDocumentsDirectory{
    // Se revisa si el archivo de la base de datos existe en el directorio de documentos.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        
        // El archivo de la base de datos no existe en el directorio de documentos, así que se copia del main bundle.
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"diagnosticos" ofType:@"sqlite"];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // Se revisa si ocurrió un error durante el copiado y se despliega.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

// Método que corre una query que se manda como parámetro, definiendo si modifica o no a la base de datos por medio del parámetro queryExecutable.
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
    // Se crea un objeto de tipo sqlite.
    sqlite3 *sqlite3Database;
    
    // Se establece el path al archivo de la base de datos.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Se inicializa el arreglo de los resultados.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Inicializa el arreglo con los nombres de las columnas.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    // Se abre la base de datos.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    
    // Si no hubo errores al abrir la base de datos.
    if(openDatabaseResult == SQLITE_OK) {
        // Se declara un objeto de tipo sqlite3_stmt en el que se guardarán los querys después de haber sido compilados en un estatuto de SQLite.
        sqlite3_stmt *compiledStatement;
        
        // Se cargan todos los datos pedidos de la base de datos a memoria.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        
        // Sí no hubo errores al ejecutar la query.
        if(prepareStatementResult == SQLITE_OK) {
            // Se revisa si la query es no-ejecutable.
            if (!queryExecutable){
                // En este caso, los datos deben ser cargados desde la base de datos.
                
                // Se declara un arreglo para mantener los datos de cada renglón recuperado.
                NSMutableArray *arrDataRow;
                
                // Se itera en los resultados y se añaden al arreglo de resultados renglón por renglón.
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Inicialización del arreglo mutable que contendrá los datos de cada renglón recuperado.
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    // Se obtiene el total de columnas.
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Se itera sobre todas las columnas para obtener sus datos.
                    for (int i=0; i<totalColumns; i++){
                        // Se convierten los datos de cada columna en texto (caracteres).
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // Si hay contenidos en la presente columna entonces se añaden al presente arreglo de renglones.
                        if (dbDataAsChars != NULL) {
                            // Se convierten los caracteres a string.
                            [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        // Se mantiene el nombre de la columna actual.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    // Se almacena cada renglón de datos en el arreglo de resultados, pero primero se revisa si sí hay datos.
                    if (arrDataRow.count > 0) {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            
            // Si el query es ejecutable.
            else {
                // Este es el caso de un query ejecutable (insert, update, ...).
                
                // Si al compilar el estatuto no hubo errores.
                if (sqlite3_step(compiledStatement)) {
                    // Se mantienen los renglones afectados.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Se mantiene el último ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                
                // Si hubo errores al compilar.
                else {
                    // Se muestra el mensaje de error en el debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        
        // Si hubo errores al ejecutar la query.
        else {
            // La base de datos no se pudo abrir y se muestrar el mensaje de error en el debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Se liberan los estatutos compilados de memoria.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Se cierra la base de datos.
    sqlite3_close(sqlite3Database);
}

// Método para cargar datos de la base de datos.
-(NSArray *)loadDataFromDB:(NSString *)query{
    // Se corre el query y se indica que no es ejecutable.
    // El string del query es convertido a un objeto de tipo char*.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Se regresan los resultados cargados en un arreglo.
    return (NSArray *)self.arrResults;
}

// Método que ejecuta un query.
-(void)executeQuery:(NSString *)query{
    // Se corre el query y se indica que es ejecutable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

// Método que sirve para obtener los nombres de las tablas existentes en la base de datos.
// Utilizado principalmente para debuggear en caso de que existan errores desconocidos.
-(NSMutableArray *)fetchTableNames
{
    // Crea un objeto de tipo sqlite.
    sqlite3 *sqlite3Database;
    
    // Se establece el path al archivo de la base de datos.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Inicializa el arreglo de resultados.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Se inicializa el arreglo de los nombres de las columnas.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    // Se abre la base de datos.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    
    // Se prepara un estatuto de tipo sqlite.
    sqlite3_stmt* statement;
    
    // Se escribe query para obtener nombres de tablas.
    NSString *query = @"SELECT name FROM sqlite_master WHERE type=\'table\'";
    
    // Se recuperan los datos de la base de datos.
    int retVal = sqlite3_prepare_v2(sqlite3Database,
                                    [query UTF8String],
                                    -1,
                                    &statement,
                                    NULL);
    
    // Se crea arreglo para guardar los registros.
    NSMutableArray *selectedRecords = [NSMutableArray array];
    
    // Si no hubo error al ejecutar query.
    if (retVal == SQLITE_OK )
    {
        // Se itera sobre los nombres de las tablas y se guardan en el arreglo que se regresará.
        while(sqlite3_step(statement) == SQLITE_ROW )
        {
            NSString *value = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0)
                                                 encoding:NSUTF8StringEncoding];
            [selectedRecords addObject:value];
        }
    }
    
    // Se liberan recursos utilizados para realizar query.
    sqlite3_clear_bindings(statement);
    sqlite3_finalize(statement);
    
    // Se regresa arreglo de resultados.
    return selectedRecords;
}

@end
