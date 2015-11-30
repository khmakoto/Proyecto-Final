//
//  TableViewControllerDiagnosticos.h
//  
//
//  Created by José Manuel González Castro on 11/21/15.
//
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface TableViewControllerDiagnosticos : UITableViewController

// Variables que guardan el email del usuario y el id del diagnóstico
@property (nonatomic, strong) NSString *sEmail;
@property NSInteger iIdDiagnostico;

@end
