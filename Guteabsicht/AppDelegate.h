//
//  AppDelegate.h
//  Guteabsicht
//
//  Created by Andrey Manov on 03/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NetworkLayer;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) NetworkLayer* networkLayer;

@end

