#import "ADDeviceUtil.h"

@implementation ADDeviceUtil

+ (BOOL) isIPad
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

+ (BOOL) isIPhone5
{
    return ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON );
}

+ (BOOL) isRetina
{
    return [[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0;
}

+ (BOOL) isLandscape
{
    return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}

+ (NSString *)giveRandomFileName{
    NSString *fileName = [NSString stringWithFormat:@"file_%d",arc4random()%500];
    return fileName;
}

@end
