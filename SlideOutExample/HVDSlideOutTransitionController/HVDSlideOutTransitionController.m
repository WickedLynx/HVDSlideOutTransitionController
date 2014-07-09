//
//  HVDSlideOutTransitionController.m
//
//  Created by Harshad on 09/07/14.
//

#import "HVDSlideOutTransitionController.h"

@implementation HVDSlideOutTransitionController {
    __weak UIPanGestureRecognizer *_panGestureRecognizer;
    CGPoint _previousPanPoint;
}

// MARK: Initialisation

- (instancetype)initWithDirection:(HVDSlideOutTransitionControllerDirection)direction delegate:(id <HVDSlideOutTransitionControllerDelegate>)delegate {
    self = [super init];
    if (self != nil) {
        _direction = direction;
        _delegate = delegate;
    }

    return self;
}

// MARK: Public methods

- (void)resetAnimated:(BOOL)animated {

    UIView *fixedView = [self.delegate fixedViewForTransitionController:self];
    UIView *movableView = [self.delegate movableViewForTransitionController:self];

    if (_panGestureRecognizer == nil) {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [movableView addGestureRecognizer:panGestureRecognizer];
        _panGestureRecognizer = panGestureRecognizer;
    }

    void (^animations)(void) = ^{
        [fixedView setFrame:[self fixedViewFrame]];
        [movableView setFrame:[self initialFrameForMovableView]];
    };

    if (animated) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:animations completion:nil];
    } else {
        animations();
    }
}

- (void)slideOutAnimated:(BOOL)animated {
    UIView *movableView = [self.delegate movableViewForTransitionController:self];
    CGRect targetFrame = [self targetFrameForMovableView];

    void (^animations)(void) = ^{
        [movableView setFrame:targetFrame];
    };

    if (animated) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:animations completion:nil];
    } else {
        animations();
    }
}

// MARK: Private methods

- (CGRect)fixedViewFrame {
    UIView *fixedView = [self.delegate fixedViewForTransitionController:self];
    CGRect initialFrame = fixedView.superview.bounds;
    CGFloat fixedViewWidth = [self.delegate widthOfFixedViewForTransitionController:self];

    switch (self.direction) {
        case HVDSlideOutTransitionControllerDirectionLeft:
            initialFrame.origin.x = initialFrame.size.width - fixedViewWidth;
            break;

        default:
            break;
    }

    initialFrame.size.width = fixedViewWidth;

    return initialFrame;
}

- (CGRect)initialFrameForMovableView {
    UIView *movableView = [self.delegate movableViewForTransitionController:self];
    return movableView.superview.bounds;
}

- (CGRect)targetFrameForMovableView {
    UIView *movableView = [self.delegate movableViewForTransitionController:self];
    CGRect targetFrame = movableView.bounds;
    CGFloat fixedViewWidth = [self.delegate widthOfFixedViewForTransitionController:self];
    switch (self.direction) {
        case HVDSlideOutTransitionControllerDirectionLeft:
            targetFrame.origin.x -= fixedViewWidth;
            break;

        case HVDSlideOutTransitionControllerDirectionRight:
            targetFrame.origin.x += fixedViewWidth;
            break;

        default:
            break;
    }

    return targetFrame;
}

// MARK: Transitions

- (BOOL)shouldSlideOutForCurrentFrame:(CGRect)frame {
    BOOL slideOut = NO;

    switch (self.direction) {
        case HVDSlideOutTransitionControllerDirectionLeft:
            if ((frame.origin.x + frame.size.width) <= CGRectGetMidX([self fixedViewFrame])) {
                slideOut = YES;
            }
            break;

        case HVDSlideOutTransitionControllerDirectionRight:
            if (frame.origin.x >= CGRectGetMidX([self fixedViewFrame])) {
                slideOut = YES;
            }
            break;

        default:
            break;
    }

    return slideOut;
}

- (BOOL)shouldMoveViewToFrame:(CGRect)toFrame {
    BOOL shouldMove = NO;
    CGRect fixedFrame = [self fixedViewFrame];
    switch (self.direction) {
        case HVDSlideOutTransitionControllerDirectionLeft:
            if (toFrame.origin.x <= 0 && toFrame.origin.x >= -fixedFrame.size.width) {
                shouldMove = YES;
            }
            break;

        case HVDSlideOutTransitionControllerDirectionRight:
            if (toFrame.origin.x >= 0 && toFrame.origin.x <= fixedFrame.size.width) {
                shouldMove = YES;
            }
            break;

        default:
            break;
    }
    return shouldMove;
}

- (void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *movableView = [self.delegate movableViewForTransitionController:self];
    CGPoint panPoint = [panGestureRecognizer locationInView:movableView.superview];
    switch (panGestureRecognizer.state) {

        case UIGestureRecognizerStateChanged: {

            CGFloat deltaX = panPoint.x - _previousPanPoint.x;
            CGRect targetFrame = movableView.frame;
            targetFrame.origin.x += deltaX;
            if ([self shouldMoveViewToFrame:targetFrame]) {
                [movableView setFrame:targetFrame];
            }

            break;
        }

        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            if ([self shouldSlideOutForCurrentFrame:movableView.frame]) {
                [self slideOutAnimated:YES];
            } else {
                [self resetAnimated:YES];
            }

            break;
        }
        default:
            break;
    }

    _previousPanPoint = panPoint;
}

@end
