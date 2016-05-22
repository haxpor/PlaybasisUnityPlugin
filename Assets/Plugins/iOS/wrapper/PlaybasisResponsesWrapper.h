#include <string>
#include <cstdlib>

using std::string;

template <typename T>
struct _array {
	T* data=NULL;
	int count;

	~_array()
	{
		if (data)
			delete[] data;
	}
};

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _playerBasic {
	char* image=NULL;
	char* userName=NULL;
	unsigned int exp;
	unsigned int level;
	char* firstName=NULL;
	char* lastName=NULL;
	unsigned int gender;
	char* clPlayerId=NULL;

	~_playerBasic()
	{
		if (image)
			free(image);
		if (userName)
			free(userName);
		if (firstName)
			free(firstName);
		if (lastName)
			free(lastName);
		if (clPlayerId)
			free(clPlayerId);
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
	char* email=NULL;
	char* phoneNumber=NULL;

	~_player()
	{
		if (email)
			free(email);
		if (phoneNumber)
			free(phoneNumber);
	}
} player;

typedef struct _point {
	char* rewardId=NULL;
	char* rewardName=NULL;
	unsigned int value;

	~_point()
	{
		if (rewardId)
            free(rewardId);
		if (rewardName)
			free(rewardName);
	}
} point;

typedef struct _pointR {
	_array<point> pointArray;
} pointR;

typedef struct _quizBasic {
	char* name;
	char* image;
	char* weight;
	char* description_;
	char* descriptionImage;
	char* quizId;

	~_quizBasic()
	{
		if (name)
			free(name);
		if (image)
			free(image);
		if (weight)
			free(weight);
		if (description_)
			free(description_);
		if (descriptionImage)
			free(descriptionImage);
		if (quizId)
			free(quizId);
	}
} quizBasic;

typedef struct _quizList {
	_array<quizBasic> quizBasicArray;
} quizList;

#ifdef __cplusplus
}
#endif