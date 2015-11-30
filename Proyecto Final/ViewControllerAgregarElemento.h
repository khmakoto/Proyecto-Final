//
//  ViewControllerAgregarElemento.h
//  
//
//  Created by José Manuel González Castro on 11/5/15.
//
//

#import <UIKit/UIKit.h>

@protocol protocoloGuardaElemento <NSObject>

- (void) quitaVista;
- (void) guardaElemento:(NSString *)nuevoElemento Tipo:(NSString *)sTipo ID:(NSInteger)iId;

@end

// Se establece el área de variables para el UIPickerView
@interface ViewControllerAgregarElemento : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {

    __weak IBOutlet UIPickerView *pickerViewElementos;
    __weak IBOutlet UITextField *tfNombre;

}

@property NSInteger iDArea;
@property (nonatomic, strong) id <protocoloGuardaElemento> delegado;
@property (nonatomic, strong) NSString *sTipo;

- (IBAction)guardarElemento:(UIButton *)sender;

@end
