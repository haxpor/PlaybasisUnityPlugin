#import "PlaybasisResponsesWrapper.h"
#import "PBResponses.h"

@interface Populator : NSObject

+ (void) populatePlayerBasic:(playerBasic*)outData from:(PBPlayerBasic*)pbData;
+ (void) populatePlayerPublic:(playerPublic*)outData from:(PBPlayerPublic_Response*)pbData;
+ (void) populatePlayer:(player*)outData from:(PBPlayer_Response*)pbData;
+ (void) populatePointArray:(_array<point>*)outData from:(NSArray*)pbArray;

@end