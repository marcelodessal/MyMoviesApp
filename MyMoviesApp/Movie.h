//
//  Movie.h
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/10/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Movie : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *actors;
@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(NSManagedObject *)value;
- (void)removeActorsObject:(NSManagedObject *)value;
- (void)addActors:(NSSet *)values;
- (void)removeActors:(NSSet *)values;

@end
