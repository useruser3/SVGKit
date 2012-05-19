//
//  SVGView.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
@class SVGImage;

@interface SVGView : UIView { }

#else
@class SVGImage;

@interface SVGView : NSView { }
#endif



@property (nonatomic, retain) SVGImage *image;

- (id)initWithImage:(SVGImage *)image; // set frame to position

@end
