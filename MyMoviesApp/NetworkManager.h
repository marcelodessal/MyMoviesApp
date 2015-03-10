//
//  NetworkManager.h
//  MyMoviesApp
//
//  Created by Marcelo Dessal on 3/9/15.
//  Copyright (c) 2015 Marcelo Dessal. All rights reserved.
//

#import "AFHTTPSessionManager.h"

extern NSString * const kimdbBaseURLString;

typedef void(^Success)(NSURLSessionDataTask *task, id responseObject);
typedef void(^Failure)(NSURLSessionDataTask *task, NSError *error);

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;
- (void)getMovieInfo:(NSString*)movie sucsess:(Success)success failure:(Failure)failure;

@end
