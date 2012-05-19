//
//  SVGKit.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#include "TargetConditionals.h"

#if TARGET_OS_IPHONE
	#import "SVGCircleElement.h"
	#import "SVGDefsElement.h"
	#import "SVGDescriptionElement.h"
	#import "SVGImage.h"
	#import "SVGImage+CA.h"
	#import "SVGElement.h"
	#import "SVGEllipseElement.h"
	#import "SVGGroupElement.h"
    #import "SVGImageElement.h"
	#import "SVGLineElement.h"
	#import "SVGPathElement.h"
	#import "SVGPolygonElement.h"
	#import "SVGPolylineElement.h"
	#import "SVGRectElement.h"
	#import "SVGShapeElement.h"
#import "SVGSource.h"
	#import "SVGTitleElement.h"
	#import "SVGUtils.h"
	#import "SVGView.h"
    #import "SVGPathView.h"
    #import "SVGPattern.h"
#else
	#import "SVGCircleElement.h"
	#import "SVGDefsElement.h"
	#import "SVGDescriptionElement.h"
	#import "SVGSource.h"
	//#import "SVGSource+CA.h"
	#import "SVGElement.h"
	#import "SVGEllipseElement.h"
	#import "SVGGroupElement.h"
    #import "SVGImageElement.h"
	#import "SVGLineElement.h"
	#import "SVGPathElement.h"
	#import "SVGPolygonElement.h"
	#import "SVGPolylineElement.h"
	#import "SVGRectElement.h"
	#import "SVGShapeElement.h"
	#import "SVGTitleElement.h"
	#import "SVGUtils.h"
	#import "SVGView.h"
#endif
