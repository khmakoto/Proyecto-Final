//
//  ViewControllerIniciarNuevoDiagnostico.m
//  Proyecto Final
//
//  Created by alumno on 10/27/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import "ViewControllerIniciarNuevoDiagnostico.h"
#import "DBManager.h"
#import "TableViewControllerMenuDiagnosticos.h"

@interface ViewControllerIniciarNuevoDiagnostico ()

// Objeto manejador de bases de datos.
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ViewControllerIniciarNuevoDiagnostico

// Método que establece condiciones iniciales al cargar la aplicación.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Se obtiene la fecha de hoy.
    _miFecha = [NSDate date];
    
    // Se formatea la fecha a al formato [dd, MMM, YYYY].
    NSDateFormatter	*dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"dd, MMM, YYYY"];
    
    // Se pone la fecha formateada en string y se agrega al campo de texto correspondiente.
    NSString *stringFormateado = [dateFormatter stringFromDate: _miFecha];
    self.tfFecha.text = stringFormateado;
    
    // Se pone nombre de usuario en campo de texto correspondiente.
    self.tfUsuario.text = self.sUsuario;
    
    // Se carga base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];
    
    // Se agrega funcionalidad para quitar teclado.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(quitaTeclado)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Método que permite que se quite el teclado al tocar otra parte de la pantalla.
- (void) quitaTeclado
{
    [self.view endEditing: YES];
}


#pragma mark - Navigation

// Método que manda parámetros a otras vistas.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"menuDiagnosticos"]) {
        UINavigationController *navController = [segue destinationViewController];
        [(TableViewControllerMenuDiagnosticos *)[navController topViewController] setIIdDiagnostico:self.iIdDiagnostico];
    }
}

// Método que sirve para regresar a la pantalla desde la vista menuArea.
- (IBAction)unwindMenuArea:(UIStoryboardSegue *)segue {
    // Variable que guarda el porcentaje de accesibilidad del área
    NSInteger iPorcentajeAccesibilidad = 0;
    
    // Se crea la alerta de error.
    UIAlertView *alerta;
    
    // Se crea la query para seleccionar las áreas.
    NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT idArea FROM DiagnosticoArea WHERE idDiagnostico = %ld", self.iIdDiagnostico];
    
    // Se obtiene lo que regresó la query.
    NSInteger iIdArea;
    NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
    
    // Si hubo resultado.
    if (resultadosQuery.count > 0) {
        // Se guarda índice de id de área.
        NSInteger indiceArea = [self.dbManager.arrColumnNames indexOfObject:@"idArea"];
        NSInteger tamArreglo = resultadosQuery.count - 1;
        NSString *sIdArea;
        
        // Se itera sobre resultados de query.
        while(tamArreglo >= 0) {
            // Se guarda el iD de área.
            sIdArea = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:tamArreglo] objectAtIndex:indiceArea]];
            iIdArea = [sIdArea integerValue];
            
            // Se prepara query para obtener nombre de área.
            sQuery = [[NSString alloc] initWithFormat:@"SELECT porcentajeAccesibilidad FROM Area WHERE idArea = %ld", iIdArea];
            
            // Se almacenan los resultados.
            NSMutableArray *resultadosQuery2 = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
            
            // Si hubo resultados.
            if(resultadosQuery2.count > 0) {
                // Se guarda nombre de área.
                NSInteger indicePorcentaje = [self.dbManager.arrColumnNames indexOfObject:@"porcentajeAccesibilidad"];
                NSString *sPorcentaje = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indicePorcentaje]];
                iPorcentajeAccesibilidad += [sPorcentaje integerValue];
            }
            
            // Se decrementa tamaño de arreglo.
            tamArreglo--;
        }
        
        // Se calcula el porcentaje de accesibilidad del área
        iPorcentajeAccesibilidad = iPorcentajeAccesibilidad / resultadosQuery.count;
        
        // Se prepara query para crear nuevo usuario.
        sQuery = [[NSString alloc] initWithFormat:@"UPDATE Diagnostico SET porcentajeAccesibilidad = '%ld' WHERE idDiagnostico = '%ld'", iPorcentajeAccesibilidad, self.iIdDiagnostico];
        
        // Se ejecuta query.
        [self.dbManager executeQuery:sQuery];
        
        // Si la query no fue exitosa.
        if (self.dbManager.affectedRows == 0) {
            // Se prepara una alerta indicándolo y se manda.
            alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                             message: @"No se pudo actualizar el porcentaje"
                                                            delegate: self
                                                   cancelButtonTitle: @"OK"
                                                   otherButtonTitles: nil];
            
            [alerta show];
        }
        else {
            // Se prepara una alerta indicándolo y se manda.
            alerta = [[UIAlertView alloc] initWithTitle: @"Éxito!"
                                                message: @"Se ha completado el diagnóstico. Puede verlo seleccionando 'Mis diagnósticos' en el menú principal."
                                               delegate: self
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
            
            [alerta show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

// Inicia nuevo diagnóstico.
- (IBAction)iniciar:(UIButton *)sender {
    // Si falta el campo de nombre o el de lugar del diagnóstico.
    if([self.tfNombre.text isEqualToString:@""] || [self.tfLugar.text isEqualToString:@""]) {
        // Se prepara mensaje de error en alerta.
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                         message: @"Tienes que llenar todos los campos"
                                                        delegate: self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
        
        // Se manda alerta.
        [alerta show];
    }
    
    // Si sí está el campo de nombre y el de lugar del diagnóstico.
    else {
        NSString *sNombreDiagnostico = self.tfNombre.text;
        NSString *sFecha = self.tfFecha.text;
        NSString *sLugar = self.tfLugar.text;
        
        // Se obtiene siguiente ID de base de datos.
        NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT MAX(idDiagnostico) AS idDiagnostico FROM Diagnostico"];
        
        // Se obtiene lo que regresó la query.
        NSInteger iId;
        NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
        
        // Si hubo resultado.
        if (resultadosQuery.count > 0) {
            // Se obtuvo el mayor ID, por lo que se guarda aumentado en 1.
            NSInteger indiceId = [self.dbManager.arrColumnNames indexOfObject:@"idDiagnostico"];
            NSString *sId = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceId]];
            iId = [sId integerValue] + 1;
        }
        
        // Si no hubo resultado.
        else {
            // Es el primer registro, por lo que el ID es 1.
            iId = 1;
        }

        self.iIdDiagnostico = iId;
        
        // Se obtiene ID de usuario de base de datos.
        sQuery = [[NSString alloc] initWithFormat:@"SELECT idUsuario FROM Usuario WHERE email = '%@'", self.sEmail];
        
        // Se obtiene lo que regresó la query.
        NSInteger iIdUsuario;
        resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
        
        // Si hubo resultado.
        if (resultadosQuery.count > 0) {
            // Se guarda id de usuario.
            NSInteger indiceIdUsuario = [self.dbManager.arrColumnNames indexOfObject:@"idUsuario"];
            NSString *sIdUsuario = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceIdUsuario]];
            iIdUsuario = [sIdUsuario integerValue];
            
            // Se prepara query para crear nuevo diagnóstico.
            sQuery = [[NSString alloc] initWithFormat:@"INSERT INTO Diagnostico VALUES(%ld, '%@', '%@', '%@', 0, 0, 0, %ld)", iId, sNombreDiagnostico, sFecha, sLugar, iIdUsuario];
            
            // Se ejecuta query.
            [self.dbManager executeQuery:sQuery];
            
            // Si la query fue exitosa.
            if (self.dbManager.affectedRows != 0) {
                // Se va a la siguiente pantalla con segue "menuDiagnosticos".
                [self performSegueWithIdentifier:@"menuDiagnosticos" sender:sender];
            }
            
            // Si hubo un problema con la query.
            else{
                // Se prepara una alerta indicándolo y se manda.
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                                 message: @"Problema al crear diagnóstico"
                                                                delegate: self
                                                       cancelButtonTitle: @"OK"
                                                       otherButtonTitles: nil];
                
                [alerta show];
            }
        }
        
        // Si no hubo resultado.
        else {
            // Se prepara una alerta indicándolo y se manda.
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                             message: @"Problema al cargar usuario"
                                                            delegate: self
                                                   cancelButtonTitle: @"OK"
                                                   otherButtonTitles: nil];
            
            [alerta show];
        }

    }
}

@end
