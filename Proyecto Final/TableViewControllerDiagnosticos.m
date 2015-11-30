//
//  TableViewControllerDiagnosticos.m
//  
//
//  Created by José Manuel González Castro on 11/21/15.
//
//

#import "TableViewControllerDiagnosticos.h"
#import "ViewControllerDetallesDiagnostico.h"

@interface TableViewControllerDiagnosticos ()

// Objeto manejador de bases de datos.
@property (nonatomic, strong) DBManager *dbManager;
// Arreglos que guardan diagnósticos, porcentajes y ids
@property (nonatomic, strong) NSMutableArray *arrDiagnosticos;
@property (nonatomic, strong) NSMutableArray *arrPorcentajes;
@property (nonatomic, strong) NSMutableArray *arrIds;

@end

@implementation TableViewControllerDiagnosticos

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Se carga la base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];
    
    self.arrDiagnosticos = [[NSMutableArray alloc] init];
    self.arrPorcentajes = [[NSMutableArray alloc] init];
    self.arrIds = [[NSMutableArray alloc] init];
    
    // Se crea la query para seleccionar las áreas.
    NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT idUsuario FROM Usuario WHERE email = '%@'", self.sEmail];
    
    // Se obtiene lo que regresó la query.
    NSInteger iIdUsuario;
    NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
    
    UIAlertView *alerta;
    
    // Si hubo resultado.
    if (resultadosQuery.count > 0) {
        // Se guarda índice de id de área.
        NSInteger indiceIdUsuario = [self.dbManager.arrColumnNames indexOfObject:@"idUsuario"];
        NSString *sIdUsuario = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceIdUsuario]];
        iIdUsuario = [sIdUsuario integerValue];

        // Se prepara query para obtener nombre de área.
        sQuery = [[NSString alloc] initWithFormat:@"SELECT idDiagnostico, nombre, porcentajeAccesibilidad FROM Diagnostico WHERE idUsuario = '%ld'", iIdUsuario];
            
        // Se almacenan los resultados.
        NSMutableArray *resultadosQuery2 = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
            
        // Si hubo resultados.
        if(resultadosQuery2.count > 0) {
            NSInteger iTam = resultadosQuery2.count - 1;
            
            while (iTam >= 0) {
                NSInteger indiceIdDiagnostico = [self.dbManager.arrColumnNames indexOfObject:@"idDiagnostico"];
                NSInteger indiceNombre = [self.dbManager.arrColumnNames indexOfObject:@"nombre"];
                NSInteger indicePorcentajeAccesibilidad = [self.dbManager.arrColumnNames indexOfObject:@"porcentajeAccesibilidad"];
                NSString *sIdDiagnostico = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:iTam] objectAtIndex:indiceIdDiagnostico]];
                NSString *sNombre = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:iTam] objectAtIndex:indiceNombre]];
                NSString *sPorcentajeAccesibilidad = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:iTam] objectAtIndex:indicePorcentajeAccesibilidad]];
                
                // Se almacena área.
                [self.arrIds addObject:sIdDiagnostico];
                [self.arrDiagnosticos addObject:sNombre];
                [self.arrPorcentajes addObject:sPorcentajeAccesibilidad];
                
                iTam--;
            }
        }
        // Si no hubo resultados.
        else {
            // Se prepara una alerta indicándolo y se manda.
            alerta = [[UIAlertView alloc] initWithTitle: @"Aviso!"
                                                message: @"No hay diagnósticos que cargar"
                                                delegate: self
                                        cancelButtonTitle: @"OK"
                                        otherButtonTitles: nil];
            
            [alerta show];
        }
    }
    
    // Si no hubo resultados.
    else {
        // Se prepara una alerta indicándolo y se manda.
        alerta = [[UIAlertView alloc] initWithTitle: @"Aviso!"
                                            message: @"No hay diagnósticos que cargar"
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.arrDiagnosticos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Se despliegan tanto el nombre del diagnóstico como su porcentaje
    // de accesibilidad en la celda.
    cell.textLabel.text = [self.arrDiagnosticos objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.arrPorcentajes objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Se obtiene celda seleccionada.
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    self.iIdDiagnostico = [[self.arrIds objectAtIndex:indexPath.row] integerValue];
    
    // Se manda llamar el segue específico correspondiente.
    [self performSegueWithIdentifier:@"DetallesDiagnostico" sender:cell];
}

// Método que inicializa las condiciones iniciales de las siguientes vistas.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"DetallesDiagnostico"]) {
        [(ViewControllerDetallesDiagnostico *)[segue destinationViewController] setIIdDiagnostico:self.iIdDiagnostico];
    }
}

// Método que sirven para regresar a la pantalla de Diagnósticos
- (IBAction)unwindDetalles:(UIStoryboardSegue *)segue {
}

@end
