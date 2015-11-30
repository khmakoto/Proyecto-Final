//
//  ViewControllerDetallesDiagnostico.h
//  
//
//  Created by José Manuel González Castro on 11/21/15.
//
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface ViewControllerDetallesDiagnostico : UIViewController
// Variable que guarda el id del diagnostico
@property NSInteger iIdDiagnostico;

// Variables de los campos de texto y labels donde se despliega la informacion
@property (strong, nonatomic) IBOutlet UITextField *tfNombre;
@property (strong, nonatomic) IBOutlet UITextField *tfLugar;
@property (strong, nonatomic) IBOutlet UITextField *tfFecha;
@property (strong, nonatomic) IBOutlet UITextView *tvArea;
@property (strong, nonatomic) IBOutlet UITextView *tvPorcentaje;
@property (strong, nonatomic) IBOutlet UILabel *lbPorcentajeTotal;
@property (strong, nonatomic) IBOutlet UILabel *lbEstado;

@end
