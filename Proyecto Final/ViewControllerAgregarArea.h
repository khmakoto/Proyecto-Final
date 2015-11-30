//
//  ViewControllerAgregarArea.h
//  
//
//  Created by José Manuel González Castro on 11/5/15.
//
//

#import <UIKit/UIKit.h>

@protocol protocoloGuardaArea <NSObject>

- (void) quitaVista;
- (void) guardaArea:(NSString *)nuevaArea ID:(NSString *)sNuevoID;

@end

@interface ViewControllerAgregarArea : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *tfNombre; // Campo de texto donde se introduce el nombre del área. 
@property NSInteger iIdDiagnostico; // Entero que guarda el iD del diagnóstico actual.
@property (nonatomic, strong) id <protocoloGuardaArea> delegado;

- (IBAction)guardarArea:(UIButton *)sender;

@end
