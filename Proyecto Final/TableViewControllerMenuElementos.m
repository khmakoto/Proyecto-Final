//
//  TableViewControllerMenuElementos.m
//  
//
//  Created by José Manuel González Castro on 11/5/15.
//
//

#import "TableViewControllerMenuElementos.h"
#import "DBManager.h"

@interface TableViewControllerMenuElementos ()

@property (nonatomic, strong) NSMutableArray *arrElementos;
@property (nonatomic, strong) NSMutableArray *arrTipos;
@property (nonatomic, strong) NSMutableArray *arrIds;
@property (nonatomic, strong) NSMutableArray *arrPorcentajes;
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation TableViewControllerMenuElementos


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Se inicializa el arreglo de las áreas vacío.
    self.arrElementos = [[NSMutableArray alloc] init];
    self.arrTipos = [[NSMutableArray alloc] init];
    self.arrIds = [[NSMutableArray alloc] init];
    self.arrPorcentajes = [[NSMutableArray alloc] init];
    
    // Se carga la base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];

    // Se crea la alerta de error.
    UIAlertView *alerta;
    
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
            [self.arrIds addObject:sIdElemento];
            
            // Se prepara query para obtener nombre de área.
            sQuery = [[NSString alloc] initWithFormat:@"SELECT nombre, tipo, porcentajeAccesibilidad FROM Elemento WHERE idElemento = %ld", iIdElemento];
            
            // Se almacenan los resultados.
            NSMutableArray *resultadosQuery2 = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
            
            // Si hubo resultados.
            if(resultadosQuery2.count > 0) {
                // Se guarda nombre de área.
                NSInteger indiceNombre = [self.dbManager.arrColumnNames indexOfObject:@"nombre"];
                NSInteger indiceTipo = [self.dbManager.arrColumnNames indexOfObject:@"tipo"];
                NSInteger indicePorcentaje = [self.dbManager.arrColumnNames indexOfObject:@"porcentajeAccesibilidad"];
                NSString *sNombre = [[NSString alloc] initWithFormat:@"%@ - %@", [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indiceNombre], [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indiceTipo]];
                NSString *sTipo = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indiceTipo]];
                NSString *sPorcentaje = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indicePorcentaje]];
                
                // Se almacena área.
                [self.arrElementos addObject:sNombre];
                [self.arrTipos addObject:sTipo];
                [self.arrPorcentajes addObject:sPorcentaje];
            }
            // Si no hubo resultados.
            else {
                // Se prepara una alerta indicándolo y se manda.
                alerta = [[UIAlertView alloc] initWithTitle: @"Aviso!"
                                                    message: @"No hay elementos que cargar"
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
                                            message: @"No hay elementos que cargar"
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
    if([segue.identifier isEqualToString:@"agregarElemento"]) {
        [[segue destinationViewController] setIDArea:self.idArea];
        [[segue destinationViewController] setDelegado:self];
    }
    else if(segue.identifier != nil){
        [[segue destinationViewController] setDelegado:self];
        [[segue destinationViewController] setIId:self.idElemento];
        [[segue destinationViewController] setIPorcentaje:self.iPorcentaje];
    }
}

-(IBAction)unwindAgregarElementos:(UIStoryboardSegue *)segue {
}

-(IBAction)unwindElemento:(UIStoryboardSegue *)segue {
}

-(IBAction)unwindGuardaElemento:(UIStoryboardSegue *)segue {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrElementos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Se obtiene el identificador de las celdas.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Se carga el área a la celda.
    cell.textLabel.text = self.arrElementos[indexPath.row];
    
    // Se regresa la celda.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Se obtiene celda seleccionada.
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Se obtiene celda seleccionada.
    NSString *sTipo = [self.arrTipos objectAtIndex:indexPath.row];
    
    // Se obtiene id del elemento seleccionado.
    self.idElemento = [[self.arrIds objectAtIndex:indexPath.row] integerValue];
    // Se obtiene id del elemento seleccionado.
    self.iPorcentaje = [[self.arrPorcentajes objectAtIndex:indexPath.row] integerValue];
    
    // Se manda llamar el segue específico correspondiente.
    [self performSegueWithIdentifier:sTipo sender:cell];
}

// Método que regresa la vista al guardar una nueva área.
- (void) quitaVista {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// Método que carga las nuevas áreas en la tabla.
- (void) guardaElemento:(NSString *)sNuevoElemento Tipo:(NSString *)sTipo ID:(NSInteger)iId{
    // Se carga nuevo string.
    [self.arrElementos addObject:sNuevoElemento];
    [self.arrTipos addObject:sTipo];
    [self.arrPorcentajes addObject:@"0"];
    [self.arrIds addObject:[[NSString alloc]initWithFormat:@"%ld", iId]];
    
    // Se recarga la tabla.
    [self.tableView reloadData];
}

-(void) guardarPorcentaje:(NSInteger)iPorcentaje ID:(NSInteger)iId{
    NSInteger iIndex;
    for (int i = 0; i < self.arrIds.count; i++) {
        if (iId == [[self.arrIds objectAtIndex:i] integerValue]) {
            iIndex = i;
            break;
        }
    }
    
    [self.arrPorcentajes replaceObjectAtIndex:iIndex withObject:[[NSString alloc]initWithFormat:@"%ld", iPorcentaje]];
}

@end
