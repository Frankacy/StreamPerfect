//
//  SRHAccountManager.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SRHTwitchUser;

@interface SRHAccountManager : NSObject

@property(nonatomic, strong) SRHTwitchUser *currentUser;
@property(nonatomic, assign, readonly, getter = isLoggedIn) BOOL loggedIn;

+ (SRHAccountManager *)sharedManager;

- (RACSignal *)getTokenFromViewController:(UIViewController *)viewController;
//- (void)logInUserWithCompletion:(void (^)(NSString *token, NSError *error))completion;
- (void)logOut;

@end
