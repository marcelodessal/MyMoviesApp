//
//  NetworkManager.m
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/9/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworkActivityIndicatorManager.h"

NSString* const kBaseURLString = @"http://www.omdbapi.com";

@implementation NetworkManager

+ (instancetype)sharedInstance {
    static NetworkManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Network activity indicator manager setup
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        // Session configuration setup
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.timeoutIntervalForRequest = 5.0f;
        
        // Initialize the session
        NSURL *baseURL = [NSURL URLWithString:kBaseURLString];
        _sharedInstance = [[NetworkManager alloc] initWithBaseURL:baseURL sessionConfiguration:sessionConfiguration];
        
        //Setup a default JSONSerializer for all request/responses.
        _sharedInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        _sharedInstance.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
    });
    
    return _sharedInstance;
}

-(void)getMovieInfo:(NSString *)movie sucsess:(Success)success failure:(Failure)failure {
    NSString *movieString = [movie stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *URLString = [NSString stringWithFormat:@"/?t=%@&y=&plot=short&r=json", movieString];
    
    [self GET:URLString parameters:nil
      success:success
      failure:failure];
}

@end

