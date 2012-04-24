
#import "SVGDocument.h"

@implementation SVGDocument

@synthesize svgLanguageVersion;
@synthesize hasSourceFile, hasSourceURL;
@synthesize filePath, URL;

+(SVGDocument*) documentFromFilename:(NSString*) p
{
	SVGDocument* d = [[[SVGDocument alloc] init] autorelease];
	
	d.hasSourceFile = TRUE;
	d.filePath = p;
	
	return d;
}

+(SVGDocument*) documentFromURL:(NSURL*) u
{
	SVGDocument* d = [[[SVGDocument alloc] init] autorelease];
	
	d.hasSourceURL = TRUE;
	d.URL = u;
	
	return d;
}

@end
