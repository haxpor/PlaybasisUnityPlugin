#import "Populator.h"
#import "Util.h"

#define RETURNIFNULL(x) if (x == nil) return;
#define BEGIN_NOTNULL(x) if (x != nil) {
#define END_NOTNULL(x) }
/*#define CREATE_PTRARRAY(varName, type, count, indexName)\
    ##type* ##varName = new ##type[count];\
    int ##indexName = 0;*/
/*#define SETPTRARRAY(ptrArray, count, to)\
    to->data = ptrArray;\
    to->count = count;*/

@implementation Populator

+ (void) populatePlayerBasic:(playerBasic*)outData from:(PBPlayerBasic*)pbData
{
	RETURNIFNULL(pbData)

    COPYSTRING(pbData.image, outData->image)
    COPYSTRING(pbData.userName, outData->userName)
    
    outData->exp = pbData.exp;
    outData->level = pbData.level;

    COPYSTRING(pbData.firstName, outData->firstName)
    COPYSTRING(pbData.lastName, outData->lastName)
    
    outData->gender = pbData.gender;

    COPYSTRING(pbData.clPlayerId, outData->clPlayerId)
}

+ (void) populatePlayerPublic:(playerPublic*)outData from:(PBPlayerPublic_Response*)pbData
{
    RETURNIFNULL(pbData)

    // playerBasic
    [Populator populatePlayerBasic:&outData->basic from:pbData.playerBasic];
    outData->registered = [pbData.registered timeIntervalSince1970];
    outData->lastLogin = [pbData.lastLogin timeIntervalSince1970];
    outData->lastLogout = [pbData.lastLogout timeIntervalSince1970];
}

+ (void) populatePlayer:(player*)outData from:(PBPlayer_Response*)pbData
{
    RETURNIFNULL(pbData)

    // playerPublic
    [Populator populatePlayerPublic:&outData->playerPublic from:pbData.playerPublic];
    COPYSTRING(pbData.email, outData->email)
    COPYSTRING(pbData.phoneNumber, outData->phoneNumber)
}

+ (void) populatePointArray:(_array<point>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    //CREATE_PTRARRAY(items, point, [pbArray count], i)
    point *items = new point[[pbArray count]];
    int i=0;

    for (PBPoint *p in pbArray)
    {
        COPYSTRING(p.rewardId, items[i].rewardId)
        COPYSTRING(p.rewardName, items[i].rewardName)
        items[i].value = p.value;
        i++;
    }
    //SETPTRARRAY(items, [pbArray count], &outData)
    outData->data = items;
    outData->count = i;
}

@end