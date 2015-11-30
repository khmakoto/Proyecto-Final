//
//  ViewControllerIniciarSesion.h
//  Proyecto Final
//
//  Created by alumno on 10/20/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewControllerIniciarSesion : UIViewController<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfCuenta; // Campo de texto de cuenta.
@property (weak, nonatomic) IBOutlet UITextField *tfContrasenia; // Campo de texto de contraseña.
@property (nonatomic, strong) NSString *sUsuario; // String que guarda nombre de usuario actual.
@property (nonatomic, strong) NSString *sEmail; // String que guarda email de usuario actual.

- (IBAction)iniciar:(UIButton *)sender;
- (IBAction)olvideMiContrasenia:(UIButton *)sender;

@end
