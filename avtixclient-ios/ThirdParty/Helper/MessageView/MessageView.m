//
//  MessageView.m
//  OY
//
//  Created by Apple on 12/10/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

//
#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>

#define kFontName @"Helvetica Neue"
#define kFontSize 13
#define kAnimationDuration 1


@implementation MessageView


+ (void) showInView: (UIView *) view withMessage: (NSString *) message
{
    CGRect screen =[[UIScreen mainScreen]bounds];
    NSUInteger length = [message length]+2;
    CGFloat width = length * kFontSize;
    CGFloat maxWidth = screen.size.width * 0.75;
    CGFloat height;
    
    if (width > maxWidth)
    {
        height = ((width/maxWidth) * kFontSize) + kFontSize;
        width = maxWidth;
    }
    else 
    {
        height = kFontSize * 3;
    }
    
    MessageView *HUD = [[MessageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    HUD.text = [NSString stringWithFormat:@" %@ ", message];
    HUD.backgroundColor = [UIColor colorWithRed:69/255.f green:190/255.f blue:189/255.f alpha:1.0];
    HUD.layer.cornerRadius = 5;
    HUD.layer.masksToBounds = YES;
    HUD.textColor = [UIColor whiteColor];
    HUD.font = [UIFont fontWithName:kFontName size:kFontSize];
    HUD.textAlignment = NSTextAlignmentCenter;
    HUD.numberOfLines = 0;
    HUD.center = view.window.center;
    HUD.frame = CGRectMake(HUD.frame.origin.x,
                           HUD.frame.origin.y - (view.window.frame.size.height/4),
                           HUD.frame.size.width,
                           HUD.frame.size.height);
    
    [view.window addSubview: HUD];
    [NSTimer scheduledTimerWithTimeInterval:kAnimationDuration
                                     target:self
                                   selector:@selector(startAnimation:)
                                   userInfo:HUD
                                    repeats:NO];
}

+ (void) showInView1: (UIView *) view withMessage: (NSString *) message
{
    CGRect screen =[[UIScreen mainScreen]bounds];
    NSUInteger length = [message length]+2;
    CGFloat width = length * kFontSize;
    CGFloat maxWidth = screen.size.width * 0.75;
    CGFloat height;
    
    if (width > maxWidth)
    {
        height = ((width/maxWidth) * kFontSize) + kFontSize;
        width = maxWidth;
    }
    else
    {
        height = kFontSize * 3;
    }
    
    MessageView *HUD = [[MessageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    HUD.text = [NSString stringWithFormat:@" %@ ", message];
    HUD.backgroundColor = [UIColor colorWithRed:69/255.f green:190/255.f blue:189/255.f alpha:1.0];
    HUD.layer.cornerRadius = 5;
    HUD.layer.masksToBounds = YES;
    HUD.textColor = [UIColor whiteColor];
    HUD.font = [UIFont fontWithName:kFontName size:kFontSize];
    HUD.textAlignment = NSTextAlignmentCenter;
    HUD.numberOfLines = 0;
    HUD.center = view.window.center;
    HUD.frame = CGRectMake(HUD.frame.origin.x,
                           HUD.frame.origin.y - (view.window.frame.size.height/4),
                           HUD.frame.size.width,
                           HUD.frame.size.height);
    
    [view.window addSubview: HUD];
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(startAnimation:)
                                   userInfo:HUD
                                    repeats:NO];
}



+ (void) startAnimation: (NSTimer *) timer
{
    MessageView *HUD = (MessageView *)[timer userInfo];
    [UIView beginAnimations:nil context:(__bridge void *)(HUD)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:kAnimationDuration];
    HUD.alpha = 0.0;
    [UIView commitAnimations];
    
}

+ (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([finished intValue]==1) {
    
    @try {
        MessageView *HUD = (__bridge MessageView *)context;
        [HUD removeFromSuperview];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
        
    }
}

-(void)closePressed:(id)sender{
     MessageView *HUD = (MessageView *)[sender superview];
    [HUD removeFromSuperview];
}


@end
