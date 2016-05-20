//
//  ViewController.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 15.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMInternetConnectionRetryProtocol.h"

@interface OMViewController : UITableViewController <OMInternetConnectionRetryProtocol>

@end

