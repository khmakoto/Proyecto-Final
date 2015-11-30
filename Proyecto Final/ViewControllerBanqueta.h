//
//  ViewControllerBanqueta.h
//  Proyecto Final
//
//  Created by alumno on 11/17/15.
//  Copyright (c) 2015 Itesm. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocolo que guarda el porcentaje de accesibilidad de un elemento.
@protocol guardarPorcentaje <NSObject>

-(void) guardarPorcentaje: (NSInteger)iPorcentaje ID:(NSInteger)iId;

@end

@interface ViewControllerBanqueta : UIViewController

// Colección de segmented controls que guarda las respuestas.
@property (nonatomic, strong) IBOutletCollection(UISegmentedControl) NSArray *respuestasDiagnostico;
@property (strong, nonatomic) IBOutlet UILabel *lbPorcentajeAccesibilidad;

- (IBAction)btGuardar:(UIButton *)sender;

@property (nonatomic, strong) id <guardarPorcentaje>  delegado;

@property NSInteger iPorcentaje;
// Variable que guarda el id del Elemento
@property NSInteger iId;

@end
