//
//  DBManager.h
//  Bases de datos
//
//  Created by alumno on 20/10/15.
//  Copyright (c) 2015 itesm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;
-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
-(NSMutableArray *)fetchTableNames;

@property (nonatomic, strong) NSString *documentsDirectory; // String que guarda el path al directorio de documentos.
@property (nonatomic, strong) NSString *databaseFilename; // Nombre del archivo de la base de datos.
@property (nonatomic, strong) NSMutableArray *arrResults; // Arreglo de resultados.
@property (nonatomic, strong) NSMutableArray *arrColumnNames; // Arreglo que guardan los nombres de las columnas.
@property (nonatomic) int affectedRows; // Número de filas afectadas al realizar query ejecutable.
@property (nonatomic) long long lastInsertedRowID; // ID del renglón insertado.

@end
