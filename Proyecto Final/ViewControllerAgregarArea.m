//
//  ViewControllerAgregarArea.m
//  
//
//  Created by José Manuel González Castro on 11/5/15.
//
//

#import "ViewControllerAgregarArea.h"
#import "DBManager.h"

@interface ViewControllerAgregarArea ()

// Se crea objecto para manejar la base de datos.
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ViewControllerAgregarArea

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

// Método que guarda un área en la base de datos.
- (IBAction)guardarArea:(UIButton *)sender {
    // Se crea la alerta para manejar los errores.
    UIAlertView *alerta;
    
    // Si el campo del nombre está vacío.
    if([self.tfNombre.text isEqualToString:@""]) {
        // Se prepara una alerta indicándolo y se manda.
        alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                            message: @"El nombre del área no puede estar vacío"
                                           delegate: self
                                  cancelButtonTitle: @"OK"
                                  otherButtonTitles: nil];
        
        [alerta show];
    }
    else{
        
        // Se obtiene siguiente ID de base de datos.
        NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT MAX(idArea) AS idArea FROM Area"];
        
        // Se obtiene lo que regresó la query.
        NSInteger iId;
        NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
        
        // Si hubo resultado.
        if (resultadosQuery.count > 0) {
            // Se obtuvo el mayor ID, por lo que se guarda aumentado en 1.
            NSInteger indiceId = [self.dbManager.arrColumnNames indexOfObject:@"idArea"];
            NSString *sId = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceId]];
            iId = [sId integerValue] + 1;
        }
        
        
        // Si no hubo resultado.
        else {
            // Es el primer registro, por lo que el ID es 1.
            iId = 1;
        }
        
        NSString *sNombre = self.tfNombre.text;
        
        // Se prepara query para crear nueva área.
        sQuery = [[NSString alloc] initWithFormat:@"INSERT INTO Area VALUES(%ld, '%@', %d)", iId, sNombre, 0];
        
        // Se ejecuta query.
        [self.dbManager executeQuery:sQuery];
        
        // Si la query fue exitosa.
        if (self.dbManager.affectedRows != 0) {
            
            // Se prepara query para ligar área con diagnóstico.
            sQuery = [[NSString alloc] initWithFormat:@"INSERT INTO DiagnosticoArea VALUES(%ld, %ld)", self.iIdDiagnostico, iId];
            
            // Se ejecuta query.
            [self.dbManager executeQuery:sQuery];
            
            // Si la query fue exitosa.
            if (self.dbManager.affectedRows != 0) {
                // Se prepara una alerta indicándolo y se manda.
                alerta = [[UIAlertView alloc] initWithTitle: @"Éxito!"
                                                    message: @"Área creada exitosamente"
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
                
                [alerta show];
                
                // Se actualiza la vista en el delegado.
                NSString *sId = [[NSString alloc] initWithFormat:@"%ld", iId];
                [self.delegado guardaArea:sNombre ID:sId];
                [self.delegado quitaVista];
            }
            // Si hubo un problema con la query.
            else{
                // Se prepara una alerta indicándolo y se manda.
                alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                    message: @"Problema al crear área"
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
                
                [alerta show];
            }
        }
        
        // Si hubo un problema con la query.
        else{
            // Se prepara una alerta indicándolo y se manda.
            alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                message: @"Problema al crear área"
                                               delegate: self
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
            
            [alerta show];
        }

    }
}
@end
