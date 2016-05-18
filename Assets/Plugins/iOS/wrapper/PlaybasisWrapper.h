#include "PlaybasisResponsesWrapper.h"

#ifdef __cplusplus
extern "C" {
#endif

	/*
		Callback via result status
	*/
	typedef void (* OnResult)(bool);

	/*
		Callback via data.
		If data is null, then there's error thus you should check error integer.
		Otherwise, ignore error integer.

		User should manually cast returned opaque data to appropriate type.
	*/
	typedef void (* OnDataResult)(void*, int);

	/*
		List of fields and exposed methods from Playbasis class.
	*/
	const char* _version();
	const char* _token();

	void _auth(const char* apikey, const char* apisecret, const char* bundleId, OnResult callback);
	void _renew(const char* apikey, const char* apisecret, OnResult callback);
	void _playerPublic(const char* playerId, OnDataResult callback);
	void _player(const char* playerId, OnDataResult callback);

#ifdef __cplusplus
}
#endif