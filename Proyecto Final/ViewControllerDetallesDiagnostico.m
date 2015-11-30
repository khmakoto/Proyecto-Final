//
//  ViewControllerDetallesDiagnostico.m
//  
//
//  Created by José Manuel González Castro on 11/21/15.
//
//

#import "ViewControllerDetallesDiagnostico.h"

@interface ViewControllerDetallesDiagnostico ()

// Objeto manejador de bases de datos.
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ViewControllerDetallesDiagnostico

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Se carga la base de datos.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"diagnosticos.sqlite"];
    
    // Variables que almacenan las áreas y porcentajes de accesibilidad
    // del diagnóstico.
    NSString *sAreas = [[NSString alloc] initWithFormat:@""];
    NSString *sPorcentajes = [[NSString alloc] initWithFormat:@""];
    
    // Se crea la query para seleccionar las áreas.
    NSString *sQuery = [[NSString alloc] initWithFormat:@"SELECT nombre, fecha, lugar, porcentajeAccesibilidad FROM Diagnostico WHERE idDiagnostico = %ld", self.iIdDiagnostico];
    
    // Se obtiene lo que regresó la query.
    NSString *sNombre;
    NSString *sFecha;
    NSString *sLugar;
    NSString *sPorcentajeTotal;
    
    // Arreglo donde se guardan los resultados del query
    NSMutableArray *resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
    
    // Si hubo resultados
    if (resultadosQuery.count > 0) {
        NSInteger indiceNombre = [self.dbManager.arrColumnNames indexOfObject:@"nombre"];
        NSInteger indiceFecha = [self.dbManager.arrColumnNames indexOfObject:@"fecha"];
        NSInteger indiceLugar = [self.dbManager.arrColumnNames indexOfObject:@"lugar"];
        NSInteger indicePorcentajeTotal = [self.dbManager.arrColumnNames indexOfObject:@"porcentajeAccesibilidad"];
        
        sNombre = [[NSString alloc]initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceNombre]];
        sFecha = [[NSString alloc]initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceFecha]];
        sLugar = [[NSString alloc]initWithFormat:@"%@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indiceLugar]];
        sPorcentajeTotal = [[NSString alloc]initWithFormat:@"Porcentaje de aceptación del diagnóstico: %@", [[resultadosQuery objectAtIndex:0] objectAtIndex:indicePorcentajeTotal]];
        
        // Se despliegan los resultados en los campos de texto y labels
        self.tfNombre.text = sNombre;
        self.tfFecha.text = sFecha;
        self.tfLugar.text = sLugar;
        self.lbPorcentajeTotal.text = sPorcentajeTotal;
        
        // Se valida si el diagnóstico es aceptado o no.
        if ([sPorcentajeTotal isEqualToString:@"Porcentaje de aceptación del diagnóstico: 100"]) {
            self.lbEstado.text = [[NSString alloc] initWithFormat:@"Estado: Aceptado"];
        }
    }

    sQuery = [[NSString alloc] initWithFormat:@"SELECT idArea FROM DiagnosticoArea WHERE idDiagnostico = %ld", self.iIdDiagnostico];
    
    resultadosQuery = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
    // Si hubo resultado.
    if (resultadosQuery.count > 0) {
        NSInteger iTam = resultadosQuery.count - 1;
        NSInteger indiceIdArea = [self.dbManager.arrColumnNames indexOfObject:@"idArea"];
        
        while (iTam >= 0) {
            // Se guarda índice de id de área.
            NSString *sIdArea = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery objectAtIndex:iTam] objectAtIndex:indiceIdArea]];
            NSInteger iIdArea = [sIdArea integerValue];
            
            // Se prepara query para obtener nombre de área.
            sQuery = [[NSString alloc] initWithFormat:@"SELECT nombre, porcentajeAccesibilidad FROM Area WHERE idArea = '%ld'", iIdArea];
        
            // Se almacenan los resultados.
            NSMutableArray *resultadosQuery2 = [[NSMutableArray alloc] initWithArray:[self.dbManager loadDataFromDB:sQuery]];
        
            // Si hubo resultados.
            if(resultadosQuery2.count > 0) {
            
                NSInteger indiceNombre = [self.dbManager.arrColumnNames indexOfObject:@"nombre"];
                NSInteger indicePorcentajeAccesibilidad = [self.dbManager.arrColumnNames indexOfObject:@"porcentajeAccesibilidad"];
                NSString *sNombre = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indiceNombre]];
                NSString *sPorcentajeAccesibilidad = [[NSString alloc] initWithFormat:@"%@", [[resultadosQuery2 objectAtIndex:0] objectAtIndex:indicePorcentajeAccesibilidad]];
                
                // Se agregan el área y su porcentaje de accesibilidad.
                sAreas = [[NSString alloc] initWithFormat:@"%@\n%@", sAreas, sNombre];
                sPorcentajes = [[NSString alloc] initWithFormat:@"%@\n%@", sPorcentajes, sPorcentajeAccesibilidad];
                
            }
            
            iTam--;
            
        }
        
        // Se despliegan las áreas junto con su porcentaje de accesibilidad.
        self.tvArea.text = sAreas;
        self.tvPorcentaje.text = sPorcentajes;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

// Método que sirven para regresar a la pantalla de Detalles del diagnóstico
- (IBAction)unwindManual:(UIStoryboardSegue *)segue{
}

@end
