using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections;
using System.Runtime.InteropServices;
using AOT;

public class TestPlugin : MonoBehaviour {

	public Text debugText;

	private TestPlugin()
	{

	}

	// Use this for initialization
	void Start () {

		debugText.text = "Empty for now ...";

		if (!Application.isEditor)
		{
		#if UNITY_IOS

		debugText.text = "iOS";

		String versionText = "Playbasis Version is " + PlaybasisWrapper.version();

		Debug.Log(versionText);

		debugText.text = versionText;

		PlaybasisWrapper.auth("1012718250", "a52097fc5a17cb0d8631d20eacd2d9c2", "io.wasin.testplugin", OnAuthResult);
		
		#elif UNITY_ANDROID

		TestPlugin.sharedInstance().debugText.text = "Android";

		PlaybasisWrapper.init();
		PlaybasisWrapper.initPlaybasis();

		#endif
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnResultDelegate))]
	private void OnAuthResult(bool success)
	{
		if (success)
		{
			Debug.Log("OnAuthResult succeeded");
			ContinueFromAuth();
		}
		else
		{
			Debug.Log("OnAuthResult failed");
		}
	}

	private void ContinueFromAuth()
	{
		PlaybasisWrapper.playerPublic("jontestuser", OnPlayerPublicResult);	
	}

	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private void OnPlayerPublicResult(IntPtr result, int errorCode)
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.playerPublicWr pp = (PlaybasisWrapper.playerPublicWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.playerPublicWr));
			Debug.Log("Player FirstName: " + pp.basic.firstName);
			Debug.Log("Player Username: " + pp.basic.userName);
			Debug.Log("Player exp: " + pp.basic.exp);
			Debug.Log("Player LastName: " + pp.basic.lastName);
			Debug.Log("Player clPlayerId: " + pp.basic.clPlayerId);
			Debug.Log("Player registered: " + pp.registered);
			Debug.Log("Player lastLogin: " + pp.lastLogin);
			Debug.Log("Player lastLogout: " + pp.lastLogout);
		}
		else
		{
			Debug.Log("Error with errorCode " + errorCode);
		}
	}
}
