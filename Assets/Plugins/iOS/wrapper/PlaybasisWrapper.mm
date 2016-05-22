#import "PlaybasisWrapper.h"
#import "Playbasis.h" // your actual iOS library header

#define CHECK_NOTNULL(x) x != nil && x != (id)[NSNull null]

// Converts C style string to NSString
NSString* CreateNSString (const char* string)
{
	if (string)
		return [NSString stringWithUTF8String: string];
	else
		return [NSString stringWithUTF8String: ""];
}

// Helper method to create C string copy
char* MakeStringCopy (const char* string)
{
	if (string == NULL)
		return NULL;
	
	char* res = (char*)malloc(strlen(string) + 1);
	strcpy(res, string);
	return res;
}

// Populate struct data based on input response type
void PopulateData(pbResponseType type, PBBase_Response *response, void* outData)
{
	if (type == responseType_playerPublic)
	{
		PBPlayerPublic_Response* playerResponse = (PBPlayerPublic_Response*)response;

		playerPublic* data = (playerPublic*)outData;
        if (playerResponse.playerBasic.image != nil &&
            playerResponse.playerBasic.image != (id)[NSNull null])
            data->basic.image = MakeStringCopy([playerResponse.playerBasic.image UTF8String]);
        
        if (playerResponse.playerBasic.userName != nil &&
            playerResponse.playerBasic.userName != (id)[NSNull null])
            data->basic.userName = MakeStringCopy([playerResponse.playerBasic.userName UTF8String]);
        
        data->basic.exp = playerResponse.playerBasic.exp;
        data->basic.level = playerResponse.playerBasic.level;
        
        if (playerResponse.playerBasic.firstName != nil &&
            playerResponse.playerBasic.firstName != (id)[NSNull null])
            data->basic.firstName = MakeStringCopy([playerResponse.playerBasic.firstName UTF8String]);
        
        if (playerResponse.playerBasic.lastName != nil &&
            playerResponse.playerBasic.lastName != (id)[NSNull null])
            data->basic.lastName = MakeStringCopy([playerResponse.playerBasic.lastName UTF8String]);
        
        data->basic.gender = playerResponse.playerBasic.gender;
        
        if (playerResponse.playerBasic.clPlayerId != nil &&
            playerResponse.playerBasic.clPlayerId != (id)[NSNull null])
            data->basic.clPlayerId = MakeStringCopy([playerResponse.playerBasic.clPlayerId UTF8String]);
        

		data->registered = [playerResponse.registered timeIntervalSince1970];
		data->lastLogin = [playerResponse.lastLogin timeIntervalSince1970];
		data->lastLogout = [playerResponse.lastLogout timeIntervalSince1970];
	}
	else if (type == responseType_player)
	{
		PBPlayer_Response* cr = (PBPlayer_Response*)response;

		player* data = (player*)outData;
		if (cr.playerPublic != nil)
		{
			PopulateData(responseType_playerPublic, cr.playerPublic, &(data->playerPublic));
		}

		if (CHECK_NOTNULL(cr.email))
		{
			data->email = MakeStringCopy([cr.email UTF8String]);
		}

		if (CHECK_NOTNULL(cr.phoneNumber))
		{
			data->phoneNumber = MakeStringCopy([cr.phoneNumber UTF8String]);
		}
	}
	else if (type == responseType_point)
	{
		PBPoint_Response* cr = (PBPoint_Response*)response;

		pointR* data = (pointR*)outData;
		if (cr.point != nil && [cr.point count] > 0)
		{
			point *items = new point[[cr.point count]];
			int i=0;

			for (PBPoint* pt in cr.point)
			{
				if (pt != nil)
				{
					if (CHECK_NOTNULL(pt.rewardId))
					{
						items[i].rewardId = MakeStringCopy([pt.rewardId UTF8String]);
					}

					if (CHECK_NOTNULL(pt.rewardName))
					{
						items[i].rewardName = MakeStringCopy([pt.rewardName UTF8String]);
					}

					items[i].value = pt.value;
					i++;
				}
			}

			// set result to data
			data->pointArray.data = (point*)items;
			data->pointArray.count = i;
		}
	}
	else if (type == responseType_activeQuizList)
	{
		PBActiveQuizList_Response* cr = (PBActiveQuizList_Response*)response;

		quizList* data = (quizList*)outData;
		if (cr.list != nil)
		{
			if (cr.list.quizBasics != nil && [cr.list.quizBasics count] > 0)
			{
				const int itemsCount = [cr.list.quizBasics count];
				quizBasic *items = new quizBasic[itemsCount];
				int i=0;

				for (PBQuizBasic* element in cr.list.quizBasics)
				{
					if (element != nil)
					{
						if (CHECK_NOTNULL(element.name))
						{
							items[i].name = MakeStringCopy([element.name UTF8String]);
						}

						if (CHECK_NOTNULL(element.image))
						{
							items[i].image = MakeStringCopy([element.image UTF8String]);
						}

						if (CHECK_NOTNULL(element.weight))
						{
							items[i].weight = MakeStringCopy([element.weight UTF8String]);
						}

						if (CHECK_NOTNULL(element.description_))
						{
							items[i].description_ = MakeStringCopy([element.description_ UTF8String]);
						}

						if (CHECK_NOTNULL(element.descriptionImage))
						{
							items[i].descriptionImage = MakeStringCopy([element.descriptionImage UTF8String]);
						}

						if (CHECK_NOTNULL(element.quizId))
						{
							items[i].quizId = MakeStringCopy([element.quizId UTF8String]);
						}

						i++;
					}
				}

				data->quizBasicArray.data = (quizBasic*)items;
				data->quizBasicArray.count = i;
			}
		}
	}
}

/*
	Fields and methods exposed by Playbasis class.
*/
const char* _version() {
	return MakeStringCopy([[Playbasis version] UTF8String]);
}

const char* _token() {
	return MakeStringCopy([[Playbasis sharedPB].token UTF8String]);
}

void _auth(const char* apikey, const char* apisecret, const char* bundleId, OnResult callback) {
	[[Playbasis sharedPB] authWithApiKeyAsync:CreateNSString(apikey) apiSecret:CreateNSString(apisecret) bundleId:CreateNSString(bundleId) andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
       	if (error == nil)
       	{
       		NSLog(@"%@", auth);

       		if (callback)
       		{
       			NSLog(@"Call callback(true) on auth()");
       			callback(true);
       		}
       	}
       	else
       	{
       		NSLog(@"Failed in calling auth()");

       		// callback with failure
       		if (callback)
       		{
       			NSLog(@"Call callback(false) on auth()");
       			callback(false);
       		}
       	}
    }];
}

void _renew(const char* apikey, const char* apisecret, OnResult callback) {
	[[Playbasis sharedPB] renewWithApiKeyAsync:CreateNSString(apikey) apiSecret:CreateNSString(apisecret) andBlock:^(PBAuth_Response* auth, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"%@", auth);

			if (callback)
			{
				callback(true);
			}
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _login(const char* playerId, OnResult callback)
{
	[[Playbasis sharedPB] loginPlayerAsync:CreateNSString(playerId) withBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"%@", result);

			if (callback)
			{
				callback(true);
			}
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _logout(const char* playerId, OnResult callback)
{
	[[Playbasis sharedPB] logoutPlayer:CreateNSString(playerId) withBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"%@", result);

			if (callback)
			{
				callback(true);
			}
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _register(const char* playerId, const char* userName, const char* email, const char* imageUrl, OnResult callback)
{
	[[Playbasis sharedPB] registerUserWithPlayerIdAsync:CreateNSString(playerId) username:CreateNSString(userName) email:CreateNSString(email) imageUrl:CreateNSString(imageUrl) andBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"Registered a new user successfully.");

			callback(true);
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _playerPublic(const char* playerId, OnDataResult callback) {
	[[Playbasis sharedPB] playerPublicAsync:CreateNSString(playerId) withBlock:^(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error) {
		if (error == nil)
		{
			playerPublic data;
			PopulateData(responseType_playerPublic, playerResponse, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _player(const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] playerAsync:CreateNSString(playerId) withBlock:^(PBPlayer_Response * p, NSURL *url, NSError *error) {
		if (error == nil)
		{
			player data;
			PopulateData(responseType_player, p, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _pointOfPlayer(const char* playerId, const char* pointName, OnDataResult callback)
{
	[[Playbasis sharedPB] pointOfPlayerAsync:CreateNSString(playerId) forPoint:CreateNSString(pointName) withBlock:^(PBPoint_Response * points, NSURL *url, NSError *error) {
		if (error == nil)
		{
            pointR data;
			PopulateData(responseType_point, points, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizList(OnDataResult callback)
{
	[[Playbasis sharedPB] quizListWithBlockAsync:^(PBActiveQuizList_Response * activeQuizList, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizList data;
			PopulateData(responseType_activeQuizList, activeQuizList, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizListOfPlayer(const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizListOfPlayerAsync:CreateNSString(playerId) withBlock:^(PBActiveQuizList_Response * activeQuizList, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizList data;
			PopulateData(responseType_activeQuizList, activeQuizList, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}