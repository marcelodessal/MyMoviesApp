//
//  Movie.h
//  MyMoviesApp
//
//  Created by MarceloDessal on 3/12/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor;

@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * movieTitle;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSNumber * releaseYear;
@property (nonatomic, retain) NSOrderedSet *actors;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)insertObject:(Actor *)value inActorsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromActorsAtIndex:(NSUInteger)idx;
- (void)insertActors:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeActorsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInActorsAtIndex:(NSUInteger)idx withObject:(Actor *)value;
- (void)replaceActorsAtIndexes:(NSIndexSet *)indexes withActors:(NSArray *)values;
- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSOrderedSet *)values;
- (void)removeActors:(NSOrderedSet *)values;
@end
