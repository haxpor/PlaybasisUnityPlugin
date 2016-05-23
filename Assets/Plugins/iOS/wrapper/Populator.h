#import "PlaybasisResponsesWrapper.h"
#import "PBResponses.h"

@interface Populator : NSObject

+ (void) populatePlayerBasic:(playerBasic*)outData from:(PBPlayerBasic*)pbData;
+ (void) populatePlayerPublic:(playerPublic*)outData from:(PBPlayerPublic_Response*)pbData;

@end