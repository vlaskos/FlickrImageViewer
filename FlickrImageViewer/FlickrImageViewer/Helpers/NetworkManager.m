//
//  NetworkManager.m
//  FlickrImageViewer
//
//  Created by vlaskos on 27.09.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "NetworkManager.h"

#define APIKEY @"5505d1e1fcd4a2ddede9f106231cf963"

@interface NetworkManager ()



@end

@implementation NetworkManager

+ (NetworkManager*) sharedManager {
    
    static NetworkManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        //        NSURL* url = [NSURL URLWithString:@"http://api.citybase.in.ua/api/"];
//        NSURL* url = [NSURL URLWithString:@"https://api.flickr.com/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"appication/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"appication/json" forHTTPHeaderField:@"Accept"];
        self.requestOperationManager.requestSerializer = requestSerializer;
        
        self.requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }
    return self;
}

- (void) getImagesListWithTag:(NSString*)tag
                    OnSuccess:(void(^)(id result)) success
                     onFailure:(void(^)(NSError* error, id responseObject)) failure{
    
    
    NSDictionary* params = @{ @"method":@"flickr.photos.search",
                              @"api_key":       APIKEY,
                              @"tags" :         tag,
                              @"format":        @"json",
                              @"nojsoncallback":@"1",
                              @"per_page" :     @50};
    
    
    
    [self.requestOperationManager
     GET:@"https://api.flickr.com/services/rest"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         
         if (success) {
             success(responseObject);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.responseObject);
         }
     }];

}

- (void) getImageWithInfo:(NSDictionary*)info
                OnSuccess:(void(^)(id result)) success
                    onFailure:(void(^)(NSError* error, id responseObject)) failure{

    NSString *farmId = [info objectForKey:@"farm_id"];
    NSString *serverId = [info objectForKey:@"server_id"];
    NSString *photoId = [info objectForKey:@"photo_id"];
    NSString *secret = [info objectForKey:@"secret"];
    NSString *size = @"m";
    
    
    NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farmId, serverId, photoId, secret, size];
    
    [self.requestOperationManager
     GET:url
     parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         
         
         if (success) {
             success(responseObject);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, operation.responseObject);
         }
     }];
    
}

@end
