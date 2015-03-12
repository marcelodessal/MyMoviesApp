//
//  UITextView+Border.m
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/11/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import "UITextView+Border.h"

@implementation UITextView (Border)

- (void)setCustomBorder {
    self.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] CGColor];
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = YES;
    
}

@end
