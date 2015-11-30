//
//  ViewControllerAgregarElemento.m
//  
//
//  Created by José Manuel González Castro on 11/5/15.
//
//

#import "ViewControllerAgregarElemento.h"
#import "DBManager.h"

@interface ViewControllerAgregarElemento ()

@property (nonatomic, strong) DBManager *dbManager;

@end

NSArray *arrElementos;

@implementation ViewControllerAgregarElemento

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Se carga base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];
    
    // Se inicializa Picker View.
    pickerViewElementos.delegate = self;
    pickerViewElementos.dataSource = self;
    self.sTipo = @"Banqueta";
    
    arrElementos = @[@"Banqueta", @"Estacionamiento", @"Rampa Banqueta", @"Pasillo", @"Rampa", @"Escalera", @"Elevador", @"Plataforma", @"Pisos y Acabados", @"Puerta"];
    
    // Se agrega funcionalidad para quitar teclado.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(quitaTeclado)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Método que permite que se quite el teclado al tocar otra parte de la pantalla.
- (void) quitaTeclado
{
    [self.view endEditing: YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)guardarElemento:(UIButton *)sender {
    // Se crea la alerta para manejar los errores.
    UIAlertView *alerta;
    
    // Si el campo del nombre está vacío.
    if([tfNombre.text isEqualToString:@""]) {
        // Se prepara una alerta indicándolo y se manda.
        alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                            message: @"El nombre del elemento no puede estar vacío"
                                           delegate: self
                                  cancelButtonTitle: @"OK"
                                  otherButtonTitles: nil];
        
        [alerta show];
    }
    else{
        
        // Se obtiene siguiente ID de base de datos.
        NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT MAX(idElemento) AS idElemento FROM Elemento"];
        
        // Se obtiene lo que regresó la query.
        NSInteger iId;
        NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
        
        // Si hubo resultado.
        if (resultadosQuery.count > 0) {
            // Se obtuvo el mayor ID, por lo que se guarda aumentado en 1.
            NSInteger indiceId = [self.dbManager.arrColumnNames indexOfObject:@"idElemento"];
            NSString *sId = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceId]];
            iId = [sId integerValue] + 1;
        }
        
        
        // Si no hubo resultado.
        else {
            // Es el primer registro, por lo que el ID es 1.
            iId = 1;
        }
        
        NSString *sNombre = tfNombre.text;
        
        // Se prepara query para crear nueva área.
        sQuery = [[NSString alloc] initWithFormat:@"INSERT INTO Elemento VALUES(%ld, '%@', %d, '%@', %d)", iId, sNombre, 0, self.sTipo, 0];
        
        // Se ejecuta query.
        [self.dbManager executeQuery:sQuery];
        
        // Si la query fue exitosa.
        if (self.dbManager.affectedRows != 0) {
            
            // Se prepara query para ligar área con diagnóstico.
            sQuery = [[NSString alloc] initWithFormat:@"INSERT INTO ElementoArea VALUES(%ld, %ld)", iId, self.iDArea];
            
            // Se ejecuta query.
            [self.dbManager executeQuery:sQuery];
            
            // Si la query fue exitosa.
            if (self.dbManager.affectedRows != 0) {
                // Se prepara una alerta indicándolo y se manda.
                alerta = [[UIAlertView alloc] initWithTitle: @"Éxito!"
                                                    message: @"Elemento creado exitosamente"
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
                
                [alerta show];
                
                // Se actualiza la vista en el delegado.
                sNombre = [[NSString alloc]initWithFormat:@"%@ - %@", sNombre, self.sTipo];
                [self.delegado guardaElemento: sNombre Tipo: self.sTipo ID:iId];
                [self.delegado quitaVista];
            }
            // Si hubo un problema con la query.
            else{
                // Se prepara una alerta indicándolo y se manda.
                alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                    message: @"Problema al crear elemento"
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
                
                [alerta show];
            }
        }
        
        // Si hubo un problema con la query.
        else{
            // Se prepara una alerta indicándolo y se manda.
            alerta = [[UIAlertView alloc] initWithTitle: @"Error!"
                                                message: @"Problema al crear elemento"
                                               delegate: self
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
            
            [alerta show];
        }
        
    }
}

/*
#pragma mark - PickerView
 
Métodos para manejar el picker view en la interfaz.
*/

// Método que obtiene el valor del tipo de elemento seleccionado.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.sTipo = [arrElementos objectAtIndex:row];
}

// Método que dice cuántos elementos tiene el picker view.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrElementos.count;
}

// Método que dice cuántos componentes tiene el picker view.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// Método que dice el nombre del tipo en el picker view.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return arrElementos[row];
}
 
@end
