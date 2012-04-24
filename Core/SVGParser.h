/**
 SVGParser.h
 
 The main parser for SVGKit. All the magic starts here
 
 PARSING
 ---
 Actual parsing of an SVG is split into three places:
 
 1. High level, XML parsing: this file (SVGParser)
 2. Mid level, parsing the structure of a document, and special XML tags: any class that extends "SVGParserExtension"
 3. Mid level, parsing SVG tags only: SVGParserSVG (it's an extension that just does base SVG)
 4. Low level, parsing individual tags within a file, and precise co-ordinates: all the "SVG...Element" classes parse themselves
 
 IDEALLY, we'd like to change that to:
 
 1. High level, XML parsing: this file (SVGParser)
 2. Mid level, parsing the structure of a document, and special XML tags: any class that extends "SVGParserExtension"
 3. Mid level, parsing SVG tags only, but also handling all the different tags: SVGParserSVG
 4. Lowest level, parsing co-ordinate lists, numbers, strings: yacc/lex parser (in an unnamed class that hasn't been written yet)
 */

#import <Foundation/Foundation.h>

#import "SVGParserExtension.h"

#import "SVGElement.h"

/*! RECOMMENDED: leave this set to 1 to get warnings about "legal, but poorly written" SVG */
#define PARSER_WARN_FOR_ANONYMOUS_SVG_G_TAGS 1

/*! Verbose parser logging - ONLY needed if you have an SVG file that's failing to load / crashing */
#define DEBUG_VERBOSE_LOG_EVERY_TAG 0

@class SVGDocument;

@interface SVGParser : NSObject {
  @private
	NSString *_path;
	BOOL _failed;
	BOOL _storingChars;
	NSMutableString *_storedChars;
	NSMutableArray *_elementStack;
	SVGElement *_rootNode;
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	SVGDocument *_document;
#else
	__weak SVGDocument *_document; // TODO: should this still be weak? probably not?
#endif
	NSError* errorForCurrentParse;
}

@property(nonatomic,retain) NSURL* sourceURL;

@property(nonatomic,retain) NSMutableArray* parserExtensions;

@property(nonatomic, retain) NSMutableArray* parseWarnings;

+(SVGParser*) parserPlainSVGDocument:(SVGDocument*) document;

- (id)initWithDocument:(SVGDocument *)doc;

- (void) addSVGParserExtension:(NSObject<SVGParserExtension>*) extension;

- (SVGElement*)parse:(NSError **)outError;

+(NSDictionary *) NSDictionaryFromCSSAttributes: (NSString *)css;

@end
