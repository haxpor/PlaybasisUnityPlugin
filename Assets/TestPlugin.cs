using UnityEngine;
using UnityEngine.UI;
using System;
using System.Collections;
using System.Runtime.InteropServices;
using AOT;

public class TestPlugin : MonoBehaviour {

	public Text debugText;

	#if UNITY_IOS
	private static PlaybasisWrapper.playerWr playerInfo;
	private static PlaybasisWrapper.pointRWr playerPointRInfo;
	#endif

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
		if (Input.touchCount > 0 && Input.GetTouch(0).phase == TouchPhase.Began) {

            // check data returned from api
			Debug.Log("Player email " + playerInfo.email);
			Debug.Log("Player phoneNumber " + playerInfo.phoneNumber);
			Debug.Log("|_ PlayerPublic FirstName: " + playerInfo.playerPublic.basic.firstName);
			Debug.Log("|_ PlayerPublic Username: " + playerInfo.playerPublic.basic.userName);
			Debug.Log("|_ PlayerPublic exp: " + playerInfo.playerPublic.basic.exp);
			Debug.Log("|_ PlayerPublic LastName: " + playerInfo.playerPublic.basic.lastName);
			Debug.Log("|_ PlayerPublic clPlayerId: " + playerInfo.playerPublic.basic.clPlayerId);
			Debug.Log("|_ PlayerPublic registered: " + playerInfo.playerPublic.registered);
			Debug.Log("|_ PlayerPublic lastLogin: " + playerInfo.playerPublic.lastLogin);
			Debug.Log("|_ PlayerPublic lastLogout: " + playerInfo.playerPublic.lastLogout);

			Debug.Log("PointOfPlayer count " + playerPointRInfo.pointArray.count);
			Debug.Log("PointOfPlayer [0] " + playerPointRInfo.pointArray.data[0].rewardName);
        }
	}

	#if UNITY_IOS

	// logout()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnResultDelegate))]
	private static void OnLogoutResult(bool success)
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

	// login()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnResultDelegate))]
	private static void OnLoginResult(bool success)
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

	// auth()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnResultDelegate))]
	private static void OnAuthResult(bool success)
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

	private static void ContinueFromAuth()
	{
		// Add test code calling api here ...
		PlaybasisWrapper.login("jontestuser", OnLoginResult);
		//PlaybasisWrapper.playerPublic("jontestuser", OnPlayerPublicResult);
		PlaybasisWrapper.player("jontestuser", OnPlayerResult);
		PlaybasisWrapper.pointOfPlayer("jontestuser", "point", OnPointOfPlayerResult);
		PlaybasisWrapper.quizList(OnQuizListResult);
		PlaybasisWrapper.quizListOfPlayer("jontestuser", OnQuizListOfPlayerResult);
		PlaybasisWrapper.quizRandom("jontestuser", OnQuizRandomResult);
		PlaybasisWrapper.quizDoneList("jontestuser", 20, OnQuizDoneListResult);
		PlaybasisWrapper.quizPendingList("jontestuser", 20, OnQuizPendingListResult);

		//PlaybasisWrapper.logout("jontestuser", OnLogoutResult);
	}

	// playerPublic()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnPlayerPublicResult(IntPtr result, int errorCode)
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

	// player()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnPlayerResult(IntPtr result, int errorCode)
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.playerWr pp = (PlaybasisWrapper.playerWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.playerWr));

			// save response data for later use
			playerInfo = pp;

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

	// pointOfPlayer()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnPointOfPlayerResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.pointRWr pp = (PlaybasisWrapper.pointRWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.pointRWr));

			// save response data for later use
			playerPointRInfo = pp;

			Debug.Log("PointOfPlayer count " + pp.pointArray.count);
			Debug.Log("PointOfPlayer [0] " + pp.pointArray.data[0].rewardName);
		}
		else
		{
			Debug.Log("pointOfPlayer api error with code " + errorCode);
		}
	}

	// quizList()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnQuizListResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.quizListWr ql = (PlaybasisWrapper.quizListWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.quizListWr));

			Debug.Log("quizList count " + ql.quizBasicArray.count);
			if (ql.quizBasicArray.count > 0)
			{
				Debug.Log("  quizList[0] name " + ql.quizBasicArray.data[0].name);
				Debug.Log("  quizList[0] quizId " + ql.quizBasicArray.data[0].quizId);
			}
		}
		else
		{
			Debug.Log("quizList api error with code " + errorCode);
		}
	}

	// quizListOfPlayer()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnQuizListOfPlayerResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.quizListWr ql = (PlaybasisWrapper.quizListWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.quizListWr));

			Debug.Log("quizListOfPlayer count " + ql.quizBasicArray.count);
			if (ql.quizBasicArray.count > 0)
			{
				Debug.Log("  quizListOfPlayer[0] name " + ql.quizBasicArray.data[0].name);
				Debug.Log("  quizListOfPlayer[0] quizId " + ql.quizBasicArray.data[0].quizId);
			}
		}
		else
		{
			Debug.Log("quizListOfPlayer api error with code " + errorCode);
		}
	}

	// quizDetail()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnQuizDetailResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.quizWr q = (PlaybasisWrapper.quizWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.quizWr));

			Debug.Log("quizDetail name " + q.basic.name);
			Debug.Log("quizDetail quizId " + q.basic.quizId);
			Debug.Log("quizDetail dateStart " + q.dateStart);
			Debug.Log("quizDetail gradeArray count " + q.gradeArray.count);
			if (q.gradeArray.count > 0)
			{
				Debug.Log("quizDetail.gradeArray[0] gradeId " + q.gradeArray.data[0].gradeId);
				Debug.Log("quizDetail.gradeArray[0] rewards.expValue " + q.gradeArray.data[0].rewards.expValue);
				if (q.gradeArray.data[0].rewards.gradeRewardCustomArray.count > 0)
				{
					Debug.Log("quizDetail.gradeArray[0] rewards.gradeRewardCustomArray[0].customId " + q.gradeArray.data[0].rewards.gradeRewardCustomArray.data[0].customId);
				}
			}
		}
		else
		{
			Debug.Log("quizDetail api error with code " + errorCode);
		}
	}

	// quizRandom()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnQuizRandomResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.quizBasicWr q = (PlaybasisWrapper.quizBasicWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.quizBasicWr));

			Debug.Log("quizRandom success");
		}
		else
		{
			Debug.Log("quizRandom api error with code " + errorCode);
		}
	}

	// quizDone()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnQuizDoneListResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.quizDoneListWr q = (PlaybasisWrapper.quizDoneListWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.quizDoneListWr));

			Debug.Log("quizDone success");
		}
		else
		{
			Debug.Log("quizDone api error with code " + errorCode);
		}
	}

	// quizPendingList()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnQuizPendingListResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.quizPendingListWr q = (PlaybasisWrapper.quizPendingListWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.quizPendingListWr));

			Debug.Log("quizPendingList success");
		}
		else
		{
			Debug.Log("quizPendingList api error with code " + errorCode);
		}
	}

	// quizQuestion()
	[MonoPInvokeCallback(typeof(PlaybasisWrapper.OnDataResultDelegate))]
	private static void OnQuizQuestionResult(IntPtr result, int errorCode) 
	{
		if (result != IntPtr.Zero)
		{
			PlaybasisWrapper.questionWr q = (PlaybasisWrapper.questionWr)Marshal.PtrToStructure(result, typeof(PlaybasisWrapper.questionWr));

			Debug.Log("quizQuestion success");
		}
		else
		{
			Debug.Log("quizQuestion api error with code " + errorCode);
		}
	}

	#endif
}
