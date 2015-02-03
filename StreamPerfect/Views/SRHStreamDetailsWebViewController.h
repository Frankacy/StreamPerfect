//
//  SRHStreamDetailsWebViewController.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-07-26.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRHStream;

@interface SRHStreamDetailsWebViewController : UIViewController

- (instancetype)initWithStream:(SRHStream *)stream;

- (void)killStream;
    
@end
