//
//  ViewControllerEscalera.m
//  
//
//  Created by José Manuel González Castro on 11/21/15.
//
//

#import "ViewControllerEscalera.h"
#import "DBManager.h"

@interface ViewControllerEscalera ()

// Objeto manejador de bases de datos.
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ViewControllerEscalera

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Se carga la base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];
    
    // Se carga porcentaje de accesibilidad.
    self.lbPorcentajeAccesibilidad.text = [[NSString alloc] initWithFormat:@"Porcentaje de accesibilidad: %ld", self.iPorcentaje];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Método que calcula el porcentaje de accesibilidad de un área basado en
// cuantas opciones estan marcadas con la opción Sí.
- (IBAction)btGuardar:(UIButton *)sender {
    NSInteger iRespuestaSi = 0;
    
    for(int i=0; i<self.respuestasDiagnostico.count; i++) {
        if(((UISegmentedControl *)[self.respuestasDiagnostico objectAtIndex:i]).selectedSegmentIndex == 0) {
            iRespuestaSi++;
        }
    }
    
    self.iPorcentaje = (100*iRespuestaSi/self.respuestasDiagnostico.count);
    
    // Se prepara query para crear nuevo usuario.
    NSString *sQuery = [[NSString alloc] initWithFormat:@"UPDATE Elemento SET porcentajeAccesibilidad = '%ld' WHERE idElemento = '%ld'", self.iPorcentaje, self.iId];
    
    // Se ejecuta query.
    [self.dbManager executeQuery:sQuery];
    
    // Si la query no fue exitosa.
    if (self.dbManager.affectedRows == 0) {
        // Se prepara una alerta indicándolo y se manda.
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                         message: @"No se pudo actualizar el porcentaje"
                                                        delegate: self
                                               cancelButtonTitle: @"OK"
                                               otherButtonTitles: nil];
        
        [alerta show];
    }
    
    [self.delegado guardarPorcentaje:self.iPorcentaje ID:self.iId];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
