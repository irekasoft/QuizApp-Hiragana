//
//  IRButton.h
//  IRButton
//
//  Created by Muhammad Hijazi on 11/02/03.
//  Copyright 2011 hijazi.org. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IRButton : UIButton {

	UIColor *normalColor;
	UIColor *highlightedColor;
	
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
	
	float	radius;
    
    NSString *customText;
	
}

@property (nonatomic, retain) NSString *customText;

@property (nonatomic, retain) 	UIColor *normalColor; 
@property (nonatomic, retain) 	UIColor *highlightedColor;
@property  CGFloat hue;
@property  CGFloat saturation;
@property  CGFloat brightness;

@end
