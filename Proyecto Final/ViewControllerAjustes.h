//
//  ViewControllerAjustes.h
//  Proyecto Final
//
//  Created by alumno on 11/23/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerAjustes : UIViewController

// Variable que guarda el email del usuario
@property (nonatomic, strong) NSString *sEmail;

@property (weak, nonatomic) IBOutlet UITextField *tfContraAnterior;
@property (weak, nonatomic) IBOutlet UITextField *tfContraNueva;
@property (weak, nonatomic) IBOutlet UITextField *tfContraConfirmacion;

- (IBAction)guardarContrasena:(UIButton *)sender;

@end
