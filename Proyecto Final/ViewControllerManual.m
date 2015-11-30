//
//  ViewControllerManual.m
//  
//
//  Created by José Manuel González Castro on 11/21/15.
//
//

#import "ViewControllerManual.h"

@interface ViewControllerManual ()

@end

@implementation ViewControllerManual

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Se obtiene el path del manual de accesibilidad y se despliega
    // en el view correspondiente.
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Manual" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.manual loadRequest:request];
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

@end
