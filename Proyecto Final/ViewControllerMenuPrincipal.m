//
//  ViewControllerMenuPrincipal.m
//  Proyecto Final
//
//  Created by alumno on 10/20/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import "ViewControllerMenuPrincipal.h"
#import "TableViewControllerDiagnosticos.h"
#import "ViewControllerAjustes.h"

@interface ViewControllerMenuPrincipal ()

@end

@implementation ViewControllerMenuPrincipal

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

// Método que inicializa las condiciones iniciales de las siguientes vistas.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Si la vista siguiente es inicioDiagnostico.
    if ([segue.identifier isEqualToString:@"inicioDiagnostico"]) {
        // Se inicializa el nombre del usuario en inicioDiagnostico.
        [[segue destinationViewController] setSUsuario:self.sUsuario];
        
        // Se inicializa el email del usuario en inicioDiagnostico.
        [[segue destinationViewController] setSEmail: self.sEmail];
    }
    else if ([segue.identifier isEqualToString:@"Diagnosticos"]) {
        UINavigationController *navController = [segue destinationViewController];
        [(TableViewControllerDiagnosticos *)[navController topViewController] setSEmail:self.sEmail];
    }
    else if ([segue.identifier isEqualToString:@"Ajustes"]) {
        [[segue destinationViewController] setSEmail:self.sEmail];
    }
}

// Método que sirven para regresar a la pantalla del Menu Principal
- (IBAction)unwindIniciaNuevoDiagnostico:(UIStoryboardSegue *)segue {
}

-(IBAction)unwindMenuDiagnosticos:(UIStoryboardSegue *)segue {
}

-(IBAction)unwindAjustes:(UIStoryboardSegue *)segue {
}

-(IBAction)unwindAcercaDe:(UIStoryboardSegue *)segue {
}

-(IBAction)unwindInstrucciones:(UIStoryboardSegue *)segue {
}

@end
