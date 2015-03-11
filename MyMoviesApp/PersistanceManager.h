//
//  PersistanceManager.h
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/11/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^OTSDatabaseManagerStackSetupCompletionHandler)(BOOL suceeded, NSError *error);
typedef void(^OTSDatabaseManagerSaveCompletionHandler)(BOOL suceeded, NSError *error);

@interface PersistanceManager : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;

- (void)setupCoreDataStackWithCompletionHandler:(OTSDatabaseManagerStackSetupCompletionHandler)handler;
- (void)saveDataWithCompletionHandler:(OTSDatabaseManagerSaveCompletionHandler)handler;

@end
