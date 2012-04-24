#import "SVGImage.h"

#import "SVGDefsElement.h"
#import "SVGDescriptionElement.h"
#import "SVGParser.h"
#import "SVGTitleElement.h"
#import "SVGPathElement.h"

#import "SVGParserSVG.h"

@interface SVGImage ()

/*! Only preserved for temporary backwards compatibility */
- (BOOL)parseFileAtPath:(NSString *)aPath;
/*! Only preserved for temporary backwards compatibility */
-(BOOL)parseFileAtURL:(NSURL *)url;

- (BOOL)parseFileAtPath:(NSString *)aPath error:(NSError**) error;
- (BOOL)parseFileAtURL:(NSURL *)url error:(NSError**) error;

@property (nonatomic, readwrite) SVGSVGElement* rootElement;

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
		self.rootElement = [[SVGSVGElement alloc] initWithName:@"svg"];
		_width = SVGLengthZero;
		_height = SVGLengthZero;
		
		NSError* parseError = nil;
		if (![self parseFileAtPath:aPath error:&parseError]) {
			NSLog(@"[%@] MISSING OR CORRUPT FILE, OR FILE USES FEATURES THAT SVGKit DOES NOT YET SUPPORT, COULD NOT CREATE DOCUMENT: path = %@, error = %@", [self class], aPath, parseError);
			
			[self release];
			return nil;
		}
	}
	return self;
}

- (id)initWithContentsOfURL:(NSURL *)url {
	NSParameterAssert(url != nil);
	
	self = [super init]; 
	if (self) {
		self.rootElement = [[SVGSVGElement alloc] initWithName:@"svg"];
		_width = SVGLengthZero;
		_height = SVGLengthZero;
		
		if (![self parseFileAtURL:url]) {
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
		self.rootElement = [[SVGSVGElement alloc] initWithName:@"svg"];
		
        _width = SVGLengthGetWidth(frame);
        _height = SVGLengthGetHeight(frame);
    }
	return self;
}

- (void)dealloc {
	self.rootElement = nil;
	[super dealloc];
}

+ (UIImage *)imageWithData:(NSData *)data
{
	NSAssert( FALSE, @"Method unsupported / not yet implemented by SVGKit" );
	return nil;
}

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

-(UIImage *)uiImage
{
	NSAssert( FALSE, @"Auto-converting SVGImage to a rasterized UIImage is not yet implemented by SVGKit" );
	return nil;
}

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


- (BOOL)parseFileAtPath:(NSString *)aPath error:(NSError**) error {
	SVGParser* defaultParser = [SVGParser parserPlainSVGDocument:[SVGDocument documentFromFilename:aPath] ];
	
	if (![defaultParser parse:error]) {
		NSLog(@"[%@] SVGKit Parse error: %@", [self class], *error);
		[defaultParser release];
		
		return NO;
	}
	
	return YES;
}

- (BOOL)parseFileAtPath:(NSString *)aPath {
	return [self parseFileAtPath:aPath error:nil];
}


-(BOOL)parseFileAtURL:(NSURL *)url error:(NSError**) error {
	SVGParser* defaultParser = [SVGParser parserPlainSVGDocument:[SVGDocument documentFromURL:url]];
	
	if (![defaultParser parse:error]) {
		NSLog(@"[%@] SVGKit Parse error: %@", [self class], *error);
		[defaultParser release];
		
		return NO;
	}
	
	[defaultParser release];
	
	return YES;
}

-(BOOL)parseFileAtURL:(NSURL *)url {
	return [self parseFileAtURL:url error:nil];
}

- (CALayer *)newLayer {
	
	CALayer* _layer = [CALayer layer];
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
