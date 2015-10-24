//
//  UIImage+UIImage_Glow.m
//  CandySwift
//
//  Created by Max on 25/07/14.
//  Copyright (c) 2014 MaxHype. All rights reserved.
//

#import "UIImage+Glow.h"

@implementation UIImage (Glow)

- (UIImage *) makeGlowWithColor: (UIColor *)color
{
	UIImage * image;
	
	UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
	{
		[self drawAtPoint:CGPointZero];
		
		UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.size.width, self.size.height)];
		
		[color setFill];
		
		[path fillWithBlendMode:kCGBlendModeSourceAtop alpha:0.5];
		
		image = UIGraphicsGetImageFromCurrentImageContext();
		
	}
	UIGraphicsEndImageContext();	
	
	UIView* glowView = [[UIImageView alloc] initWithImage:image];
	
	glowView.layer.shadowColor = color.CGColor;
	glowView.layer.shadowOffset = CGSizeZero;
	glowView.layer.shadowRadius = 2;
	glowView.layer.shadowOpacity = 1.0;
	
	
	UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
	[glowView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return img;
}

@end
