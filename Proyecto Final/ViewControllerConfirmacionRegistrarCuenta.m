//
//  ViewControllerConfirmacionRegistrarCuenta.m
//  Proyecto Final
//
//  Created by alumno on 10/20/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import "ViewControllerConfirmacionRegistrarCuenta.h"

@interface ViewControllerConfirmacionRegistrarCuenta ()

@end

@implementation ViewControllerConfirmacionRegistrarCuenta

// Método que establece condiciones iniciales al cargar la aplicación.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// Método que manda parámetros a otras vistas.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Se inicializa el nombre del usuario en siguiente vista.
    [[segue destinationViewController] setSUsuario:self.sUsuario];
    
    // Se inicializa el email del usuario en siguiente vista.
    [[segue destinationViewController] setSEmail:self.sEmail];
}

@end
