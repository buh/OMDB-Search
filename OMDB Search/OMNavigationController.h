//
//  OMNavigationController.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNavigationController : UINavigationController

- (BOOL)checkInternetConnetionReachabilityAndShowAlert:(BOOL)showAlert;

@end
