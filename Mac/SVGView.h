//
//  SVGView.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

@class SVGSource;

@interface SVGView : NSView { }

@property (nonatomic, retain) SVGSource *document;

- (id)initWithDocument:(SVGSource *)document; // set frame to position

@end
