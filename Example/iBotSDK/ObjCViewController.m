//
//  ObjCViewController.m
//  iBotSDK_Example
//
//  Created by enliple on 2019/12/10.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#import "ObjCViewController.h"

@interface ObjCViewController ()

@property (readwrite) BOOL isAdded;

@end

@implementation ObjCViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isAdded = false;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showIBotButton];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)showIBotButton {
    if (!_isAdded) {
        _isAdded = true;
        
        IBotChatButton *button = [[IBotSDK shared] showIBotButtonIn:[self view] apiKey:@"YOUR_API_KEY" playAnimation:YES callback:nil];
        
        button.openInModal = false;
        button.canDrag = true;
        
        button.buttonBackgroundColor = UIColor.whiteColor;
    }
    
}


@end
