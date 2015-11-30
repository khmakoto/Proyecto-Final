//
//  ViewControllerIniciarNuevoDiagnostico.h
//  Proyecto Final
//
//  Created by alumno on 10/27/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerIniciarNuevoDiagnostico : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *tfNombre; // Campo de texto de nombre de diagnóstico.
@property (weak, nonatomic) IBOutlet UITextField *tfFecha; // Campo de texto de fecha.
@property (weak, nonatomic) IBOutlet UITextField *tfUsuario; // Campo de texto de usuario.
@property (strong, nonatomic) IBOutlet UITextField *tfLugar; // Campo de texto de lugar.
@property NSDate *miFecha; // Fecha del día de hoy.
@property (nonatomic, strong) NSString *sUsuario; // String que guarda el nombre del usuario actual.
@property (nonatomic, strong) NSString *sEmail; // String que guarda el email del usuario actual.
@property NSInteger iIdDiagnostico; // Entero que guarda el iD del diagnóstico actual

- (IBAction)iniciar:(UIButton *)sender;

@end
