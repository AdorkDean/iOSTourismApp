//
//  GCAPIClient.h
//  TourismApp
//
//  Created by 管理员 on 2017/11/15.
//  Copyright © 2017年 dragon. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface GCAPIClient : AFHTTPSessionManager

 /*  初始化网络请求的单利
 *
 *  @return 返回一个实例化的对象
 */
+(instancetype _Nullable )shareClient;
- (NSURLSessionDataTask *)requestGetPath:(NSString *)path
                                 success:(nullable void (^)(NSURLSessionDataTask *task, id  responseObject))success
                                 failure:(nullable void (^)(NSURLSessionDataTask *  task, NSError *error))failure;

/**
 *  GET请求
 *
 *  @param path    路径（默认已传好基路径，不需要再传入）
 *  @param parameters  参数
 *  @param success 网络请求成功的回调函数
 *  @param failure 网络请求失败的回调函数
 *
 *  @return http请求
 */
- (nullable NSURLSessionDataTask *)requestGetPath:(NSString *_Nullable)path
                                       parameters:(id)parameters
                                          success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

/**
 *  GET请求(参数加密)
 *
 *  @param path    路径（默认已传好基路径，不需要再传入）
 *  @param parameters  参数
 *  @param success 网络请求成功的回调函数
 *  @param failure 网络请求失败的回调函数
 *
 *  @return http请求
 */
- (nullable NSURLSessionDataTask *)requestGetPathWithSign:(NSString *_Nullable)path
                                               parameters:(nullable id)parameters
                                                  success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                                  failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;
/**
 *  GET请求（带缓存的，写入文件）
 *
 *  @param path         路径（默认已传入基地址，不需要再传入）
 *  @param parameters       参数
 *  @param success 数据请求成功的回调函数
 *  @param failure 数据请求失败的回调函数
 *
 *  @return http请求
 */

- (nullable NSURLSessionDataTask *)requestGetWithCachePath:(NSString *_Nullable)path
                                                parameters:(nullable id)parameters
                                                   success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;
/**
 *  POST请求（不带formData的）
 *
 *  @param path    路径（默认已传好基路径，不需要再传入）
 *  @param parameters  参数
 *  @param success 网络请求成功的回调函数
 *  @param failure 网络请求失败的回调函数
 *
 *  @return http请求
 */


- (nullable NSURLSessionDataTask *)requestPostPath:(NSString *_Nullable)path
                                        parameters:(nullable id)parameters
                                           success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                           failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

- (nullable NSURLSessionDataTask *)requestPostPathWithSign:(NSString *_Nullable)path
                                                parameters:(nullable id)parameters
                                                   success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                                   failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;


/**
 *  POST请求（带formData参数的）
 *
 *  @param path    路径（默认已传好基路径，不需要再传入）
 *  @param parameters  参数
 *  @param block   formData设置的回调函数
 *  @param success 网络请求成功的回调函数
 *  @param failure 网络请求失败的回调函数
 *
 *  @return http请求
 */


- (nullable NSURLSessionDataTask *)requestPostDataPath:(NSString *_Nullable)path
                                            parameters:(nullable id)parameters
                             constructingBodyWithBlock:(void (^_Nullable)(id<AFMultipartFormData> _Nonnull))block
                                               success:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject))success
                                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error))failure;

@end
