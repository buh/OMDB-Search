//
//  OMNavigationController.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "OMMacros.h"
#import "OMNavigationController.h"
#import "AFNetworkReachabilityManager.h"
#import "OMInternetConnectionRetryProtocol.h"

@interface OMNavigationController ()

@property (nonatomic) AFNetworkReachabilityManager *internetConnectionManager;
@property (nonatomic) UILabel *reachabilityStatusLabel;

@end

@implementation OMNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInternetConnection];
}

- (void)setupInternetConnection
{
    _reachabilityStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0., 64., [UIScreen mainScreen].bounds.size.width, 30.)];
    _reachabilityStatusLabel.textColor = [UIColor blackColor];
    _reachabilityStatusLabel.backgroundColor = [UIColor colorWithRed:0.95 green:0.9 blue:0. alpha:1.];
    _reachabilityStatusLabel.text = @"Internet Connection Unavailable";
    _reachabilityStatusLabel.textAlignment = NSTextAlignmentCenter;
    _reachabilityStatusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.5];
    _reachabilityStatusLabel.hidden = YES;
    [self.view addSubview:_reachabilityStatusLabel];
    
    // Setup Internet Connection Manager.
    _internetConnectionManager = [AFNetworkReachabilityManager managerForDomain:@"omdbapi.com"];
    [_internetConnectionManager startMonitoring];
    
    OMWeakSelf;
    [_internetConnectionManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        OMStrongSelf;
        [strongSelf checkInternetConnetionReachabilityAndShowAlert:NO];
    }];
}

- (BOOL)checkInternetConnetionReachabilityAndShowAlert:(BOOL)showAlert
{
    if ([_internetConnectionManager isReachable]) {
        _reachabilityStatusLabel.hidden = YES;
        
        return YES;
    }
    
    if (showAlert) {
        [self showInternetConnectionAlert];
    }
    
    _reachabilityStatusLabel.hidden = NO;
    
    return NO;
}

- (void)showInternetConnectionAlert
{
    UIAlertController *alertViewController =
    [UIAlertController alertControllerWithTitle:@"Internet Connection Unavailable"
                                        message:@"Please, check your Internet Connection and try again"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alertViewController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    
    if ([self.topViewController conformsToProtocol:@protocol(OMInternetConnectionRetryProtocol)]) {
        [alertViewController addAction:[UIAlertAction actionWithTitle:@"Try Again"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  [self retryIfNeeded];
                                                              }]];
    }
    
    [self presentViewController:alertViewController animated:YES completion:NULL];
}

- (void)retryIfNeeded
{
    if (self.viewControllers.count
        && [self.topViewController conformsToProtocol:@protocol(OMInternetConnectionRetryProtocol)]) {
        [((id <OMInternetConnectionRetryProtocol>)self.topViewController) badInternetConnectionRetryRequest];
    }
}

@end
