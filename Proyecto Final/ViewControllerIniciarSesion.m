//
//  ViewControllerIniciarSesion.m
//  Proyecto Final
//
//  Created by alumno on 10/20/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import "ViewControllerIniciarSesion.h"
#import "DBManager.h"

@interface ViewControllerIniciarSesion ()

// Objeto manejador de bases de datos.
@property (nonatomic, strong) DBManager *dbManager;

// Contraseña nueva al mandar correo de recuperación de contraseña.
@property (nonatomic, strong) NSString *sContraseniaNueva;

@end

@implementation ViewControllerIniciarSesion

// Método que establece condiciones iniciales al cargar la aplicación.
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"inicioSesion"]) {
        // Se inicializa nombre de usuario en vista a llegar.
        [[segue destinationViewController] setSUsuario:self.sUsuario];
        
        // Se inicializa email de usuario en vista a llegar.
        [[segue destinationViewController] setSEmail:self.sEmail];
    }
}

// Método que se llama al momento de iniciar sesión en la aplicación.
- (IBAction)iniciar:(UIButton *)sender {
    UIAlertView *alerta;
    
    // Si no se llenó algún campo.
    if([self.tfContrasenia.text isEqualToString:@""] || [self.tfCuenta.text isEqualToString:@""]) {
        // Se prepara una alerta por si no se llenó algún campo.
        alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                            message: @"Tienes que llenar todos los campos"
                                           delegate: self
                                  cancelButtonTitle: @"OK"
                                  otherButtonTitles: nil];
        
        // Se manda la alerta.
        [alerta show];
    }
    
    // Si todos los campos se llenaron.
    else {
        // Se obtienen los valores de los campos de texto.
        self.sEmail = self.tfCuenta.text;
        NSString *sContrasenia = self.tfContrasenia.text;
        
        // Query para recuperar cuenta de la base de datos.
        NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT nombre, apellido, contrasenia FROM Usuario WHERE email = '%@'", self.sEmail];
        
        // Se ejecuta query y el resultado se guarda en un arreglo.
        NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
        
        // Si sí existe el correo.
        if (resultadosQuery.count > 0) {
            NSInteger indiceContrasenia = [self.dbManager.arrColumnNames indexOfObject:@"contrasenia"];
            NSInteger indiceNombre = [self.dbManager.arrColumnNames indexOfObject:@"nombre"];
            NSInteger indiceApellido = [self.dbManager.arrColumnNames indexOfObject:@"apellido"];
            
            // Si la contraseña es correcta.
            if ([(NSString *)[[resultadosQuery objectAtIndex:0] objectAtIndex:indiceContrasenia] isEqualToString:sContrasenia]) {
                // Se cargan nombre y apellido de usuario.
                NSString *sNombre = [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceNombre];
                NSString *sApellido = [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceApellido];
                self.sUsuario = [[NSString alloc]initWithFormat:@"%@ %@", sNombre, sApellido];
                
                // Se realiza el segue para ir al menú principal.
                [self performSegueWithIdentifier:@"inicioSesion" sender:sender];
            }
            
            // Si la contraseña no es correta.
            else {
                // Se prepara una alerta indicándolo y se manda.
                alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                    message: @"Contraseña incorrecta"
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
                
                [alerta show];
            }
        }
        
        // Si no existe el correo.
        else {
            // Se prepara una alerta indicándolo y se manda.
            alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                message: @"Usuario no existe"
                                               delegate: self
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
            
            [alerta show];
        }
    }
}

// Método que manda un correo con nueva contraseña cuando se olvidó contraseña.
- (IBAction)olvideMiContrasenia:(UIButton *)sender {
    UIAlertView *alerta;
    
    // Si no se llenó el campo de cuenta.
    if([self.tfCuenta.text isEqualToString:@""]) {
        // Se prepara una alerta por si no se llenó algún campo.
        alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                            message: @"Tienes que llenar el campo de cuenta"
                                           delegate: self
                                  cancelButtonTitle: @"OK"
                                  otherButtonTitles: nil];
        
        // Se manda la alerta.
        [alerta show];
    }
    
    // Si se proporciona el campo de cuenta.
    else {
        // Se obtiene el valor del campo de texto.
        NSString *sEmail = self.tfCuenta.text;
        
        // Query para recuperar cuenta de la base de datos.
        NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT email FROM Usuario WHERE email = '%@'", sEmail];
        
        // Se ejecuta query y el resultado se guarda en un arreglo.
        NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
        
        // Si sí existe el correo.
        if (resultadosQuery.count > 0) {
            // Construir el objeto mail compose view controller con las propiedades iniciales.
            MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
            mailComposer.mailComposeDelegate = self;
            NSArray *sRecipient = [NSArray arrayWithObject:sEmail];
            self.sContraseniaNueva = [self generaContrasenia];
            NSString *sMensaje = [[NSString alloc] initWithFormat:@"Tu nueva contraseña es la siguiente: '%@'", self.sContraseniaNueva];
            [mailComposer setSubject:@"Nueva Contraseña"];
            [mailComposer setToRecipients:sRecipient];
            [mailComposer setMessageBody:sMensaje isHTML:YES];
            
            // Se muestra el mail composer.
            [self presentViewController:mailComposer animated:YES completion:nil];
        }
        
        // Si no existe el correo.
        else {
            // Se prepara una alerta indicándolo y se manda.
            alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                message: @"Usuario no existe"
                                               delegate: self
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
            
            [alerta show];
        }

    }
}

// Método que quita el mail compose view controller cuando se termina de utilizar.
-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // Se revisa si se mandó el mail.
    if (result == MFMailComposeResultSent) {
        // Se obtiene email del campo de texto correspondiente.
        NSString *sEmail = self.tfCuenta.text;
        
        // Se prepara query para crear nuevo usuario.
        NSString *sQuery = [[NSString alloc] initWithFormat:@"UPDATE Usuario SET contrasenia = '%@' WHERE email = '%@'", self.sContraseniaNueva, sEmail];
        
        // Se ejecuta query.
        [self.dbManager executeQuery:sQuery];
        
        // Si la query fue exitosa.
        if (self.dbManager.affectedRows != 0) {
            // Se prepara una alerta indicándolo y se manda.
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Éxito!"
                                                             message: @"Mensaje enviado correctamente"
                                                            delegate: self
                                                   cancelButtonTitle: @"OK"
                                                   otherButtonTitles: nil];
            
            [alerta show];
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
    
    // Se quita la vista.
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Método que establece lo que sucede cuando se regresa a la vista desde el menú principal.
- (IBAction)unwindMenuPrincipal:(UIStoryboardSegue *)segue {
    self.tfCuenta.text = @"";
    self.tfContrasenia.text = @"";
}

// Método que establece lo que sucede cuando se regresa a la vista desde la vista de registro de nuevas cuentas.
- (IBAction)unwindRegistrarCuenta:(UIStoryboardSegue *)segue {
    self.tfCuenta.text = @"";
    self.tfContrasenia.text = @"";
}

// Método que genera una nueva contraseña aleatoriamente.
- (NSString *)generaContrasenia {
    // Tamaño de la nueva contraseña.
    NSInteger iContador = 10;
    
    // Entero que indica siguiente caracter a añadir a la nueva contraseña.
    NSInteger iSiguienteCaracter;
    
    // String de la nueva contraseña que se inicializa en vacío.
    NSString *sNuevaContrasenia = [[NSString alloc]initWithFormat:@""];
    
    // Los primeros cinco caracteres son letras.
    while(iContador > 5) {
        // Se obtiene el índice ASCII de alguna letra del abecedario en minúscula al azar.
        iSiguienteCaracter = arc4random() % 26 + 97;
        
        // Se adjunta letra a string de nueva contraseña.
        sNuevaContrasenia = [[NSString alloc]initWithFormat:@"%@%c", sNuevaContrasenia, (char)iSiguienteCaracter];
        
        // Se decrementa contador.
        iContador--;
    }
    
    // El resto de la nueva contraseña son números.
    while(iContador) {
        // Se obtiene un número al azar entre 0 y 9.
        iSiguienteCaracter = arc4random() % 10;
        
        // Se añade número a string de nueva contraseña.
        sNuevaContrasenia = [[NSString alloc]initWithFormat:@"%@%ld", sNuevaContrasenia, iSiguienteCaracter];
        
        // Se decrementa contador.
        iContador--;
    }
    
    // Se regresa nueva contraseña.
    return sNuevaContrasenia;
}

@end
