//
//  Actor.h
//  MyMoviesApp
//
//  Created by MarceloDessal on 3/12/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Actor : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Movie *movie;

@end
