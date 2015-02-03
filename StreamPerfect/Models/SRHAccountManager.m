//
//  SRHAccountManager.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHAccountManager.h"
#import "SRHTwitchUser.h"
#import "SRHTwitchLoginViewController.h"

@class SRHTwitchUser;

@implementation SRHAccountManager

static SRHAccountManager *sharedManager = nil;

+ (SRHAccountManager *)sharedManager {
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        sharedManager = [[SRHAccountManager alloc] init];
    });
    return sharedManager;
}

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self tryLoadUser];
    
    return self;
}

- (BOOL)tryLoadUser {
    [self loadAccountInfosFromUserDefaults:nil failure:nil];
    
    return false;
}

- (RACSignal *)getTokenFromViewController:(UIViewController *)viewController{
    RACSignal *loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self logInUserFromViewController:viewController completion:^(NSString *token, NSError *error) {
            if (!error) {
                [subscriber sendNext:token];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:error];
            }
        }];
        
        return nil;
    }];
    
    return loginSignal;
}

- (void)logInUserFromViewController:(UIViewController *)vc completion:(void (^)(NSString *token, NSError *error))completion {
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    UIViewController *twitchLogin = [[SRHTwitchLoginViewController alloc] initWithCompletion:^(NSString *token, NSError *error){
        if (completion) {
            if (!error) {
                completion(token, nil);
            } else {
                completion(nil, error);
            }
        }
    }];
    UIViewController *navController = [[UINavigationController alloc] initWithRootViewController:twitchLogin];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [vc presentViewController:navController animated:YES completion:nil];
}

- (void)logOut {
    self.currentUser = nil;
    [self deleteAccountInfoFromUserDefaults];
}

- (void)saveAccountInfosInUserDefaults:(SRHTwitchUser *)userInfos {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:userInfos];
    [prefs setObject:encodedObject forKey:@"SRHTwitchUser"];
    [prefs synchronize];
}

- (void)loadAccountInfosFromUserDefaults:(void (^)(SRHTwitchUser *user))success failure:(void (^) (NSString *errorMessage))failure
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *userData = [userDefaults objectForKey:@"SRHTwitchUser"];
    
    if(userData)
    {
        // can't really rely on data stored on the phone by previous version so put a try catch here...
        @try {
            self.currentUser = (SRHTwitchUser *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
            if (success) {
                success(self.currentUser);
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Error loading user infos from defaults.");
        }
    }
    else {
        if (failure) {
            failure(@"Unable to retrieve user infos from local copy");
        }
    }
}

- (void)deleteAccountInfoFromUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"SRHTwitchUser"];
}

@end
