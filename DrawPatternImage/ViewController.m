//
//  ViewController.m
//  DrawPatternImage
//
//  Created by Mark Granoff on 9/25/12.
//  Copyright (c) 2012 Hawk iMedia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

CGContextRef CreateBitmapContext(int width, int height, CGColorSpaceRef colorSpace, CGImageAlphaInfo alpha)
{
    CGContextRef    context = NULL;
    int bitmapBytesPerRow   = (width * 4);
    
    context = CGBitmapContextCreate (NULL, //bitmapData
                                     width,
                                     height,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     alpha);
    
    return context;
}

-(UIImage *)patternImageWithSize:(CGSize)patternSize forRectSize:(CGSize)size
{
    // Upsize the pattern dimensions to fill as evenly as possible both horizontally and vertically
    size_t myWidth = patternSize.width;
    size_t myHeight = patternSize.height;
    // Comment out these two 'while' statements to just get a pattern of the specified size, but it may
    // show partial images along the right and bottom edge if used as a background "color"
    while ((size_t)size.width % myWidth > 1)
        myWidth++;
    
    while ((size_t)size.height % myHeight > 1)
        myHeight++;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef myBitmapContext = CreateBitmapContext(myWidth, myHeight, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    // Fill the square with black.
    CGContextSetRGBFillColor (myBitmapContext, 0, 0, 0, 1);
    CGContextFillRect (myBitmapContext, CGRectMake (0, 0, myWidth, myHeight ));
    
    // Fill an inner diamond with white
    CGContextSetRGBFillColor(myBitmapContext, 1, 1, 1, 1);
    CGContextBeginPath(myBitmapContext);
    CGContextMoveToPoint(myBitmapContext, myWidth/2.0, 2);
    CGContextAddLineToPoint(myBitmapContext, myWidth-2.0, myHeight/2.0);
    CGContextAddLineToPoint(myBitmapContext, myWidth/2.0, myHeight-2.0);
    CGContextAddLineToPoint(myBitmapContext, 2, myHeight/2.0);
    CGContextAddLineToPoint(myBitmapContext, myWidth/2.0, 2);
    CGContextClosePath(myBitmapContext);
    CGContextFillPath(myBitmapContext);
    
    // Create an image ref from the context
    CGImageRef imageRef = CGBitmapContextCreateImage (myBitmapContext);
    CGContextRelease (myBitmapContext);

    // Turn the image ref into a UIImage that can be used with UIColor's -colorWithPatternImage:
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return image;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImage *image = [self patternImageWithSize:CGSizeMake(16,16) forRectSize:self.view.frame.size];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
