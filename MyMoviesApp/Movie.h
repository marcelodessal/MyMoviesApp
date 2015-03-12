//
//  Movie.h
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/11/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * movieTitle;
@property (nonatomic, retain) NSNumber * releaseYear;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSSet *actors;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSSet *)values;
- (void)removeActors:(NSSet *)values;

@end
