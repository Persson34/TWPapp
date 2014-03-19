#import <Foundation/Foundation.h>

/**
* Device Utility
*/
@interface ADDeviceUtil : NSObject

/**
* @abstract Check if current device is iPad
* @return YES if current device is iPad
*/
+ (BOOL) isIPad;

/**
 * @abstract Check if current device is iPhone5 with height of 568
 * @return YES if current device is iPhone5
 */
+ (BOOL) isIPhone5;

/**
* @abstract check if current device is retina display
* @return YES if current device is retina display
*/
+ (BOOL) isRetina;

+ (BOOL) isLandscape;

+ (NSString *)giveRandomFileName;

@end
