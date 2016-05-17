#ifdef __cplusplus
extern "C" {
#endif

	//#define DLL __declspec(dllexport)
	#define DLL

	static const int AUTH_API_TAG = 1;

	/*
		Callback data type
	*/
	typedef void (* OnResult)(bool);

	/*
		List of fields and exposed methods from Playbasis class.
	*/
	const char* _version();
	const char* _token();

	DLL void _auth(const char* apikey, const char* apisecret, const char* bundleId, OnResult callback);

#ifdef __cplusplus
}
#endif