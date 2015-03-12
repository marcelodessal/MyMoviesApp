//
//  MovieDetailViewController.m
//  
//
//  Created by Marcelo Dessal on 3/10/15.
//
//

#import "MovieDetailViewController.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleAndYearLbl;
@property (weak, nonatomic) IBOutlet UILabel *castLbl;
@property (weak, nonatomic) IBOutlet UITextView *PlotTextView;


@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleAndYearLbl.text = [NSString stringWithFormat:@"%@ (%@)", self.movie.movieTitle, self.movie.releaseYear];
    NSMutableArray *castArray = [[NSMutableArray alloc] init];
    for (Actor* actor in self.movie.actors) {
        [castArray addObject:actor.name];
    }
    self.castLbl.text = [[castArray valueForKey:@"description"] componentsJoinedByString:@", "];
    self.PlotTextView.text = self.movie.plot;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
