//
//  MyMoviesTableViewController.m
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/10/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import "MyMoviesTableViewController.h"
#import "AddMovieViewController.h"
#import "MovieDetailViewController.h"
#import "PersistanceManager.h"

@interface MyMoviesTableViewController ()

@property (strong, nonatomic) PersistanceManager *persistanceManager;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addMoviesBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addMovieBtn;

@end

@implementation MyMoviesTableViewController

#pragma mark - Property Overrides

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) return _fetchedResultsController;
    
    NSManagedObjectContext *moc = [[self persistanceManager] mainThreadManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Movie"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"movieTitle" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil];
    [self setFetchedResultsController:frc];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    NSAssert([_fetchedResultsController performFetch:&error], @"Unresolved error %@\n%@", [error localizedDescription], [error userInfo]);
    return _fetchedResultsController;
}

#pragma mark - Method Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.addMovieBtn setEnabled:NO];
    [self.addMoviesBtn setEnabled:NO];
    
    [self setPersistanceManager:[[PersistanceManager alloc] init]];
    [[self persistanceManager] setupCoreDataStackWithCompletionHandler:^(BOOL suceeded, NSError *error) {
        if (suceeded) {
            [self.addMovieBtn setEnabled:YES];
            [self.addMoviesBtn setEnabled:YES];

            [self fetchedResultsController];
        } else {
            NSLog(@"Core Data stack setup failed.");
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (IBAction)addMovies:(id)sender {
    NSManagedObjectContext *batchAddContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [batchAddContext setParentContext:[[self persistanceManager] mainThreadManagedObjectContext]];
    [batchAddContext performBlock:^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"movies" withExtension:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSArray *movieList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        for (NSDictionary* item in movieList) {
            Movie *newMovie = [[Movie alloc] initWithEntity:[NSEntityDescription entityForName:@"Movie"
                                                                        inManagedObjectContext:batchAddContext]
                             insertIntoManagedObjectContext:batchAddContext];
            
            newMovie.movieTitle = [item objectForKey:@"title"];
            newMovie.releaseYear = [item objectForKey:@"year"];
            newMovie.plot = [item objectForKey:@"plot"];
            
            NSMutableArray *actors = [[NSMutableArray alloc] init];
            NSArray *actorsArray = [[item objectForKey:@"actors"] componentsSeparatedByString:@", "];
            
            for (NSString* actor in actorsArray) {
                Actor *newActor = [[Actor alloc] initWithEntity:[NSEntityDescription entityForName:@"Actor"
                                                                            inManagedObjectContext:batchAddContext]
                                 insertIntoManagedObjectContext:batchAddContext];
                
                newActor.name = actor;
                [actors addObject:newActor];
            }
            
            newMovie.actors = [NSOrderedSet orderedSetWithArray:actors];

        }

        // Save the batchAddContext which pushes the items onto the main thread context
        NSError *error;
        if (![batchAddContext save:&error]) {
            NSLog(@"Unable to save batch added items: %@", [error localizedDescription]);
            return;
        }
        
        // Save the main thead context... saveDataWithCompletionHandler: uses the right thread
        [[self persistanceManager] saveDataWithCompletionHandler:^(BOOL suceeded, NSError *error) {
            if (!suceeded) {
                NSLog(@"Core Data save failed.");
            }
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [[self fetchedResultsController] sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    cell.textLabel.text = [object valueForKey:@"movieTitle"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[object valueForKey:@"releaseYear"]];
        
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSArray *newArray = nil;
    NSArray *oldArray = nil;
    
    if (newIndexPath) {
        newArray = [NSArray arrayWithObject:newIndexPath];
    }
    
    if (indexPath) {
        oldArray = [NSArray arrayWithObject:indexPath];
    }
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:newArray withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:oldArray withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
            NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            [[cell textLabel] setText:[object valueForKey:@"movieTitle"]];
            [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@",[object valueForKey:@"releaseYear"]]];
            break;
        }
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:oldArray withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:newArray withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"addMovie"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        AddMovieViewController *controller = (AddMovieViewController*)[navController topViewController];
        controller.persistanceManager = [self persistanceManager];
        
    } else if ([segue.identifier isEqualToString:@"movieDetail"]) {
        
        MovieDetailViewController *controller = [segue destinationViewController];
        controller.movie = [[self fetchedResultsController] objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
    
}


@end
