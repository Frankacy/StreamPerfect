//
//  SRHRacesSplitViewController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-06-24.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRacesSplitViewController.h"
#import "SRHRaceStreamsViewModel.h"
#import "SRHRacesViewModel.h"
#import "SRHRace.h"
#import "SRHRacesTableViewController.h"
#import "SRHRaceStreamsCollectionController.h"
#import "UIColor+SRHColors.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <Masonry/Masonry.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

@interface SRHRacesSplitViewController ()

@property(nonatomic, strong) SRHRacesTableViewController *master;
@property(nonatomic, strong) SRHRaceStreamsCollectionController *detail;
@property(nonatomic, strong) UIView *separatorView;

@end

@implementation SRHRacesSplitViewController

-(id)initWithViewModel:(SRHRacesViewModel *)viewModel {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _master = [[SRHRacesTableViewController alloc] initWithViewModel:viewModel];
    _detail = [[SRHRaceStreamsCollectionController alloc] initWithViewModel:nil];
    _separatorView = [[UIView alloc] init];
    
    @weakify(self)
    [RACObserve(viewModel, selectedRace) subscribeNext:^(SRHRace *race) {
        @strongify(self)
        self.detail.viewModel = [[SRHRaceStreamsViewModel alloc] initWithRace:race];
        
        NSLog(@"Selected race: %@", race.goal);
    }];
    
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *masterWidth = @320;
    self.navigationItem.title = @"Races";
    
    [self addChildViewController:self.master];
    [self.view addSubview:self.master.tableView];
    [self.master didMoveToParentViewController:self];
    
    [self addChildViewController:self.detail];
    [self.view addSubview:self.detail.view];
    [self.detail didMoveToParentViewController:self];
    
    self.view.backgroundColor = [UIColor srhLightGrayColor];
    self.separatorView.backgroundColor = [UIColor srhTableSeparatorColor];
    [self.view addSubview:self.separatorView];
    
    [self.master.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.bottom.equalTo(self.view);
        make.width.equalTo(masterWidth);
    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.separatorView.superview);
        make.width.equalTo(@1);
        make.left.equalTo(self.master.view.mas_right);
        make.right.equalTo(self.detail.view.mas_left);
    }];
    
    [self.detail.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.and.right.equalTo(self.view);
        make.left.equalTo(self.separatorView.mas_right);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Races"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

@end
