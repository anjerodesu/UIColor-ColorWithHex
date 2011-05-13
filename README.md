UIColor+ColorWithHex
===============================

UIColor+ColorWithHex was inspired by the lack of hexadecimal colour integration of iOS.

Methods
-------------------------------

+ (UIColor *)colorWithHex:(UInt32)hexadecimal;
+ (UIColor *)colorWithHexString:(NSString *)hexadecimal;
+ (UIColor *)colorWithAlphaHex:(UInt32)hexadecimal;
+ (UIColor *)colorWithAlphaHexString:(NSString *)hexadecimal;
+ (NSString *)colorWithRGBToHex:(UIColor *)color;
+ (UIColor *)randomColor;
// ObjC (manual hex conversion to RGB)
+ (UIColor *)colorWithHexa:(NSString *)hexadecimal;

Install
-------------------------------
Just copy the UIColor+ColorWithHex.h and UIColor+ColorWithHex.m files to your project and #import the header file (UIColor+ColorWithHex.h)