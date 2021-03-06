//
//  QSItem.m
//  MyStoryBook
//
//  Created by Muhammad Hijazi  on 29/9/13.
//  Copyright (c) 2013 iReka Soft. All rights reserved.
//

#import "QSItem.h"


@implementation QSItem



// Delete initWithFrame and add the following:
-(id) initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.opaque = NO;
		self.normalColor = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor];
		_hue = 0.2;
        _saturation = 0.2;
        _brightness = 0.3;
		if (!self.highlightedColor) {
			self.highlightedColor = [UIColor blackColor];
			self.highlightedColor = self.titleLabel.shadowColor;
            
		}
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // if given a specific label override it
    // if not, just use from IB
    UILabel *aLabel;
    
    //    if (aLabel == nil) {
    aLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, 80, 20)];
    aLabel.text = self.customText;
    
    aLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:aLabel];
    
    //    }
    
	//NSLog(@"aa%@",[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0].CGColor);
	//NSLog(@"aa%@", self.normalColor);
	self.radius = 4.0;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	//CGColorRef normalColorRef = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0].CGColor;
	CGColorRef normalColorRef = self.normalColor.CGColor;
	CGColorRef highlightedColorRef = self.highlightedColor.CGColor;
    
    
    
    CGFloat outerMargin = 0.f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
    CGMutablePathRef outerPath = createRoundedRectForRectA(outerRect, self.radius);
	
	if (self.state != UIControlStateHighlighted) {
		CGContextSaveGState(context);
		CGContextSetFillColorWithColor(context, normalColorRef);
		CGContextAddPath(context, outerPath);
		CGContextFillPath(context);
		CGContextRestoreGState(context);
		
	}else {
		
		CGContextSaveGState(context);
		CGContextSetFillColorWithColor(context, highlightedColorRef);
		CGContextAddPath(context, outerPath);
		CGContextFillPath(context);
		CGContextRestoreGState(context);
		
	}
    
}

CGMutablePathRef createRoundedRectForRectA(CGRect rect, CGFloat radius) {
	
    CGMutablePathRef path = CGPathCreateMutable();
	
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect),
						CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect),
						CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect),
						CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect),
						CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
	
    return path;
}
#pragma mark - c


// Add the following methods to the bottom
- (void)hesitateUpdate
{
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

@end
