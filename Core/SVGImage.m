#import "SVGImage.h"

#import "SVGDefsElement.h"
#import "SVGDescriptionElement.h"
#import "SVGParser.h"
#import "SVGTitleElement.h"
#import "SVGPathElement.h"

#import "SVGParserSVG.h"

@interface SVGImage ()

/*! Only preserved for temporary backwards compatibility */
- (SVGSVGElement*)parseFileAtPath:(NSString *)aPath;
/*! Only preserved for temporary backwards compatibility */
-(SVGSVGElement*)parseFileAtURL:(NSURL *)url;

- (SVGSVGElement*)parseFileAtPath:(NSString *)aPath error:(NSError**) error;
- (SVGSVGElement*)parseFileAtURL:(NSURL *)url error:(NSError**) error;

@property (nonatomic, readwrite) SVGSVGElement* rootElement;
@property (nonatomic, readwrite) SVGLength svgWidth;
@property (nonatomic, readwrite) SVGLength svgHeight;


#pragma mark - UIImage methods cloned and re-implemented as SVG intelligent methods
//NOT DEFINED: what is the scale for a SVGImage? @property(nonatomic,readwrite) CGFloat            scale __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

@end

#pragma mark - main class
@implementation SVGImage

@synthesize svgWidth = _width;
@synthesize svgHeight = _height;
@synthesize rootElement = _rootElement;

@dynamic title, svgDescription, defs;


+ (SVGImage *)imageNamed:(NSString *)name {
	NSParameterAssert(name != nil);
	
	NSBundle *bundle = [NSBundle mainBundle];
	
	if (!bundle)
		return nil;
	
	NSString *newName = [name stringByDeletingPathExtension];
	NSString *extension = [name pathExtension];
    if ([@"" isEqualToString:extension]) {
        extension = @"svg";
    }
	
	NSString *path = [bundle pathForResource:newName ofType:extension];
	
	if (!path)
	{
		NSLog(@"[%@] MISSING FILE, COULD NOT CREATE DOCUMENT: filename = %@, extension = %@", [self class], newName, extension);
		return nil;
	}
	
	return [self imageWithContentsOfFile:path];
}

+ (id)documentFromURL:(NSURL *)url {
	NSParameterAssert(url != nil);
	
	return [[[[self class] alloc] initWithContentsOfURL:url] autorelease];
}

+ (SVGImage*)imageWithContentsOfFile:(NSString *)aPath {
	return [[[[self class] alloc] initWithContentsOfFile:aPath] autorelease];
}

- (id)initWithContentsOfFile:(NSString *)aPath {
	NSParameterAssert(aPath != nil);
	
	self = [super init];
	if (self) {
		self.svgWidth = SVGLengthZero;
		self.svgHeight = SVGLengthZero;
		
		NSError* parseError = nil;
		self.rootElement = [self parseFileAtPath:aPath error:&parseError];
		if ( self.rootElement == nil ) {
			NSLog(@"[%@] MISSING OR CORRUPT FILE, OR FILE USES FEATURES THAT SVGKit DOES NOT YET SUPPORT, COULD NOT CREATE DOCUMENT: path = %@, error = %@", [self class], aPath, parseError);
			
			[self release];
			return nil;
		}
		
		self.svgWidth = self.rootElement.documentWidth;
		self.svgHeight = self.rootElement.documentHeight;
		
	}
	return self;
}

- (id)initWithContentsOfURL:(NSURL *)url {
	NSParameterAssert(url != nil);
	
	self = [super init]; 
	if (self) {
		_width = SVGLengthZero;
		_height = SVGLengthZero;
		
		self.rootElement = [self parseFileAtURL:url];
		if ( self.rootElement == nil ) {
			NSLog(@"[%@] ERROR: COULD NOT FIND SVG AT URL = %@", [self class], url);
			
			[self release];
			return nil;
		}
	}
	return self;
}

- (id) initWithFrame:(CGRect)frame
{
	self = [super init];
	if (self) {
		self.rootElement = [[[SVGSVGElement alloc] initWithName:@"svg"] autorelease];
		
        _width = SVGLengthGetWidth(frame);
        _height = SVGLengthGetHeight(frame);
    }
	return self;
}

- (void)dealloc {
	self.rootElement = nil;
	[super dealloc];
}

//TODO mac alternatives to UIKit functions

#if TARGET_OS_IPHONE
+ (UIImage *)imageWithData:(NSData *)data
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}
#endif

- (id)initWithData:(NSData *)data
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}

#pragma mark - UIImage methods we reproduce to make it act like a UIImage

-(CGSize)size
{
	return CGSizeMake( SVGLengthAsApplePoints(self.svgWidth), SVGLengthAsApplePoints(self.svgHeight));
}

-(CGFloat)scale
{
	NSAssert( FALSE, @"image.scale is currently UNDEFINED for an SVGImage (nothing implemented by SVGKit)" );
	return 0.0;
}

#if TARGET_OS_IPHONE
-(UIImage *)uiImage
{
	NSAssert( FALSE, @"Auto-converting SVGImage to a rasterized UIImage is not yet implemented by SVGKit" );
	return nil;
}
#endif

// the these draw the image 'right side up' in the usual coordinate system with 'point' being the top-left.

- (void)drawAtPoint:(CGPoint)point                                                        // mode = kCGBlendModeNormal, alpha = 1.0
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}

#pragma mark - unsupported / unimplemented UIImage methods (should add as a feature)
- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}
- (void)drawInRect:(CGRect)rect                                                           // mode = kCGBlendModeNormal, alpha = 1.0
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}
- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}

- (void)drawAsPatternInRect:(CGRect)rect // draws the image as a CGPattern
// animated images. When set as UIImageView.image, animation will play in an infinite loop until removed. Drawing will render the first image
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
}

#if TARGET_OS_IPHONE
+ (UIImage *)animatedImageNamed:(NSString *)name duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0)  // read sequnce of files with suffix starting at 0 or 1
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}
+ (UIImage *)animatedResizableImageNamed:(NSString *)name capInsets:(UIEdgeInsets)capInsets duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) // squence of files
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}
+ (UIImage *)animatedImageWithImages:(NSArray *)images duration:(NSTimeInterval)duration __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0)
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}
#endif

- (SVGSVGElement*)parseFileAtPath:(NSString *)aPath error:(NSError**) error {
	
	SVGDocument* parsedDocument = [SVGDocument documentFromFilename:aPath];
	SVGParser* defaultParser = [SVGParser parserPlainSVGDocument:parsedDocument];
	
	SVGSVGElement* rootNode = (SVGSVGElement*) [defaultParser parse:error];
	if ( rootNode == nil ) {
		NSLog(@"[%@] SVGKit Parse error: %@", [self class], *error);
		[defaultParser release];
		
		return nil;
	}
	
	return rootNode;
}

- (SVGSVGElement*)parseFileAtPath:(NSString *)aPath {
	return [self parseFileAtPath:aPath error:nil];
}


-(SVGSVGElement*)parseFileAtURL:(NSURL *)url error:(NSError**) error {
	SVGParser* defaultParser = [SVGParser parserPlainSVGDocument:[SVGDocument documentFromURL:url]];
	
	SVGSVGElement* rootNode = (SVGSVGElement*) [defaultParser parse:error];
	if ( rootNode == nil ) {
		NSLog(@"[%@] SVGKit Parse error: %@", [self class], *error);
		[defaultParser release];
		
		return nil;
	}
	
	[defaultParser release];
	
	return rootNode;
}

-(SVGSVGElement*)parseFileAtURL:(NSURL *)url {
	return [self parseFileAtURL:url error:nil];
}

- (CALayer *)newLayer {
	
	CALayer* _layer = [[CALayer layer] retain];
		_layer.frame = CGRectMake(0.0f, 0.0f, SVGLengthAsPixels(self.svgWidth), SVGLengthAsPixels(self.svgHeight));
	
	return _layer;
}

- (void)layoutLayer:(CALayer *)layer { }

- (NSString *)title {
	return [self.rootElement findFirstElementOfClass:[SVGTitleElement class]].stringValue;
}

- (NSString *)desc {
	return [self.rootElement findFirstElementOfClass:[SVGDescriptionElement class]].stringValue;
}

- (SVGDefsElement *)defs {
	return (SVGDefsElement *) [self.rootElement findFirstElementOfClass:[SVGDefsElement class]];
}

#if NS_BLOCKS_AVAILABLE

- (void) applyAggregator:(SVGElementAggregationBlock)aggregator toElement:(SVGElement < SVGLayeredElement > *)element
{
	if (![element.children count]) {
		return;
	}
	
	for (SVGElement *child in element.children) {
		if ([child conformsToProtocol:@protocol(SVGLayeredElement)]) {
			SVGElement<SVGLayeredElement>* layeredElement = (SVGElement<SVGLayeredElement>*)child;
            if (layeredElement) {
                aggregator(layeredElement);
                
                [self applyAggregator:aggregator
                            toElement:layeredElement];
            }
		}
	}
}

- (void) applyAggregator:(SVGElementAggregationBlock)aggregator
{
    [self applyAggregator:aggregator toElement:self.rootElement];
}

#endif

@end
