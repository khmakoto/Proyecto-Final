//
//  ViewControllerAjustes.m
//  Proyecto Final
//
//  Created by alumno on 11/23/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import "ViewControllerAjustes.h"
#import "DBManager.h"

@interface ViewControllerAjustes ()

// Objeto manejador de bases de datos.
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ViewControllerAjustes

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Se carga la base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];
    
    // Se agrega funcionalidad para quitar teclado.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(quitaTeclado)];
    
    [self.view addGestureRecognizer:tap];
    
    UIAlertView *alerta = [[UIAlertView alloc] init];
    
    // Query para recuperar cuenta de la base de datos.
    NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT contrasenia FROM Usuario WHERE email = '%@'", self.sEmail];
    
    // Se ejecuta query y el resultado se guarda en un arreglo.
    NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
    
    // Si sí existe el correo.
    if (resultadosQuery.count > 0) {
        NSInteger indiceContrasenia = [self.dbManager.arrColumnNames indexOfObject:@"contrasenia"];
        
        NSString *sNombre = [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceContrasenia];
        
        self.tfContraAnterior.text = sNombre;
    }
    
    // Si no existe el correo.
    else {
        // Se prepara una alerta indicándolo y se manda.
        alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                            message: @"No se ha recuperado la contraseña"
                                           delegate: self
                                  cancelButtonTitle: @"OK"
                                  otherButtonTitles: nil];
        
        [alerta show];
    }

}

// Método que permite que se quite el teclado al tocar otra parte de la pantalla.
- (void) quitaTeclado
{
    [self.view endEditing: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)guardarContrasena:(UIButton *)sender {

    if([self.tfContraNueva.text isEqualToString:@""]) {
        // Se prepara una alerta indicándolo y se manda.
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                         message: @"Escribe algo en los campos de contraseña"
                                                        delegate: self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
        
        [alerta show];
    }
    else if([self.tfContraNueva.text isEqualToString:self.tfContraConfirmacion.text]) {
    
        NSString *sQuery = [[NSString alloc] initWithFormat:@"UPDATE Usuario SET contrasenia = '%@' WHERE email = '%@'", self.tfContraNueva.text, self.sEmail];
    
        // Se ejecuta query.
        [self.dbManager executeQuery:sQuery];
    
        // Si la query fue exitosa.
        if (self.dbManager.affectedRows != 0) {
            // Se prepara una alerta indicándolo y se manda.
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Éxito!"
                                                         message: @"Contraseña cambiada exitosamente"
                                                        delegate: self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
        
            [alerta show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        // Si hubo un problema con la query.
        else{
            // Se prepara una alerta indicándolo y se manda.
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                         message: @"Problema al crear contraseña nueva"
                                                        delegate: self
                                               cancelButtonTitle: @"OK"
                                                otherButtonTitles: nil];
        
            [alerta show];
        }
    }
    else{
        // Se prepara una alerta indicándolo y se manda.
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                         message: @"Las contraseñas no son iguales"
                                                        delegate: self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
        
        [alerta show];
    }
}
@end
