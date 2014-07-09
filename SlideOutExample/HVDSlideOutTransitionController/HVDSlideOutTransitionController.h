//
//  HVDSlideOutTransitionController.h
//
//  Created by Harshad on 09/07/14.
//

#import <Foundation/Foundation.h>

/*!
 * Defines supported directions in which the movable view can slide out
 */
typedef NS_ENUM(NSInteger, HVDSlideOutTransitionControllerDirection) {
    HVDSlideOutTransitionControllerDirectionLeft = 0,
    HVDSlideOutTransitionControllerDirectionRight
};

@protocol HVDSlideOutTransitionControllerDelegate;

/*!
 * This class allows you to add a slide out transition between two views
 */
@interface HVDSlideOutTransitionController : NSObject

/*!
 * Initialises the receiver with a direction and delegate
 */
- (instancetype)initWithDirection:(HVDSlideOutTransitionControllerDirection)direction delegate:(id <HVDSlideOutTransitionControllerDelegate>)delegate;

/*!
 * Resets the views to their initial positions. You should typically call this once after you are in a position to handle the delegate callbacks of the receiver.
 *
 * @param animated If the transition should be animated
 */
- (void)resetAnimated:(BOOL)animated;

/*!
 * Performs the slide out
 *
 * @param animated If the transition should be animated
 */
- (void)slideOutAnimated:(BOOL)animated;

/*!
 * The direction in which the movable view slides out
 */
@property (nonatomic, readonly) HVDSlideOutTransitionControllerDirection direction;

/*!
 * The delegate of the receiver
 */
@property (weak, nonatomic) id <HVDSlideOutTransitionControllerDelegate> delegate;

@end

/*!
 * This protocol declares methods which the delegate must implement to supply necessary information to perform the transitions
 */
@protocol HVDSlideOutTransitionControllerDelegate <NSObject>

@required

/*!
 * The delegate must return the view that does not move here
 */
- (UIView *)fixedViewForTransitionController:(HVDSlideOutTransitionController *)transitionController;

/*!
 * The delegate must return the view that slides out here
 */
- (UIView *)movableViewForTransitionController:(HVDSlideOutTransitionController *)transitionController;

/*!
 * The delegate must return the desired width of the fixed view here
 */
- (CGFloat)widthOfFixedViewForTransitionController:(HVDSlideOutTransitionController *)transitionController;

@end
