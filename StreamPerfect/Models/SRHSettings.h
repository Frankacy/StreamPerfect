//
//  SRHSettings.h
//  StreamPerfect
//
//  Created by Francois Courville on 2014-07-27.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SRHStreamSortType) {
    SRHStreamSortTypeFollowers,
    SRHStreamSortTypeViewerCount
};

@interface SRHSettings : NSObject

@property(nonatomic, assign) BOOL showNoSRLStreams;
@property(nonatomic, assign) SRHStreamSortType sortType;
@property(nonatomic, assign) BOOL showCompletedRaces;

@end
