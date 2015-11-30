//
//  TableViewControllerMenuDiagnosticos.h
//  
//
//  Created by José Manuel González Castro on 11/5/15.
//
//

#import <UIKit/UIKit.h>
#import "ViewControllerAgregarArea.h"

@interface TableViewControllerMenuDiagnosticos : UITableViewController
<protocoloGuardaArea>

@property NSInteger iIdDiagnostico; // Entero que guarda el iD del diagnóstico actual.
@property NSInteger idArea; // Entero que guarda el iD del área actual.

@end
