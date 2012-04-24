
#import "SVGImage.h"
#import <QuartzCore/QuartzCore.h>

@interface SVGImage (CA)

- (CALayer *)layerWithIdentifier:(NSString *)identifier;

- (CALayer *)layerTree;

- (CALayer *)layerWithIdentifier:(NSString *)identifier layer:(CALayer *)layer;

- (CALayer *)layerWithElement:(SVGElement < SVGLayeredElement > *)element;

/*! returns all the individual CALayer's in the full layer tree, indexed by the SVG identifier of the SVG node that created that layer */
- (NSDictionary*) dictionaryOfLayers;

@end
