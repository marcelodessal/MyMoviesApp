//
//  PersistanceManager.m
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/11/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import "PersistanceManager.h"
#import <CoreData/CoreData.h>

@interface PersistanceManager()

@property (strong, nonatomic) NSManagedObjectContext *mainThreadManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *saveManagedObjectContext;

@end

@implementation PersistanceManager

- (void)setupCoreDataStackWithCompletionHandler:(PersistanceManagerStackSetupCompletionHandler)handler {
    if ([self saveManagedObjectContext]) return;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyMoviesApp" withExtension:@"momd"];
    if (!modelURL) {
        NSError *customError = nil; //Return a custom error
        handler(NO, customError);
        return;
    }
    
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if (!mom) {
        NSError *customError = nil; //Return a custom error
        handler(NO, customError);
        return;
    }
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (!psc) {
        NSError *customError = nil; //Return a custom error
        handler(NO, customError);
        return;
    }
    
    NSManagedObjectContext *saveMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [saveMoc setPersistentStoreCoordinator:psc];
    [self setSaveManagedObjectContext:saveMoc];
    
    NSManagedObjectContext *mainThreadMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [mainThreadMoc setParentContext:[self saveManagedObjectContext]];
    [self setMainThreadManagedObjectContext:mainThreadMoc];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSArray *directoryArray = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
        NSURL *storeURL = [directoryArray lastObject];
        
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtURL:storeURL withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSError *customError = nil; //Return a custom error
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(NO, customError);
            });
        }
        storeURL = [storeURL URLByAppendingPathComponent:@"MyMoviesApp.sqlite"];
        NSLog(storeURL.description, nil);
        
        NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES };
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        
        if (!store) {
            NSError *customError = nil; //Return a custom error
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(NO, customError);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(YES, nil);
            });
        }
    });
}

- (void)saveDataWithCompletionHandler:(PersistanceManagerSaveCompletionHandler)handler
{
    if (![NSThread isMainThread]) { //Always start from the main thread
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self saveDataWithCompletionHandler:handler];
        });
        return;
    }
    
    //Don't work if you don't need to (you can talk to these without performBlock)
    if (![[self mainThreadManagedObjectContext] hasChanges] && ![[self saveManagedObjectContext] hasChanges]) {
        if (handler) handler(YES, nil);
        return;
    }
    
    NSError *error = nil;
    if (![[self mainThreadManagedObjectContext] save:&error]) {
        if (handler) handler (NO, error);
        return; //fail early and often
    }
    
    [[self saveManagedObjectContext] performBlock:^{ //private context must be on its own queue
        NSError *saveError = nil;
        if (![[self saveManagedObjectContext] save:&saveError]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(NO, saveError);
            });
            return;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) handler(YES, nil);
            });
        }
    }];
}

@end
