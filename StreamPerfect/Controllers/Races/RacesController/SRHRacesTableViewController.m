//
//  SRHRacesTableViewController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-05-08.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHRacesTableViewController.h"
#import "SRHRacesViewModel.h"
#import "SRHRaceCell.h"
#import "UIColor+SRHColors.h"
#import "SRHRacesTableHeaderView.h"
#import "SRHAttributionFooterView.h"

#import "SRHRace.h"
#import "SRHGame.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>

NSString* const SRHRaceCellReuseIdentifier = @"SRHRaceCell";
NSString* const SRHRacesHeaderReuseIdentifier = @"SRHRacesHeader";

@interface SRHRacesTableViewController ()

@property(nonatomic, strong) SRHRacesViewModel *viewModel;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation SRHRacesTableViewController

-(id)initWithViewModel:(SRHRacesViewModel *)viewModel {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _viewModel = viewModel;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.separatorColor = [UIColor srhTableSeparatorColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor srhLightGrayColor];
    self.tableView.tableFooterView = [[SRHAttributionFooterView alloc] initWithTitle:@"Powered by SpeedRunsLive\nwww.speedrunslive.com"];
    
    [self.tableView registerClass:[SRHRaceCell class] forCellReuseIdentifier:SRHRaceCellReuseIdentifier];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor srhPurpleColor];
    refreshControl.rac_command = self.viewModel.updateContentCommand;
    [self.tableView addSubview:refreshControl];
    
    @weakify(self);
    [RACObserve(self.viewModel, sectionViewModels) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
        if ([self.viewModel numberOfSections] > 0 && [self.viewModel numberOfRowsInSection:0] >= 1) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            self.viewModel.selectedRace = [self.viewModel itemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SRHRaceCell *cell = [tableView dequeueReusableCellWithIdentifier:SRHRaceCellReuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row + 1 == [self.viewModel numberOfRowsInSection:indexPath.section]) {
        cell.separatorInset = UIEdgeInsetsMake(1, 0, 0, 0);
    } else {
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    cell.race = [self.viewModel itemAtIndexPath:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[SRHRacesTableHeaderView alloc] initWithTitle:[self.viewModel titleForHeaderInSection:section]
                                                     icon:[self.viewModel iconForHeaderInSection:section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.viewModel.selectedRace = [self.viewModel itemAtIndexPath:indexPath];
    
    [self sendAnalytics];
}

- (void)sendAnalytics {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Races"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"Select Race"
                                                           label:self.viewModel.selectedRace.game.name
                                                           value:nil] build]];
}

@end
