#import "SVGImage+CA.h"

#import <objc/runtime.h>

@implementation SVGImage (CA)

static const char *kLayerTreeKey = "svgkit.layertree";

- (CALayer *)layerWithIdentifier:(NSString *)identifier {
	return [self layerWithIdentifier:identifier layer:self.layerTree];
}

- (CALayer *)layerWithIdentifier:(NSString *)identifier layer:(CALayer *)layer {
	if ([layer.name isEqualToString:identifier]) {
		return layer;
	}
	
	for (CALayer *child in layer.sublayers) {
		CALayer *resultingLayer = [self layerWithIdentifier:identifier layer:child];
		
		if (resultingLayer)
			return resultingLayer;
	}
	
	return nil;
}

- (CALayer *)layerTree {
	CALayer *cachedLayerTree = objc_getAssociatedObject(self, (void *) kLayerTreeKey);
	
	if (!cachedLayerTree) {
		cachedLayerTree = [self layerWithElement:self.rootElement];
		objc_setAssociatedObject(self, (void *) kLayerTreeKey, cachedLayerTree, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return cachedLayerTree;
}

- (CALayer *)layerWithElement:(SVGElement <SVGLayeredElement> *)element {
	CALayer *layer = [element newLayer];
	
	if (![element.children count]) {
		return layer;
	}
	
	for (SVGElement *child in element.children) {
		if ([child conformsToProtocol:@protocol(SVGLayeredElement)]) {
			CALayer *sublayer = [self layerWithElement:(id<SVGLayeredElement>)child];

			if (!sublayer) {
				continue;
            }

			[layer addSublayer:sublayer];
		}
	}
	
	if (element != self.rootElement) {
		[element layoutLayer:layer];
	}

    [layer setNeedsDisplay];
	
	return layer;
}

- (void) addSVGLayerTree:(CALayer*) layer withIdentifier:(NSString*) layerID toDictionary:(NSMutableDictionary*) layersByID
{
	[layersByID setValue:layer forKey:layerID];
	
	if ( [layer.sublayers count] < 1 )
	{
		return;
	}
	
	for (CALayer *subLayer in layer.sublayers)
	{
		NSString* subLayerID = [subLayer valueForKey:kSVGElementIdentifier];
		
		if( subLayerID != nil )
		{
			NSLog(@"[%@] element id: %@ => layer: %@", [self class], subLayerID, subLayer);
			
			[self addSVGLayerTree:subLayer withIdentifier:subLayerID toDictionary:layersByID];
			
		}
	}
}

- (NSDictionary*) dictionaryOfLayers
{
	NSMutableDictionary* layersByElementId = [NSMutableDictionary dictionary];
	
	CALayer* rootLayer = [self layerTree];
	
	[self addSVGLayerTree:rootLayer withIdentifier:self.rootElement.identifier toDictionary:layersByElementId];
	
	NSLog(@"[%@] ROOT element id: %@ => layer: %@", [self class], self.rootElement.identifier, rootLayer);
	
    return layersByElementId;
}

@end
