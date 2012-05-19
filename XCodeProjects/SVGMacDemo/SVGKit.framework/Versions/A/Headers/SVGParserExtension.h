/**
 SVGParserExtension.h
 
 A protocol that lets us split "parsing an SVG" into lots of smaller parsing classes
 
 PARSING
 ---
 Actual parsing of an SVG is split into three places:
 
 1. High level, XML parsing: SVGParser
 2. ALL THE REST, this class: parsing the structure of a document, and special XML tags: any class that extends "SVGParserExtension"
 
 */

#import <Foundation/Foundation.h>

#import "SVGSource.h"

@protocol SVGParserExtension <NSObject>

/*! Array of URI's as NSString's, one string for each XMLnamespace that this parser-extension can parse
 *
 * e.g. the main parser returns "[NSArray arrayWithObjects:@"http://www.w3.org/2000/svg", nil];"
 */
-(NSArray*) supportedNamespaces;

/*! Array of NSString's, one string for each XML tag (within a supported namespace!) that this parser-extension can parse
 *
 * e.g. the main parser returns "[NSArray arrayWithObjects:@"svg", @"title", @"defs", @"path", @"line", @"circle", ...etc... , nil];"
 */
-(NSArray*) supportedTags;

- (NSObject*)handleStartElement:(NSString *)name document:(SVGSource*) document xmlns:(NSString*) namespaceURI attributes:(NSMutableDictionary *)attributes;
-(void) addChildObject:(NSObject*)child toObject:(NSObject*)parent;// NOT SURE IF THIS IS NEEDED ANYWHERE ANY MORE: inDocument:(SVGSource*) svgSource;
-(void) parseContent:(NSMutableString*) content forItem:(NSObject*) item;
-(BOOL) createdItemShouldStoreContent:(NSObject*) item;

@end
