//
//  SRHStreamDetailsViewController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHStreamDetailsViewController.h"
#import "SRHStreamDetailsViewModel.h"
#import "SRHStreamDetailsHeader.h"
#import "SRHStreamDetailsWebViewController.h"
#import "SRHStyleFactory.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>

@interface SRHStreamDetailsViewController ()

@property(nonatomic, weak) SRHStream *stream;

@property(nonatomic, strong) SRHStreamDetailsHeader *header;
@property(nonatomic, strong) SRHStreamDetailsWebViewController *webView;

@end

@implementation SRHStreamDetailsViewController

- (instancetype)initWithStream:(SRHStream *)stream {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _stream = stream;
    
    self.navigationController.edgesForExtendedLayout = UIRectEdgeTop;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sp_logo"]];
    
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] init];
    
    SRHStreamDetailsHeader *header = [[SRHStreamDetailsHeader alloc] initWithStream:self.stream];
    [self.view addSubview:header];
    self.header = header;
    
    SRHStreamDetailsWebViewController *webView = [[SRHStreamDetailsWebViewController alloc] initWithStream:self.stream];
    [self.view addSubview:webView.view];
    self.webView = webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.view);
        make.height.equalTo(@125);
    }];
    
    [self.webView.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_bottom);
        make.left.bottom.and.right.equalTo(self.view);
    }];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        [self.webView killStream];
    }
    
    [super viewWillDisappear:animated];
}

@end