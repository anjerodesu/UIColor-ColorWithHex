//
//  UIColor+ColorWithHex.m
//  ColorWithHex
//
//  Created by Angelo Villegas on 3/24/11.
//  Copyright (c) 2011 Studio Villegas. All rights reserved.
//	http://www.studiovillegas.com/
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "UIColor+ColorWithHex.h"


@implementation UIColor (ColorWithHex)

#pragma mark - Category Methods
// Direct Conversion to hexadecimal (Automatic)
+ (UIColor *)colorWithHex:(UInt32)hexadecimal
{
	CGFloat red, green, blue;
	
	red = (hexadecimal >> 16) & 0xFF;
	green = (hexadecimal >> 8) & 0xFF;
	blue = hexadecimal & 0xFF;
	
    return [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: 1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexadecimal
{
	const char *cString = [hexadecimal cStringUsingEncoding: NSASCIIStringEncoding];
	long int hex;
	
	if (cString[0] == '#')
	{
		hex = strtol(cString + 1, NULL, 16);
	}
	else
	{
		hex = strtol(cString, NULL, 16);
	}
	
	return [UIColor colorWithHex: hex];
}

+ (UIColor *)colorWithAlphaHex:(UInt32)hexadecimal
{
	CGFloat red, green, blue, alpha;
	
	alpha = (hexadecimal >> 24) & 0xFF;
	red = (hexadecimal >> 16) & 0xFF;
	green = (hexadecimal >> 8) & 0xFF;
	blue = hexadecimal & 0xFF;
	
    return [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: alpha / 255.0f];
}

+ (UIColor *)colorWithAlphaHexString:(NSString *)hexadecimal
{
	const char *cString = [hexadecimal cStringUsingEncoding: NSASCIIStringEncoding];
	long long int hex;
	
	if (cString[0] == '#')
	{
		hex = strtoll(cString + 1, NULL, 16);
	}
	else
	{
		hex = strtoll(cString, NULL, 16);
	}
	
	return [UIColor colorWithAlphaHex: hex];
}

+ (NSString *)colorWithRGBToHex:(UIColor *)color
{
	const CGFloat *components = CGColorGetComponents([color CGColor]);
	NSString *hexadecimal = [NSString stringWithFormat: @"#%02X%02X%02X", (int)(255 * components[0]), (int)(255 * components[1]), (int)(255 * components[2])];
	
	return hexadecimal;
}

+ (UIColor *)randomColor
{
	static BOOL generated = NO;
	
	if (!generated)
	{
		generated = YES;
		srandom(time(NULL));
	}
	
	CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
	
	return [UIColor colorWithRed: red green: green blue: blue alpha: 1.0f];
}

#pragma mark -
// Converting using Hex to RGB formula (Manual)
+ (UIColor *)colorWithHexa:(NSString *)hexadecimal
{
	hexadecimal = [hexadecimal uppercaseString];
	NSInteger a;
	
	if ([[hexadecimal substringWithRange: NSMakeRange(0, 1)] isEqualToString: @"#"])
	{
		a = 1;
	}
	else
	{
		a = 0;
	}
	
	/*
	 In hexadecimal, all numbers beyond 9 will be converted to single
	 character (Base16 digits should be converted beyond the digit 9)
	 Conversion:
	 10 = A	11 = B	12 = C	13 = D	14 = E	15 = F
	 */
	
	NSDictionary *hexConstants = [NSDictionary dictionaryWithObjectsAndKeys: @"10", @"A", @"11", @"B", @"12", @"C", @"13", @"D", @"14", @"E", @"15", @"F", nil];
	NSMutableArray *hexArray = [[NSMutableArray alloc] init];
	NSMutableArray *hexConverted = [[NSMutableArray alloc] init];
	
	for (NSInteger x = a; x < [hexadecimal length]; x++)
	{
		[hexArray insertObject: [hexadecimal substringWithRange: NSMakeRange(x, 1)]	atIndex: x - 1];
	}
	
	for (NSString *hexa in hexArray)
	{
		if ([hexConstants valueForKey: hexa])
		{
			[hexConverted addObject: [hexConstants valueForKey: hexa]];
		}
		else
		{
			[hexConverted addObject: hexa];
		}
	}
	
	CGFloat red = 0.0;
	CGFloat green = 0.0;
	CGFloat blue = 0.0;
	
	/*
	 Calculation of Hex to RGB :	# x y x' y' x" y"
	 x  * 16 = (x ) + y  = R
	 x' * 16 = (x') + y' = G
	 x" * 16 = (x") + y" = B
	 */
	for (NSInteger x = 0; x < [hexConverted count]; x++)
	{
		switch (x)
		{
			case 0 :
			{
				const int value = [[hexConverted objectAtIndex: x] integerValue];
				red = value * 16 + [[hexConverted objectAtIndex: x + 1] integerValue];
				break;
			}
			case 2 :
			{
				const int value = [[hexConverted objectAtIndex: x] integerValue];
				green = value * 16 + [[hexConverted objectAtIndex: x + 1] integerValue];
				break;
			}
			case 4 :
			{
				const int value = [[hexConverted objectAtIndex: x] integerValue];
				blue = value * 16 + [[hexConverted objectAtIndex: x + 1] integerValue];
				break;
			}
			default:
				break;
		}
	}
	
	return [UIColor colorWithRed: red / 255.0f green: green / 255.0f blue: blue / 255.0f alpha: 1.0f];
}

@end