//
//  SRHStreamDetailsViewModel.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "RVMViewModel.h"

@class SRHStream;

@interface SRHStreamDetailsViewModel : RVMViewModel

@property(nonatomic, copy) NSAttributedString *mainTitle;
@property(nonatomic, copy) NSString *streamTitle;
@property(nonatomic, assign, getter = isFollowing) BOOL following;
@property(nonatomic, copy) NSString *viewersNumberText;
@property(nonatomic, copy) NSString *viewersTitleText;
@property(nonatomic, copy) NSString *followersNumberText;
@property(nonatomic, copy) NSString *followersTitleText;
@property(nonatomic, copy) NSURL *avatarURL;
@property(nonatomic, assign) BOOL shouldKillStream;

@property(nonatomic, strong) NSString *twitchScreenName;

@property(nonatomic, strong) RACCommand *followCommand;

-(instancetype)initWithStream:(SRHStream *)stream;

@end
