//
//  HVDRootViewController.m
//  SlideOutExample
//
//  Created by Harshad on 09/07/14.
//  Copyright (c) 2014 Laughing Buddha Software. All rights reserved.
//

#import "HVDRootViewController.h"
#import "HVDSlideOutTransitionController.h"

@interface HVDRootViewController () <HVDSlideOutTransitionControllerDelegate> {
    UIViewController *_leftViewController;
    UIViewController *_rightViewController;

    HVDSlideOutTransitionController *_transitionController;
}

@end

@implementation HVDRootViewController

// MARK: View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIViewController * (^addChildController)(UIColor *) = ^UIViewController * (UIColor *backgroundColor) {
        UIViewController *viewController = [UIViewController new];
        [viewController.view setBackgroundColor:backgroundColor];
        [self.view addSubview:viewController.view];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];

        return viewController;
    };

    _rightViewController = addChildController([UIColor yellowColor]);
    _leftViewController = addChildController([UIColor redColor]);

    _transitionController = [[HVDSlideOutTransitionController alloc] initWithDirection:HVDSlideOutTransitionControllerDirectionLeft delegate:self];
    [_transitionController resetAnimated:NO];
}

// MARK: HVDSlideOutTransitionControllerDelegate methods

- (UIView *)fixedViewForTransitionController:(HVDSlideOutTransitionController *)transitionController {
    return _rightViewController.view;
}

- (UIView *)movableViewForTransitionController:(HVDSlideOutTransitionController *)transitionController {
    return _leftViewController.view;
}

- (CGFloat)widthOfFixedViewForTransitionController:(HVDSlideOutTransitionController *)transitionController {
    return 220.0F;
}


@end
