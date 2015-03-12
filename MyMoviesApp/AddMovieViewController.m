//
//  AddMovieViewController.m
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/9/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import "AddMovieViewController.h"
#import "NetworkManager.h"
#import "Movie.h"
#import "Actor.h"
#import "UITextView+Border.h"

@interface AddMovieViewController ()

@property (weak, nonatomic) IBOutlet UITextField *findMovie;
@property (weak, nonatomic) IBOutlet UIView *form;
@property (weak, nonatomic) IBOutlet UITextField *movieTitle;
@property (weak, nonatomic) IBOutlet UITextField *releaseYear;
@property (weak, nonatomic) IBOutlet UITextView *castTextView;
@property (weak, nonatomic) IBOutlet UITextView *plotTextView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation AddMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self reset:nil];
    [self.castTextView setBorderWithColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] CGColor]];
    [self.plotTextView setBorderWithColor:[[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] CGColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchMovie:(id)sender {
    [[NetworkManager sharedInstance] getMovieInfo:self.findMovie.text sucsess:[self processMovieInfo] failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Cannot connect to server. Try again later"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }];
}

- (IBAction)reset:(id)sender {
    
    self.findMovie.text = @"";
    self.movieTitle.text = @"";
    self.releaseYear.text = @"";
    self.castTextView.text = @"";
    self.plotTextView.text = @"";
    
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
    [self addMovie];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

- (Success)processMovieInfo {
    return ^(NSURLSessionTask *task, id responseObject){
        __weak typeof(self) weakSelf = self;
        NSDictionary *movieInfo = responseObject;

        weakSelf.movieTitle.text = [movieInfo objectForKey:@"Title"];
        weakSelf.releaseYear.text = [movieInfo objectForKey:@"Year"];
        weakSelf.castTextView.text = [movieInfo objectForKey:@"Actors"];
        weakSelf.plotTextView.text = [movieInfo objectForKey:@"Plot"];

        [weakSelf.resetBtn setEnabled:NO];
        [weakSelf.form setHidden:YES];
    };
}


#pragma mark - Core data

- (void)addMovie {
    Movie *newMovie = [[Movie alloc] initWithEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:[[self persistanceManager] mainThreadManagedObjectContext]] insertIntoManagedObjectContext:[[self persistanceManager] mainThreadManagedObjectContext]];
    
    newMovie.movieTitle = self.movieTitle.text;
    newMovie.releaseYear = [NSNumber numberWithInt:[self.releaseYear.text intValue]];
    newMovie.plot = self.plotTextView.text;
    
    NSMutableArray *actors = [[NSMutableArray alloc] init];
    
    NSArray *actorsArray = [self.castTextView.text componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
    
    for (NSString* actor in actorsArray) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Actor"
                                                  inManagedObjectContext:[[self persistanceManager] mainThreadManagedObjectContext]];
        
        Actor *newActor = [[Actor alloc] initWithEntity:entity
                         insertIntoManagedObjectContext:[[self persistanceManager] mainThreadManagedObjectContext]];
        
        newActor.name = actor;
        [actors addObject:newActor];
    }
    
    newMovie.actors = [NSSet setWithArray:actors];
    
    [[self persistanceManager] saveDataWithCompletionHandler:^(BOOL suceeded, NSError *error) {
        if (!suceeded) {
            NSLog(@"Core Data save failed.");
        }
    }];
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
