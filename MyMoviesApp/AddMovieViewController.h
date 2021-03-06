//
//  AddMovieViewController.h
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/9/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersistanceManager.h"

@interface AddMovieViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) PersistanceManager *persistanceManager;

@end
