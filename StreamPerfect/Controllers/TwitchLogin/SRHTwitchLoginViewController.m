//
//  SRHTwitchLoginViewController.m
//  StreamPerfect
//
//  Created by Francois Courville on 2014-08-03.
//  Copyright (c) 2014 Swift Synergy. All rights reserved.
//

#import "SRHTwitchLoginViewController.h"

#import <CocoaPods-Keys/StreamPerfectKeys.h>
#import <Masonry/Masonry.h>

@interface SRHTwitchLoginViewController () <UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *loginWebView;
@property(nonatomic, assign) BOOL didLogin;
@property(nonatomic, strong) SRHTwitchLoginComplete completion;

@end

@implementation SRHTwitchLoginViewController

-(id)initWithCompletion:(SRHTwitchLoginComplete)completion {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _completion = completion;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Login";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(handleModalClose:)];
    
    self.loginWebView = [[UIWebView alloc] init];
    self.loginWebView.delegate = self;
    [self.view addSubview:self.loginWebView];
    
    [self setupConstraints];
}

- (void)setupConstraints {
    [self.loginWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.loginWebView.superview);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Show log in page!
    NSString *logInURL = [NSString stringWithFormat:@"https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=%@&redirect_uri=%@&scope=user_follows_edit", [[[StreamPerfectKeys alloc] init] twitchClientID], @"http://www.frankacy.com"];
    
    [self.loginWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:logInURL]]];
}

- (void)handleModalClose:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@", request.URL);
    
    if ([[request.URL absoluteString] rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *fragment = [request.URL fragment];
        NSArray *fragmentStrings = [fragment componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"=&"]];
        NSLog(@"%@", fragmentStrings[1]);
        self.didLogin = YES;
        
        if (self.completion) {
            self.completion(fragmentStrings[1], nil);
        }
    }
    
    if (self.didLogin && [[request.URL absoluteString] rangeOfString:@"www.frankacy.com"].location != NSNotFound) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}


@end
