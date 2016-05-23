#import "Populator.h"
#import "Util.h"

@implementation Populator

+ (void) populatePlayerBasic:(playerBasic*)outData from:(PBPlayerBasic*)pbData
{
	if (pbData == nil)
		return;

    if (CHECK_NOTNULL(pbData.image))
        outData->image = MakeStringCopy([pbData.image UTF8String]);
    
    if (CHECK_NOTNULL(pbData.userName))
        outData->userName = MakeStringCopy([pbData.userName UTF8String]);
    
    outData->exp = pbData.exp;
    outData->level = pbData.level;
    
    if (CHECK_NOTNULL(pbData.firstName))
        outData->firstName = MakeStringCopy([pbData.firstName UTF8String]);
    
    if (CHECK_NOTNULL(pbData.lastName))
        outData->lastName = MakeStringCopy([pbData.lastName UTF8String]);
    
    outData->gender = pbData.gender;
    
    if (CHECK_NOTNULL(pbData.clPlayerId))
        outData->clPlayerId = MakeStringCopy([pbData.clPlayerId UTF8String]);
}

+ (void) populatePlayerPublic:(playerPublic*)outData from:(PBPlayerPublic_Response*)pbData
{
    if (pbData == nil)
        return;

    // PBPlayerBasic
    [Populator populatePlayerBasic:&outData->basic from:pbData.playerBasic];
    outData->registered = [pbData.registered timeIntervalSince1970];
    outData->lastLogin = [pbData.lastLogin timeIntervalSince1970];
    outData->lastLogout = [pbData.lastLogout timeIntervalSince1970];
}

@end