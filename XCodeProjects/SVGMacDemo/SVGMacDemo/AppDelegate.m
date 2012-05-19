//
//  AppDelegate.m
//  SVGMacDemo
//
//  Created by Mum Ice on 19/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import <SVGKit/SVGImage.h>
#import <SVGKit/SVGParser.h>
@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

    SVGSource *source = [SVGSource sourceFromFilename:@"lion.svg"];
    [SVGParser parseSourceUsingDefaultSVGParser:source];
}

@end
