//
//  ViewController.m
//  01NetWork
//
//  Created by fenglin on 2017/2/17.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "ViewController.h"

#define kImageURL @"https://www.baidu.com/"
@interface ViewController ()<NSURLSessionDelegate>

@property(nonatomic,strong) NSURLSession *session;
@end
@implementation ViewController



/**
  [NSURLSession sharedSession] 获取全局的NSURLSession对象。在iPhone的所有app共用一个全局session.   
    NSURLSessionUploadTask -> NSURLSessionDataTask -> NSURLSessionTask   
    NSURLSessionDownloadTask -> NSURLSessionTask    
    NSURLSessionDownloadTask下载，默认下载到tmp文件夹。下载完成后删除临时文件。所以我们要在删除文件之前，将它移动到Cache里。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kImageURL]];
    
    
    NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",response);
    }];
    
    [task resume];
    
}


/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    NSLog(@"%@",error);
}

/* If implemented, when a connection level authentication challenge
 * has occurred, this delegate will be given the opportunity to
 * provide authentication credentials to the underlying
 * connection. Some types of authentication will apply to more than
 * one request on a given connection to a server (SSL Server Trust
 * challenges).  If this delegate message is not implemented, the
 * behavior will be to use the default handling, which may involve user
 * interaction.
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    NSLog(@"%@",challenge.protectionSpace.host);
    NSURLCredential *urlCre = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,urlCre);
}

/* If an application has received an
 * -application:handleEventsForBackgroundURLSession:completionHandler:
 * message, the session delegate will receive this message to indicate
 * that all messages previously enqueued for this session have been
 * delivered.  At this time it is safe to invoke the previously stored
 * completion handler, or to begin any internal updates that will
 * result in invoking the completion handler.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session NS_AVAILABLE_IOS(7_0){
    NSLog(@"%s",__FILE__);
}
@end
