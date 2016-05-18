#include <string>

using std::string;

#ifdef __cplusplus
extern "C" {
#endif

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

#ifdef __cplusplus
}
#endif