//
//  CCAnimator.m
//  ChatClient
//
//  Created by Anthony on 24.07.16.
//  Copyright © 2016 Anthony. All rights reserved.
//

#import "CCAnimator.h"

@implementation CCAnimator

- (void)animatePresentationOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController {

    NSView *bottomViewController = fromViewController.view;
    NSView *topViewController = viewController.view;
    
    topViewController.frame = bottomViewController.frame;
    topViewController.translatesAutoresizingMaskIntoConstraints = false;

    [bottomViewController addSubview:topViewController];

    topViewController.wantsLayer = true;
    topViewController.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    
    topViewController.animator.alphaValue = 0;
    
    CGColorRef color = [NSColor controlColor].CGColor;
    topViewController.layer.backgroundColor = color;
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 0.0;
        topViewController.animator.alphaValue = 1;
    } completionHandler:nil];
    
    [bottomViewController addConstraint:[NSLayoutConstraint constraintWithItem:topViewController
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:bottomViewController
                                                                  attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [bottomViewController addConstraint:[NSLayoutConstraint constraintWithItem:topViewController
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:bottomViewController
                                                                  attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [bottomViewController addConstraint:[NSLayoutConstraint constraintWithItem:topViewController
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:bottomViewController
                                                                  attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [bottomViewController addConstraint:[NSLayoutConstraint constraintWithItem:topViewController
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:bottomViewController
                                                                  attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}


- (void)animateDismissalOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController {

    NSView *topViewController = viewController.view;
    
    topViewController.wantsLayer = true;
    topViewController.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 0.5;
        [topViewController.animator removeFromSuperview];
    } completionHandler:nil]; 
}

@end
