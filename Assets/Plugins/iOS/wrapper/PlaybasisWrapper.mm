#import "PlaybasisWrapper.h"
#import "Playbasis.h" // your actual iOS library header

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

void _playerPublic(const char* playerId, OnDataResult callback) {
	[[Playbasis sharedPB] playerPublicAsync:CreateNSString(playerId) withBlock:^(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error) {
		if (error == nil)
		{
			playerPublic data;
            if (playerResponse.playerBasic.image != nil &&
                playerResponse.playerBasic.image != (id)[NSNull null])
                data.basic.image = MakeStringCopy([playerResponse.playerBasic.image UTF8String]);
            
            if (playerResponse.playerBasic.userName != nil &&
                playerResponse.playerBasic.userName != (id)[NSNull null])
                data.basic.userName = MakeStringCopy([playerResponse.playerBasic.userName UTF8String]);
            
            data.basic.exp = playerResponse.playerBasic.exp;
            data.basic.level = playerResponse.playerBasic.level;
            
            if (playerResponse.playerBasic.firstName != nil &&
                playerResponse.playerBasic.firstName != (id)[NSNull null])
                data.basic.firstName = MakeStringCopy([playerResponse.playerBasic.firstName UTF8String]);
            
            if (playerResponse.playerBasic.lastName != nil &&
                playerResponse.playerBasic.lastName != (id)[NSNull null])
                data.basic.lastName = MakeStringCopy([playerResponse.playerBasic.lastName UTF8String]);
            
            data.basic.gender = playerResponse.playerBasic.gender;
            
            if (playerResponse.playerBasic.clPlayerId != nil &&
                playerResponse.playerBasic.clPlayerId != (id)[NSNull null])
                data.basic.clPlayerId = MakeStringCopy([playerResponse.playerBasic.clPlayerId UTF8String]);
            

			data.registered = [playerResponse.registered timeIntervalSince1970];
			data.lastLogin = [playerResponse.lastLogin timeIntervalSince1970];
			data.lastLogout = [playerResponse.lastLogout timeIntervalSince1970];

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