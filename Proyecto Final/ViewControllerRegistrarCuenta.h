//
//  ViewControllerRegistrarCuenta.h
//  Proyecto Final
//
//  Created by alumno on 10/20/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ViewControllerRegistrarCuenta : UIViewController

// Campos de texto de la forma de registro de nueva cuenta.
@property (weak, nonatomic) IBOutlet UITextField *tfNombre;
@property (weak, nonatomic) IBOutlet UITextField *tfApellido;
@property (weak, nonatomic) IBOutlet UITextField *tfProfesion;
@property (weak, nonatomic) IBOutlet UITextField *tfOrganizacion;
@property (weak, nonatomic) IBOutlet UITextField *tfCorreoElectronico;
@property (weak, nonatomic) IBOutlet UITextField *tfContrasenia;
@property (weak, nonatomic) IBOutlet UITextField *tfConfirmarContrasenia;

// Strings que guardan el nombre y el email del usuario a registrar.
@property (nonatomic, strong) NSString *sUsuario;
@property (nonatomic, strong) NSString *sEmail;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UITextField *activeField;

- (IBAction)registrar:(UIButton *)sender;

@end
