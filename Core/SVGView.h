//
//  SVGView.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVGImage;

@interface SVGView : UIView { }

@property (nonatomic, retain) SVGImage *image;

- (id)initWithImage:(SVGImage *)image; // set frame to position

@end
