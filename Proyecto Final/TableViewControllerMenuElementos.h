//
//  TableViewControllerMenuElementos.h
//  
//
//  Created by José Manuel González Castro on 11/5/15.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerAgregarElemento.h"
#import "ViewControllerBanqueta.h"
#import "ViewControllerEstacionamiento.h"
#import "ViewControllerElevador.h"
#import "ViewControllerEscalera.h"
#import "ViewControllerRampa.h"
#import "ViewControllerRampaBanqueta.h"
#import "ViewControllerPasillo.h"
#import "ViewControllerPlataforma.h"
#import "ViewControllerPuerta.h"
#import "ViewControllerPisosAcabados.h"

@interface TableViewControllerMenuElementos : UITableViewController
<protocoloGuardaElemento, guardarPorcentaje>

@property NSInteger idArea; // Entero que guarda el valor de la área actual.
@property NSInteger idElemento; // Entero que guarda el valor del elemento. 
@property NSInteger iPorcentaje; // Entero que guarda el porcentaje de accesibilidad del elemento.

@end
