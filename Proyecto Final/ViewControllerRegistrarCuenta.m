//
//  ViewControllerRegistrarCuenta.m
//  Proyecto Final
//
//  Created by alumno on 10/20/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import "ViewControllerRegistrarCuenta.h"

@interface ViewControllerRegistrarCuenta ()

@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ViewControllerRegistrarCuenta

// Método que establece condiciones iniciales al cargar la aplicación.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Se carga la base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];
    
    // Se agrega funcionalidad para quitar teclado.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(quitaTeclado)];
    
    [self.view addGestureRecognizer:tap];
    
    // Se agrega funcionalidad para mover pantalla cuando se requiera por input.
    [self registerForKeyboardNotifications];
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

// Método para registrar notificaciones del teclado.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Método que al mostrar el teclado mueva la pantalla.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect bkgndRect = self.activeField.superview.frame;
    bkgndRect.size.height += kbSize.height;
    [self.activeField.superview setFrame:bkgndRect];
    [self.scrollView setContentOffset:CGPointMake(0.0, self.activeField.frame.origin.y+(kbSize.height / 2)) animated:YES];
}

// Método que al esconder el teclado regrese la pantalla a su posición original.
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect bkgndRect = self.activeField.superview.frame;
    bkgndRect.size.height -= kbSize.height;
    [self.activeField.superview setFrame:bkgndRect];
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}


#pragma mark - Navigation

// Método que manda parámetros a otras vistas.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Se inicializa el nombre del usuario en siguiente vista.
    [[segue destinationViewController] setSUsuario:self.sUsuario];
    
    // Se inicializa el email del usuario en siguiente vista.
    [[segue destinationViewController] setSEmail:self.sEmail];
}

// Método para registrar una nueva cuenta de usuario en la app.
- (IBAction)registrar:(UIButton *)sender {
    UIAlertView *alerta;
    
    // Si algún campo se dejó vacío.
    if([self.tfNombre.text isEqualToString:@""] || [self.tfApellido.text isEqualToString:@""] || [self.tfProfesion.text isEqualToString:@""] || [self.tfOrganizacion.text isEqualToString:@""] || [self.tfCorreoElectronico.text isEqualToString:@""] || [self.tfContrasenia.text isEqualToString:@""] || [self.tfConfirmarContrasenia.text isEqualToString:@""]) {
        // Se prepara una alerta indicándolo y se manda.
        alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                            message: @"Tienes que llenar todos los campos"
                                           delegate: self
                                  cancelButtonTitle: @"OK"
                                  otherButtonTitles: nil];
        
        [alerta show];
    }
    
    // Si se escribieron todos los campos.
    else {
        // Se recuperan los datos de ellos y se guardan en variables.
        NSString *sNombre = self.tfNombre.text;
        NSString *sApellido = self.tfApellido.text;
        NSString *sProfesion = self.tfProfesion.text;
        NSString *sOrganizacion = self.tfOrganizacion.text;
        self.sEmail = self.tfCorreoElectronico.text;
        NSString *sContrasenia = self.tfContrasenia.text;
        NSString *sConfirmacion = self.tfConfirmarContrasenia.text;
        
        // Si la contraseña es igual a la contraseña de confirmación.
        if ([sContrasenia isEqualToString:sConfirmacion]) {
            // Se obtiene siguiente ID de base de datos.
            NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT MAX(idUsuario) AS idUsuario FROM Usuario"];

            // Se obtiene lo que regresó la query.
            NSInteger iId;
            NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
            
            // Si hubo resultado.
            if (resultadosQuery.count > 0) {
                // Se obtuvo el mayor ID, por lo que se guarda aumentado en 1.
                NSInteger indiceId = [self.dbManager.arrColumnNames indexOfObject:@"idUsuario"];
                NSLog(@"%ld", indiceId);
                NSString *sId = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceId]];
                iId = [sId integerValue] + 1;
            }
            
            // Si no hubo resultado.
            else {
                // Es el primer registro, por lo que el ID es 1.
                iId = 1;
            }
            
            // Se prepara query para crear nuevo usuario.
            sQuery = [[NSString alloc] initWithFormat:@"INSERT INTO Usuario VALUES(%ld, '%@', '%@', '%@', '%@', '%@', '%@')", iId, sNombre, sApellido, self.sEmail, sContrasenia, sProfesion, sOrganizacion];
            
            // Se ejecuta query.
            [self.dbManager executeQuery:sQuery];
            
            // Si la query fue exitosa.
            if (self.dbManager.affectedRows != 0) {
                // Se establece nombre de usuario.
                self.sUsuario = [[NSString alloc] initWithFormat:@"%@ %@", sNombre, sApellido];
                
                // Se va a la siguiente pantalla con segue "registraCuenta".
                [self performSegueWithIdentifier:@"registraCuenta" sender:sender];
            }
            
            // Si hubo un problema con la query.
            else{
                // Se prepara una alerta indicándolo y se manda.
                alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                    message: @"Problema al crear usuario"
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
                
                [alerta show];
            }
        }
        
        // Si la contraseña no es igual a la contraseña de confirmación.
        else {
            // Se prepara una alerta indicándolo y se manda.
            alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                message: @"Contraseña y confirmación deben ser iguales"
                                               delegate: self
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
            
            [alerta show];
        }
    }
}
@end
