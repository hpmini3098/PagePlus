//
//  ViewController.h
//  PagePlusSample
//
//  Created by Derek on 6/8/13.
//  Copyright (c) 2013 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagesView.h"
@interface ViewController : UIViewController<PagesDelegate>
@property(nonatomic, strong) Pages *pages;
@end
