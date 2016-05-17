#ifdef __cplusplus

extern "C" {
	int _getOne();
	const char* _version();

	void _auth(const char* apikey, const char* apisecret, const char* bundleId);
}

#endif