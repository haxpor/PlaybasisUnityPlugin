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
		/** iOS **/
		#if UNITY_IOS

		debugText.text = "iOS";

		String versionText = "Playbasis Version is " + PlaybasisWrapper.version();

		Debug.Log(versionText);

		debugText.text = versionText;

		PlaybasisWrapper.auth("1012718250", "a52097fc5a17cb0d8631d20eacd2d9c2", "io.wasin.testplugin", OnAuthResult);
		
		/** ANDROID **/
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
	private void OnLogoutResult(bool success)
	{
		if (success)
		{
			Debug.Log("Logout succeeded");
		}
		else
		{
			Debug.Log("Logout failed");
		}
	}

	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnResultDelegate))]
	private void OnLoginResult(bool success)
	{
		if (success)
		{
			Debug.Log("Login succeeded");
		}
		else
		{
			Debug.Log("Login failed");
		}
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
		// Add test code calling api here ...
		PlaybasisWrapper.login("jontestuser", OnLoginResult);
		PlaybasisWrapper.playerPublic("jontestuser", OnPlayerPublicResult);
		PlaybasisWrapper.player("jontestuser", OnPlayerResult);
		PlaybasisWrapper.logout("jontestuser", OnLogoutResult);
		PlaybasisWrapper.pointOfPlayer("jontestuser", "point", OnPointOfPlayerResult);
	}

	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private void OnPlayerPublicResult(IntPtr result, int errorCode)
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.playerPublicWr pp = (PlaybasisWrapper.playerPublicWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.playerPublicWr));
			Debug.Log("PlayerPublic FirstName: " + pp.basic.firstName);
			Debug.Log("PlayerPublic Username: " + pp.basic.userName);
			Debug.Log("PlayerPublic exp: " + pp.basic.exp);
			Debug.Log("PlayerPublic LastName: " + pp.basic.lastName);
			Debug.Log("PlayerPublic clPlayerId: " + pp.basic.clPlayerId);
			Debug.Log("PlayerPublic registered: " + pp.registered);
			Debug.Log("PlayerPublic lastLogin: " + pp.lastLogin);
			Debug.Log("PlayerPublic lastLogout: " + pp.lastLogout);
		}
		else
		{
			Debug.Log("Error with errorCode " + errorCode);
		}
	}

	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private void OnPlayerResult(IntPtr result, int errorCode)
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.playerWr pp = (PlaybasisWrapper.playerWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.playerWr));
			Debug.Log("Player email " + pp.email);
			Debug.Log("Player phoneNumber " + pp.phoneNumber);
			Debug.Log("|_ PlayerPublic FirstName: " + pp.playerPublic.basic.firstName);
			Debug.Log("|_ PlayerPublic Username: " + pp.playerPublic.basic.userName);
			Debug.Log("|_ PlayerPublic exp: " + pp.playerPublic.basic.exp);
			Debug.Log("|_ PlayerPublic LastName: " + pp.playerPublic.basic.lastName);
			Debug.Log("|_ PlayerPublic clPlayerId: " + pp.playerPublic.basic.clPlayerId);
			Debug.Log("|_ PlayerPublic registered: " + pp.playerPublic.registered);
			Debug.Log("|_ PlayerPublic lastLogin: " + pp.playerPublic.lastLogin);
			Debug.Log("|_ PlayerPublic lastLogout: " + pp.playerPublic.lastLogout);
		}
		else
		{
			Debug.Log("player api error with code " + errorCode);
		}
	}

	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private void OnPointOfPlayerResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.pointRWr p = (PlaybasisWrapper.pointRWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.pointRWr));
			PlaybasisWrapper.pointWr[] data = p.pointArray.data;

			Debug.Log("PointOfPlayer count " + p.pointArray.count);
			Debug.Log("PointOfPlayer [0] " + data[0].rewardName);
		}
		else
		{
			Debug.Log("pointOfPlayer api error with code " + errorCode);
		}
	}
}
