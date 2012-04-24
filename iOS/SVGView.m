//
//  SVGView.m
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import "SVGView.h"

#import "SVGImage.h"
#import "SVGImage+CA.h"

@implementation SVGView

@synthesize image = _image;

- (id)initWithImage:(SVGImage *)document {
	NSParameterAssert(document != nil);
	
	self = [self initWithFrame:CGRectMake(0.0f, 0.0f, document.size.width, document.size.height)];
	if (self) {
		self.image = document;
	}
	return self;
}

- (void)dealloc {
	[_image release];
	
	[super dealloc];
}

- (void)setImage:(SVGImage *)aDocument {
	if (_image != aDocument) {
		[_image release];
		_image = [aDocument retain];

        for (NSInteger i = [self.layer.sublayers count] - 1; i >= 0; i--) {
            CALayer *sublayer = [self.layer.sublayers objectAtIndex:i];
            [sublayer removeFromSuperlayer];
        }

		[self.layer addSublayer:[_image layerTreeCached]];
	}
}

@end
