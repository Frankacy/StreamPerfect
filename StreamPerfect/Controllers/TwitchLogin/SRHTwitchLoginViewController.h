//
//  SRHTwitchLoginViewController.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRHTwitchUser;

typedef void(^SRHTwitchLoginComplete)(NSString *token, NSError *error);

@interface SRHTwitchLoginViewController : UIViewController

-(id)initWithCompletion:(SRHTwitchLoginComplete)completion;

@end
