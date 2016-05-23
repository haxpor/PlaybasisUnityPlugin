using UnityEngine;
using System;
using System.Collections;
using System.Runtime.InteropServices;
using AOT;

public class PlaybasisWrapper : MonoBehaviour {
	#if UNITY_ANDROID
	private static AndroidJavaClass javaUnityPlayer;
	private static AndroidJavaObject currentActivity;
	private static AndroidJavaObject playbasis = null;

	private PlaybasisWrapper()
	{

	}

	public static void init()
	{
		javaUnityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
		currentActivity = javaUnityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
		playbasis = new AndroidJavaObject("io.wasin.wrapper.playbasis.PlaybasisAndroidWrapper", currentActivity);
		Debug.Log("Initialized PlaybasisWrapper successfully");
	}

	public static void initPlaybasis()
	{
		// set up apikey and apisecret
		/*var builder = new AndroidJavaObject("com.playbasis.android.playbasissdk.core.Playbasis$Builder", currentActivity);
		builder.Call<AndroidJavaObject>("setApiKey", "2410120595");
		builder.Call<AndroidJavaObject>("setApiSecret", "0b98a945d6ba51153133767a14654c79");
		builder.Call<AndroidJavaObject>("build");*/

		//string version = playbasis.GetStatic<string>("SDK_VERSION");
		//Debug.Log("sdk version = " + version);

		playbasis.Call("getUserPublicInfo");
		playbasis.Call("login");
		playbasis.Call("like");

		Debug.Log("Initialized Playbasis instance succesfully");
	}

	#endif

	#if UNITY_IOS

	/* Interface to native implementations */
	public delegate void OnResultDelegate(bool success);
	public delegate void OnDataResultDelegate(IntPtr data, int errorCode);

	/*
		Playbasis classes
	*/
	[DllImport ("__Internal")]
	private static extern string _version();

	[DllImport ("__Internal")]
	private static extern void _auth(string apikey, string apisecret, string bundleId, OnResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _renew(string apikey, string apisecret, OnResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _login(string playerId, OnResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _logout(string playerId, OnResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _register(string playerId, string userName, string email, string imageUrl, OnResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _playerPublic(string playerId, OnDataResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _player(string playerId, OnDataResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _pointOfPlayer(string playerId, string pointName, OnDataResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _quizList(OnDataResultDelegate callack);

	[DllImport ("__Internal")]
	private static extern void _quizListOfPlayer(string playerId, OnDataResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _quizDetail(string quizId, string playerId, OnDataResultDelegate callback);

	[DllImport ("__Internal")]
	private static extern void _quizRandom(string playerId, OnDataResultDelegate callback);

	/*
		Structs
		- Arrays
	*/
	[StructLayout(LayoutKind.Sequential)]
	public struct pointArrayWr {
		public pointWr[] data;
		public int count;
	};
	
	[StructLayout(LayoutKind.Sequential)]
	public struct quizBasicArrayWr {
		public quizBasicWr[] data;
		public int count;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct gradeArrayWr {
		public gradeWr[] data;
		public int count;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct gradeRewardCustomArrayWr {
		public gradeRewardCustomWr[] data;
		public int count;
	};

	/*
		Structs
		-	Normal data model
	*/
	[StructLayout(LayoutKind.Sequential)]
	public struct playerBasisWr {
		public string image;
		public string userName;
		public uint exp;
		public uint level;
		public string firstName;
		public string lastName;
		public uint gender;
		public string clPlayerId;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct playerPublicWr {
		public playerBasisWr basic;
		public long registered;
		public long lastLogin;
		public long lastLogout;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct playerWr {
		public playerPublicWr playerPublic;
		public string email;
		public string phoneNumber;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct pointWr {
		public string rewardId;
		public string rewardName;
		public uint value;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct pointRWr {
		public pointArrayWr pointArray;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct quizBasicWr {
		public string name;
		public string image;
		public string weight;
		public string description_;
		public string descriptionImage;
		public string quizId;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct gradeRewardCustomWr {
		public string customId;
		public string customValue;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct gradeRewardsWr {
		public string expValue;
		public string pointValue;
		public gradeRewardCustomArrayWr gradeRewardCustomArray;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct gradeWr {
		public string gradeId;
		public string start;
		public string end;
		public string grade;
		public string rank;
		public string rankImage;
		public gradeRewardsWr rewards;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct quizWr {
		public quizBasicWr basic;
		public long dateStart;
		public long dateExpire;
		public bool status;
		public gradeArrayWr gradeArray;
		public bool deleted;
		public uint totalMaxScore;
		public uint totalQuestion;
	};

	[StructLayout(LayoutKind.Sequential)]
	public struct quizListWr {
		public quizBasicArrayWr quizBasicArray;
	};

	/*
		All implementation of api methods are non-blocking call, but synchronized call for Playbasis Platform.
	*/
	public static string version()
	{
		return _version();
	}

	public static void auth(string apikey, string apisecret, string bundleId, OnResultDelegate callback)
	{
		_auth(apikey, apisecret, bundleId, callback);
	}

	public static void renew(string apikey, string apisecret, OnResultDelegate callback)
	{
		_renew(apikey, apisecret, callback);
	}

	public static void login(string playerId, OnResultDelegate callback)
	{
		_login(playerId, callback);
	}

	public static void logout(string playerId, OnResultDelegate callback)
	{
		_logout(playerId, callback);
	}

	public static void register(string playerId, string userName, string email, string imageUrl, OnResultDelegate callback)
	{
		_register(playerId, userName, email, imageUrl, callback);
	}

	public static void playerPublic(string playerId, OnDataResultDelegate callback)
	{
		_playerPublic(playerId, callback);
	}

	public static void player(string playerId, OnDataResultDelegate callback)
	{
		_player(playerId, callback);
	}

	public static void pointOfPlayer(string playerId, string pointName, OnDataResultDelegate callback)
	{
		_pointOfPlayer(playerId, pointName, callback);
	}

	public static void quizList(OnDataResultDelegate callback)
	{
		_quizList(callback);
	}

	public static void quizListOfPlayer(string playerId, OnDataResultDelegate callback)
	{
		_quizListOfPlayer(playerId, callback);
	}

	public static void quizDetail(string quizId, string playerId, OnDataResultDelegate callback)
	{
		_quizDetail(quizId, playerId, callback);
	}

	public static void quizRandom(string playerId, OnDataResultDelegate callback)
	{
		_quizRandom(playerId, callback);
	}

	#endif
}