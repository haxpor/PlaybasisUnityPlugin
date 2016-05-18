#ifdef __cplusplus
extern "C" {
#endif

	static const int AUTH_API_TAG = 1;

	/*
		Callback data type
	*/
	typedef void (* OnResult)(_Bool);

	/*
		List of fields and exposed methods from Playbasis class.
	*/
	const char* _version();
	const char* _token();

	void _auth(const char* apikey, const char* apisecret, const char* bundleId, OnResult callback);
	void _renew(const char* apikey, const char* apisecret, OnResult callback);

#ifdef __cplusplus
}
#endif