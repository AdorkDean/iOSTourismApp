//
//  GCAPIClient.m
//  TourismApp
//
//  Created by 管理员 on 2017/11/15.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "GCAPIClient.h"


@implementation GCAPIClient
#define Header @"http://172.16.120.129:8080/"//服务器基地址
static NSString * const APIBaseURLString = Header;//服务器基地址/**

+(instancetype)shareClient{
    
    static GCAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[GCAPIClient alloc] initWithBaseURL:nil];
    });
    return _sharedClient;
}
- (NSString *)constructPath:(NSString *)path{
    NSString * newPath = [NSString stringWithFormat:@"%@%@",APIBaseURLString,path];
    return newPath;
}
- (NSDictionary *)constructParameters:(NSDictionary *)params{
    //统一做一些操作，加密
    NSMutableDictionary* newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    return newParams;
}
#pragma mark 判断是否有网
- (BOOL)isHaveNetwork{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus==0) {
        return NO;
    }
    return YES;
}

- (nullable NSURLSessionDataTask *)requestGetPath:(NSString *)path
                                       parameters:(id)parameters
                                          success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    NSURLSessionDataTask * operation = [[NSURLSessionDataTask alloc] init];
    NSString * newPath = [self constructPath:path];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //[manager setSecurityPolicy:[self getCustomHttpsPolicy:manager]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:newPath
      parameters:parameters
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             id newData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 success(operation,newData);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             failure(operation,error);
             
             
         }];
    return operation;
}



- (NSURLSessionDataTask *)requestGetPath:(NSString *)path
                                          success:(nullable void (^)(NSURLSessionDataTask *task, id  responseObject))success
                                          failure:(nullable void (^)(NSURLSessionDataTask *  task, NSError *error))failure{
    NSURLSessionDataTask * operation = [[NSURLSessionDataTask alloc] init];
    NSString * newPath = [self constructPath:path];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:newPath parameters:@""success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id newData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([newData[@"status"] integerValue]==200) {
            success(operation,newData);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(operation,error);

    }];
    return operation;
}



- (nullable NSURLSessionDataTask *)requestPostPath:(NSString *)path
                                        parameters:(nullable id)parameters
                                           success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                           failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    NSURLSessionDataTask * operation = [[NSURLSessionDataTask alloc] init];
    NSString * newPath = [self constructPath:path];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:newPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id newData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(operation,newData);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(operation,error);
    }];
    return operation;
}


@end
