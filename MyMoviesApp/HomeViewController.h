//
//  HomeViewController.h
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/9/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITextFieldDelegate>

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;

@end
