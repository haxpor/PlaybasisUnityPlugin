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

+ (void) populateQuizArray:(_array<quizBasic>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    quizBasic *items = new quizBasic[[pbArray count]];
    int i=0;

    for (PBQuizBasic *qb in pbArray)
    {
        COPYSTRING(qb.name, items[i].name)
        COPYSTRING(qb.image, items[i].image)
        COPYSTRING(qb.weight, items[i].weight)
        COPYSTRING(qb.description_, items[i].description_)
        COPYSTRING(qb.descriptionImage, items[i].descriptionImage)
        COPYSTRING(qb.quizId, items[i].quizId)
        i++;
    }
    outData->data = items;
    outData->count = i;
}

+ (void) populateQuizBasic:(quizBasic*)outData from:(PBQuizBasic*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.name, outData->name)
    COPYSTRING(pbData.image, outData->image)
    COPYSTRING(pbData.weight, outData->weight)
    COPYSTRING(pbData.description_, outData->description_)
    COPYSTRING(pbData.descriptionImage, outData->descriptionImage)
    COPYSTRING(pbData.quizId, outData->quizId)
}

+ (void) populateQuiz:(quiz*)outData from:(PBQuiz*)pbData
{
    RETURNIFNULL(pbData)

    // quizBasic
    [Populator populateQuizBasic:&outData->basic from:pbData.basic];

    outData->dateStart = [pbData.dateStart timeIntervalSince1970];
    outData->dateExpire = [pbData.dateExpire timeIntervalSince1970];
    outData->status = pbData.status;

    // array of grade
    [Populator populateGradeArray:&outData->gradeArray from:pbData.grades.grades];

    outData->deleted = pbData.deleted;
    outData->totalMaxScore = pbData.totalMaxScore;
    outData->totalQuestions = pbData.totalQuestions;
}

+ (void) populateGrade:(grade*)outData from:(PBGrade*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.gradeId, outData->gradeId)
    COPYSTRING(pbData.start, outData->start)
    COPYSTRING(pbData.end, outData->end)
    COPYSTRING(pbData.grade, outData->grade)
    COPYSTRING(pbData.rank, outData->rank)
    COPYSTRING(pbData.rankImage, outData->rankImage)

    // gradeRewards
    [Populator populateGradeRewards:&outData->rewards from:pbData.rewards];
}

+ (void) populateGradeArray:(_array<grade>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    grade* items = new grade[[pbArray count]];
    int i=0;

    for (PBGrade *c in pbArray)
    {
        COPYSTRING(c.gradeId, items[i].gradeId)
        COPYSTRING(c.start, items[i].start)
        COPYSTRING(c.end, items[i].end)
        COPYSTRING(c.grade, items[i].grade)
        COPYSTRING(c.rank, items[i].rank)
        COPYSTRING(c.rankImage, items[i].rank)

        // gradeRewards
        [Populator populateGradeRewards:&items[i].rewards from:c.rewards];
    }
}

+ (void) populateGradeRewards:(gradeRewards*)outData from:(PBGradeRewards*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.expValue, outData->expValue)
    COPYSTRING(pbData.pointValue, outData->pointValue)

    // array of gradeRewardCustom
    [Populator populateGradeRewardCustomArray:&outData->gradeRewardCustomArray from:pbData.customList.gradeRewardCustoms];
}

+ (void) populateGradeRewardCustom:(gradeRewardCustom*)outData from:(PBGradeRewardCustom*)pbData
{
    RETURNIFNULL(pbData)

    COPYSTRING(pbData.customId, outData->customId)
    COPYSTRING(pbData.customValue, outData->customValue)
}

+ (void) populateGradeRewardCustomArray:(_array<gradeRewardCustom>*)outData from:(NSArray*)pbArray
{
    RETURNIFNULL(pbArray)

    gradeRewardCustom* items = new gradeRewardCustom[[pbArray count]];
    int i=0;

    for (PBGradeRewardCustom *c in pbArray)
    {
        COPYSTRING(c.customId, items[i].customId)
        COPYSTRING(c.customValue, items[i].customValue)
        i++;
    }

    outData->data = items;
    outData->count = i;
}

@end