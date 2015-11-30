//
//  TableViewControllerMenuDiagnosticos.m
//  
//
//  Created by José Manuel González Castro on 11/5/15.
//
//

#import "TableViewControllerMenuDiagnosticos.h"
#import "TableViewControllerMenuElementos.h"
#import "ViewControllerAgregarArea.h"
#import "DBManager.h"

@interface TableViewControllerMenuDiagnosticos ()

// Se crea arreglo para guardar las áreas.
@property NSMutableArray *arrAreas;

// Se crea arreglo para guardar el id del área.
@property NSMutableArray *arrIDAreas;

// Se crea el objeto que maneja la base de datos.
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation TableViewControllerMenuDiagnosticos

// Método que inicializa las condiciones de la vista.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Se despliega el toolbar inferior. 
    self.navigationController.toolbarHidden = NO;
    
    // Se inicializa el arreglo de las áreas vacío.
    self.arrAreas = [[NSMutableArray alloc] init];
    self.arrIDAreas = [[NSMutableArray alloc] init];
    
    // Se carga la base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];
    
    // Se crea la alerta de error.
    UIAlertView *alerta;
    
    // Se crea la query para seleccionar las áreas.
    NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT idArea FROM DiagnosticoArea WHERE idDiagnostico = %ld", self.iIdDiagnostico];
    
    // Se obtiene lo que regresó la query.
    NSInteger iIdArea;
    NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
    
    // Si hubo resultado.
    if (resultadosQuery.count > 0) {
        // Se guarda índice de id de área.
        NSInteger indiceIdArea = [self.dbManager.arrColumnNames indexOfObject:@"idArea"];
        NSInteger tamArreglo = resultadosQuery.count - 1;
        NSString *sIdArea;
        
        // Se itera sobre resultados de query.
        while(tamArreglo >= 0) {
            // Se guarda el iD de área.
            sIdArea = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:tamArreglo] objectAtIndex:indiceIdArea]];
            iIdArea = [sIdArea integerValue];
            
            // Se agrega el id al arreglo de id's.
            [self.arrIDAreas addObject:sIdArea];
            
            // Se prepara query para obtener nombre de área.
            sQuery = [[NSString alloc] initWithFormat:@"SELECT nombre FROM Area WHERE idArea = '%ld'", iIdArea];
            
            // Se almacenan los resultados.
            NSMutableArray *resultadosQuery2 = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
            
            // Si hubo resultados.
            if(resultadosQuery2.count > 0) {
                // Se guarda nombre de área.
                NSInteger indiceNombre = [self.dbManager.arrColumnNames indexOfObject:@"nombre"];
                NSString *sNombre = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indiceNombre]];
                
                // Se almacena área.
                [self.arrAreas addObject:sNombre];
            }
            // Si no hubo resultados.
            else {
                // Se prepara una alerta indicándolo y se manda.
                alerta = [[UIAlertView alloc] initWithTitle: @"Aviso!"
                                                    message: @"No hay áreas que cargar"
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
                
                [alerta show];
            }
        
            // Se decrementa tamaño de arreglo.
            tamArreglo--;
        }
    }
    
    // Si no hubo resultados.
    else {
        // Se prepara una alerta indicándolo y se manda.
        alerta = [[UIAlertView alloc] initWithTitle: @"Aviso!"
                                            message: @"No hay áreas que cargar"
                                           delegate: self
                                  cancelButtonTitle: @"OK"
                                  otherButtonTitles: nil];
        
        [alerta show];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Método que inicializa las condiciones iniciales de las siguientes vistas.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Se manda el iD del diagnóstico si se va a pasar a la vista agregarArea.
    if ([segue.identifier isEqualToString:@"agregarArea"]) {
        [[segue destinationViewController] setIIdDiagnostico:self.iIdDiagnostico];
        [[segue destinationViewController] setDelegado:self];
    }
    else if ([segue.identifier isEqualToString:@"agregarElemento"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.idArea = [(NSString *)self.arrIDAreas[indexPath.row] integerValue];
        
        [(TableViewControllerMenuElementos *)[[segue destinationViewController]topViewController] setIdArea:self.idArea];
    }
}

// Método para regresar a la vista.
- (IBAction)unwindAgregarAreas:(UIStoryboardSegue *)segue {
    
}

// Método que sirve para regresar a la pantalla desde la vista menuElementos.
- (IBAction)unwindMenuElementos:(UIStoryboardSegue *)segue {
    // Variable que guarda el porcentaje de accesibilidad del área
    NSInteger iPorcentajeAccesibilidad = 0;
    
    // Se crea la query para seleccionar las áreas.
    NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT idElemento FROM ElementoArea WHERE idArea = %ld", self.idArea];
    
    // Se obtiene lo que regresó la query.
    NSInteger iIdElemento;
    NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
    
    // Si hubo resultado.
    if (resultadosQuery.count > 0) {
        // Se guarda índice de id de área.
        NSInteger indiceIdElemento = [self.dbManager.arrColumnNames indexOfObject:@"idElemento"];
        NSInteger tamArreglo = resultadosQuery.count - 1;
        NSString *sIdElemento;
        
        // Se itera sobre resultados de query.
        while(tamArreglo >= 0) {
            // Se guarda el iD de área.
            sIdElemento = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:tamArreglo] objectAtIndex:indiceIdElemento]];
            iIdElemento = [sIdElemento integerValue];
            
            // Se prepara query para obtener nombre de área.
            sQuery = [[NSString alloc] initWithFormat:@"SELECT porcentajeAccesibilidad FROM Elemento WHERE idElemento = %ld", iIdElemento];
            
            // Se almacenan los resultados.
            NSMutableArray *resultadosQuery2 = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
            
            // Si hubo resultados.
            if(resultadosQuery2.count > 0) {
                // Se guarda nombre de área.
                NSInteger indicePorcentaje = [self.dbManager.arrColumnNames indexOfObject:@"porcentajeAccesibilidad"];
                NSString *sPorcentaje = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indicePorcentaje]];
                iPorcentajeAccesibilidad += [sPorcentaje integerValue];
            }
            
            // Se decrementa tamaño de arreglo.
            tamArreglo--;
        }
        
        // Se calcula el porcentaje de accesibilidad del área
        iPorcentajeAccesibilidad = iPorcentajeAccesibilidad / resultadosQuery.count;
        
        // Se prepara query para crear nuevo usuario.
        sQuery = [[NSString alloc] initWithFormat:@"UPDATE Area SET porcentajeAccesibilidad = '%ld' WHERE idArea = '%ld'", iPorcentajeAccesibilidad, self.idArea];
        
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
    }
}

#pragma mark - Table view data source

// Método que regresa el número de secciones en el tableView.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Método que regresa el número de celdas en la sección.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // El número de celdas es igual al número de áreas.
    return self.arrAreas.count;
}

// Método que mapea cada celda con un área.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Se obtiene el identificador de las celdas.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Se carga el área a la celda.
    cell.textLabel.text = self.arrAreas[indexPath.row];
    
    // Se regresa la celda.
    return cell;
}


// Método que regresa la vista al guardar una nueva área.
- (void) quitaVista {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// Método que carga las nuevas áreas en la tabla.
- (void) guardaArea:(NSString *)sNuevaArea ID:(NSString *)sNuevoID{
    // Se carga nuevo string y ID.
    [self.arrAreas addObject:sNuevaArea];
    [self.arrIDAreas addObject:sNuevoID];
    
    // Se recarga la tabla.
    [self.tableView reloadData];
}




@end
