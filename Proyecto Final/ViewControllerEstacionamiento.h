//
//  ViewControllerEstacionamiento.h
//  
//
//  Created by José Manuel González Castro on 11/21/15.
//
//

#import <UIKit/UIKit.h>

// Protocolo que guarda el porcentaje de accesibilidad de un elemento.
@protocol guardarPorcentaje <NSObject>

-(void) guardarPorcentaje: (NSInteger)iPorcentaje ID:(NSInteger)iId;

@end

@interface ViewControllerEstacionamiento : UIViewController

// Colección de segmented controls que guarda las respuestas.
@property (nonatomic, strong) IBOutletCollection(UISegmentedControl) NSArray *respuestasDiagnostico;
@property (strong, nonatomic) IBOutlet UILabel *lbPorcentajeAccesibilidad;

- (IBAction)btGuardar:(UIButton *)sender;

@property (nonatomic, strong) id <guardarPorcentaje>  delegado;

@property NSInteger iPorcentaje;
// Variable que guarda el id del Elemento
@property NSInteger iId;

@end
