//
//  PersistanceManager.h
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/11/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PersistanceManagerStackSetupCompletionHandler)(BOOL suceeded, NSError *error);
typedef void(^PersistanceManagerSaveCompletionHandler)(BOOL suceeded, NSError *error);

@interface PersistanceManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;

- (void)setupCoreDataStackWithCompletionHandler:(PersistanceManagerStackSetupCompletionHandler)handler;
- (void)saveDataWithCompletionHandler:(PersistanceManagerSaveCompletionHandler)handler;

@end
