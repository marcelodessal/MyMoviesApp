//
//  Actor.h
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/10/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Actor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Movie *movie;

@end
