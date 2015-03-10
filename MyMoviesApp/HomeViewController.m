//
//  HomeViewController.m
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/9/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import "HomeViewController.h"
#import "NetworkManager.h"
#import "Movie.h"
#import "Actor.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *yearLbl;
@property (weak, nonatomic) IBOutlet UITableView *actorsTableView;
@property (strong, nonatomic) NSArray *actors;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLbl.hidden = YES;
    self.yearLbl.hidden = YES;
    self.actorsTableView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchMovie:(id)sender {
    [[NetworkManager sharedInstance] getMovieInfo:self.textField.text sucsess:[self processMovieInfo] failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    [self.textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchMovie:nil];
    return YES;
}

- (Success)processMovieInfo {
    return ^(NSURLSessionTask *task, id responseObject){
        NSDictionary *movieInfo = responseObject;
        
        self.titleLbl.text = [NSString stringWithFormat:@"Title: %@", [movieInfo objectForKey:@"Title"]];
        self.yearLbl.text = [NSString stringWithFormat:@"Year: %@", [movieInfo objectForKey:@"Year"]];
        NSString *actorsString = [movieInfo objectForKey:@"Actors"];
        self.actors = [actorsString componentsSeparatedByString:@", "];
        
        self.titleLbl.hidden = NO;
        self.yearLbl.hidden = NO;
        self.actorsTableView.hidden = NO;
        [self.actorsTableView reloadData];

        Movie *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:self.managedObjectContext];
        newMovie.title = self.titleLbl.text;
        newMovie.year = [NSNumber numberWithInt:[self.yearLbl.text intValue]];
 //       newMovie.actors = [NSSet setWithArray:self.actors];
        
    };
}


#pragma mark - TableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actors.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Actors";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ActorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.actors[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
