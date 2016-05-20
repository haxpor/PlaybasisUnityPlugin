#include <string>

using std::string;

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _array {
	void* data;
	int count;
} array;

typedef struct _playerBasic {
	char* image;
	char* userName;
	unsigned int exp;
	unsigned int level;
	char* firstName;
	char* lastName;
	unsigned int gender;
	char* clPlayerId;

	~_playerBasic()
	{
		if (image)
			delete image;
		if (userName)
			delete userName;
		if (firstName)
			delete firstName;
		if (lastName)
			delete lastName;
		if (clPlayerId)
			delete clPlayerId;
	}
} playerBasic;

typedef struct _playerPublic {
	playerBasic basic;
	time_t registered;
	time_t lastLogin;
	time_t lastLogout;
} playerPublic;

typedef struct _player {
	playerPublic playerPublic;
	char* email;
	char* phoneNumber;
} player;

typedef struct _point {
	char* rewardId;
	char* rewardName;
	unsigned int value;
} point;

typedef struct _pointR {
	array pointArray;
} pointR;

#ifdef __cplusplus
}
#endif