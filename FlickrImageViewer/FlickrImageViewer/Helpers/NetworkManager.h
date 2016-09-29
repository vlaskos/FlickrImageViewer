//
//  NetworkManager.h
//  FlickrImageViewer
//
//  Created by vlaskos on 27.09.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkManager : NSObject

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

+ (NetworkManager*) sharedManager;

- (void) getImagesListWithTag:(NSString*)tag
                    OnSuccess:(void(^)(id result)) success
                    onFailure:(void(^)(NSError* error, id responseObject)) failure;

- (void) getImageWithInfo:(NSDictionary*)info
                OnSuccess:(void(^)(id result)) success
                onFailure:(void(^)(NSError* error, id responseObject)) failure;

@end
