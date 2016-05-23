#import "PlaybasisWrapper.h"
#import "Playbasis.h" // your actual iOS library header
#import "Util.h"
#import "Populator.h"

// Populate struct data based on input response type
void PopulateData(pbResponseType type, PBBase_Response *response, void* outData)
{
	if (type == responseType_playerPublic)
	{
		PBPlayerPublic_Response* playerResponse = (PBPlayerPublic_Response*)response;

		playerPublic* data = (playerPublic*)outData;
		[Populator populatePlayerPublic:data from:playerResponse];
	}
	else if (type == responseType_player)
	{
		PBPlayer_Response* cr = (PBPlayer_Response*)response;

		player* data = (player*)outData;
		if (cr.playerPublic != nil)
		{
			PopulateData(responseType_playerPublic, cr.playerPublic, &(data->playerPublic));
		}

		if (CHECK_NOTNULL(cr.email))
		{
			data->email = MakeStringCopy([cr.email UTF8String]);
		}

		if (CHECK_NOTNULL(cr.phoneNumber))
		{
			data->phoneNumber = MakeStringCopy([cr.phoneNumber UTF8String]);
		}
	}
	else if (type == responseType_point)
	{
		PBPoint_Response* cr = (PBPoint_Response*)response;

		pointR* data = (pointR*)outData;
		if (cr.point != nil && [cr.point count] > 0)
		{
			point *items = new point[[cr.point count]];
			int i=0;

			for (PBPoint* pt in cr.point)
			{
				if (pt != nil)
				{
					if (CHECK_NOTNULL(pt.rewardId))
					{
						items[i].rewardId = MakeStringCopy([pt.rewardId UTF8String]);
					}

					if (CHECK_NOTNULL(pt.rewardName))
					{
						items[i].rewardName = MakeStringCopy([pt.rewardName UTF8String]);
					}

					items[i].value = pt.value;
					i++;
				}
			}

			// set result to data
			data->pointArray.data = (point*)items;
			data->pointArray.count = i;
		}
	}
	else if (type == responseType_activeQuizList)
	{
		PBActiveQuizList_Response* cr = (PBActiveQuizList_Response*)response;

		quizList* data = (quizList*)outData;
		if (cr.list != nil)
		{
			if (cr.list.quizBasics != nil && [cr.list.quizBasics count] > 0)
			{
				const int itemsCount = [cr.list.quizBasics count];
				quizBasic *items = new quizBasic[itemsCount];
				int i=0;

				for (PBQuizBasic* element in cr.list.quizBasics)
				{
					if (element != nil)
					{
						if (CHECK_NOTNULL(element.name))
						{
							items[i].name = MakeStringCopy([element.name UTF8String]);
						}

						if (CHECK_NOTNULL(element.image))
						{
							items[i].image = MakeStringCopy([element.image UTF8String]);
						}

						if (CHECK_NOTNULL(element.weight))
						{
							items[i].weight = MakeStringCopy([element.weight UTF8String]);
						}

						if (CHECK_NOTNULL(element.description_))
						{
							items[i].description_ = MakeStringCopy([element.description_ UTF8String]);
						}

						if (CHECK_NOTNULL(element.descriptionImage))
						{
							items[i].descriptionImage = MakeStringCopy([element.descriptionImage UTF8String]);
						}

						if (CHECK_NOTNULL(element.quizId))
						{
							items[i].quizId = MakeStringCopy([element.quizId UTF8String]);
						}

						i++;
					}
				}

				data->quizBasicArray.data = (quizBasic*)items;
				data->quizBasicArray.count = i;
			}
		}
	}
	else if (type == responseType_quizDetail)
	{
		PBQuizDetail_Response* cr = (PBQuizDetail_Response*)response;

		quiz* data = (quiz*)outData;
		if (cr.quiz != nil)
		{
			if (CHECK_NOTNULL(cr.quiz.basic))
			{
				// quizBasic
				PBQuizBasic *basic = cr.quiz.basic;
				if (CHECK_NOTNULL(basic.name))
				{
					data->basic.name = MakeStringCopy([basic.name UTF8String]);
				}

				if (CHECK_NOTNULL(basic.image))
				{
					data->basic.image = MakeStringCopy([basic.image UTF8String]);
				}

				if (CHECK_NOTNULL(basic.weight))
				{
					data->basic.weight = MakeStringCopy([basic.weight UTF8String]);
				}

				if (CHECK_NOTNULL(basic.description_))
				{
					data->basic.description_ = MakeStringCopy([basic.description_ UTF8String]);
				}

				if (CHECK_NOTNULL(basic.descriptionImage))
				{
					data->basic.descriptionImage = MakeStringCopy([basic.descriptionImage UTF8String]);
				}

				if (CHECK_NOTNULL(basic.quizId))
				{
					data->basic.quizId = MakeStringCopy([basic.quizId UTF8String]);
				}
			}

			data->dateStart = [cr.quiz.dateStart timeIntervalSince1970];
			data->dateExpire = [cr.quiz.dateExpire timeIntervalSince1970];
			data->status = cr.quiz.status;

			// grades
			if (CHECK_NOTNULL(cr.quiz.grades))
			{
				if ([cr.quiz.grades.grades count] > 0)
				{
					const int itemsCount = [cr.quiz.grades.grades count];
					grade *gs = new grade[itemsCount];
					int i=0;

					for (PBGrade *grade in cr.quiz.grades.grades)
					{
						if (grade != nil)
						{
							if (CHECK_NOTNULL(grade.gradeId))
							{
								gs[i].gradeId = MakeStringCopy([grade.gradeId UTF8String]);
							}

							if (CHECK_NOTNULL(grade.start))
							{
								gs[i].start = MakeStringCopy([grade.start UTF8String]);
							}

							if (CHECK_NOTNULL(grade.end))
							{
								gs[i].start = MakeStringCopy([grade.end UTF8String]);
							}

							if (CHECK_NOTNULL(grade.grade))
							{
								gs[i].grade = MakeStringCopy([grade.grade UTF8String]);
							}

							if (CHECK_NOTNULL(grade.rank))
							{
								gs[i].rank = MakeStringCopy([grade.rank UTF8String]);
							}

							if (CHECK_NOTNULL(grade.rankImage))
							{
								gs[i].rankImage = MakeStringCopy([grade.rankImage UTF8String]);
							}

							// gradeRewards
							if (CHECK_NOTNULL(grade.rewards))
							{
								if (CHECK_NOTNULL(grade.rewards.expValue))
								{
									gs[i].rewards.expValue = MakeStringCopy([grade.rewards.expValue UTF8String]);
								}

								if (CHECK_NOTNULL(grade.rewards.pointValue))
								{
									gs[i].rewards.pointValue = MakeStringCopy([grade.rewards.pointValue UTF8String]);
								}

								if (CHECK_NOTNULL(grade.rewards.customList))
								{
									if (CHECK_NOTNULL(grade.rewards.customList.gradeRewardCustoms))
									{
										if ([grade.rewards.customList.gradeRewardCustoms count] > 0)
										{
											const int itemsCount2 = [grade.rewards.customList.gradeRewardCustoms count];
											gradeRewardCustom *grc = new gradeRewardCustom[itemsCount2];
											int k=0;

											for (PBGradeRewardCustom *gradeRewardCustom in grade.rewards.customList.gradeRewardCustoms)
											{
												if (CHECK_NOTNULL(gradeRewardCustom.customId))
												{
													grc[k].customId = MakeStringCopy([gradeRewardCustom.customId UTF8String]);
												}

												if (CHECK_NOTNULL(gradeRewardCustom.customValue))
												{
													grc[k].customValue = MakeStringCopy([gradeRewardCustom.customValue UTF8String]);
												}

												k++;
											}

											gs[i].rewards.gradeRewardCustomArray.data = (gradeRewardCustom*)grc;
											gs[i].rewards.gradeRewardCustomArray.count = k;
										}
									}
								}
							}

							i++;
						}
					}

					data->gradeArray.data = (grade*)gs;
					data->gradeArray.count = i;
				}
			}
		}
	}
	else if (type == responseType_quizRandom)
	{
		PBQuizRandom_Response* cr = (PBQuizRandom_Response*)response;

		quizBasic* data = (quizBasic*)outData;
		if (cr.randomQuiz != nil)
		{
			// PBQuizBasic
			PBQuizBasic *basic = cr.randomQuiz;
			if (CHECK_NOTNULL(basic.name))
			{
				data->name = MakeStringCopy([basic.name UTF8String]);
			}

			if (CHECK_NOTNULL(basic.image))
			{
				data->image = MakeStringCopy([basic.image UTF8String]);
			}

			if (CHECK_NOTNULL(basic.weight))
			{
				data->weight = MakeStringCopy([basic.weight UTF8String]);
			}

			if (CHECK_NOTNULL(basic.description_))
			{
				data->description_ = MakeStringCopy([basic.description_ UTF8String]);
			}

			if (CHECK_NOTNULL(basic.descriptionImage))
			{
				data->descriptionImage = MakeStringCopy([basic.descriptionImage UTF8String]);
			}

			if (CHECK_NOTNULL(basic.quizId))
			{
				data->quizId = MakeStringCopy([basic.quizId UTF8String]);
			}
		}
	}
	else if (type == responseType_quizDoneListByPlayer)
	{
		PBQuizDoneList_Response* cr = (PBQuizDoneList_Response*)response;

		quizDoneList* data = (quizDoneList*)outData;
		if (cr.list != nil)
		{
			if (cr.list.quizDones != nil)
			{
				if ([cr.list.quizDones count] > 0)
				{
					const int itemsCount = [cr.list.quizDones count];
					quizDone *qd = new quizDone[itemsCount];
					int i=0;

					for (PBQuizDone *element in cr.list.quizDones)
					{
						qd[i].value = element.value;

						// gradeDone
						if (element.grade != nil)
						{
							if (CHECK_NOTNULL(element.grade.gradeId))
							{
								qd[i].gradeDone.gradeId = MakeStringCopy([element.grade.gradeId UTF8String]);
							}

							if (CHECK_NOTNULL(element.grade.start))
							{
								qd[i].gradeDone.start = MakeStringCopy([element.grade.start UTF8String]);
							}

							if (CHECK_NOTNULL(element.grade.end))
							{
								qd[i].gradeDone.end = MakeStringCopy([element.grade.end UTF8String]);
							}

							if (CHECK_NOTNULL(element.grade.grade))
							{
								qd[i].gradeDone.grade = MakeStringCopy([element.grade.grade UTF8String]);
							}

							if (CHECK_NOTNULL(element.grade.rank))
							{
								qd[i].gradeDone.rank = MakeStringCopy([element.grade.rank UTF8String]);
							}

							if (CHECK_NOTNULL(element.grade.rankImage))
							{
								qd[i].gradeDone.rankImage = MakeStringCopy([element.grade.rankImage UTF8String]);
							}

							// gradeDoneRewardArray
							if (element.grade.rewards != nil)
							{
								if (element.grade.rewards.gradeDoneRewards != nil)
								{
									if ([element.grade.rewards.gradeDoneRewards count] > 0)
									{
										const int itemsCount2 = [element.grade.rewards.gradeDoneRewards count];
										gradeDoneReward *gdr = new gradeDoneReward[itemsCount2];
										int k=0;

										for (PBGradeDoneReward *e in element.grade.rewards.gradeDoneRewards)
										{
											if (CHECK_NOTNULL(e.eventType))
											{
												gdr[k].eventType = MakeStringCopy([e.eventType UTF8String]);
											}

											if (CHECK_NOTNULL(e.rewardType))
											{
												gdr[k].rewardType = MakeStringCopy([e.rewardType UTF8String]);
											}

											if (CHECK_NOTNULL(e.rewardId))
											{
												gdr[k].rewardId = MakeStringCopy([e.rewardId UTF8String]);
											}

											if (CHECK_NOTNULL(e.value))
											{
												gdr[k].value = MakeStringCopy([e.value UTF8String]);
											}

											k++;
										}

										qd[i].gradeDone.rewardArray.data = (gradeDoneReward*)gdr;
										qd[i].gradeDone.rewardArray.count = k;
									}
								}
							}

							qd[i].gradeDone.score = element.grade.score;

							if (CHECK_NOTNULL(element.grade.maxScore))
							{
								qd[i].gradeDone.maxScore = MakeStringCopy([element.grade.maxScore UTF8String]);
							}

							qd[i].gradeDone.totalScore = element.grade.totalScore;
							qd[i].gradeDone.totalMaxScore = element.grade.totalMaxScore;
						}

						qd[i].totalCompletedQuestion = element.totalCompletedQuestion;

						if (CHECK_NOTNULL(element.quizId))
						{
							qd[i].quizId = MakeStringCopy([element.quizId UTF8String]);
						}

						i++;
					}

					data->quizDoneArray.data = (quizDone*)qd;
					data->quizDoneArray.count = i;
				}
			}
		}
	}
	else if (type == responseType_quizPendingsByPlayer)
	{
		PBQuizPendings_Response* cr = (PBQuizPendings_Response*)response;

		quizPendingList* data = (quizPendingList*)outData;
		if (cr.quizPendings != nil)
		{
			if (cr.quizPendings.list != nil)
			{
				if ([cr.quizPendings.list count] > 0)
				{
					const int itemsCount = [cr.quizPendings.list count];
					quizPending *qps = new quizPending[itemsCount];
					int i=0;

					for (PBQuizPending *element in cr.quizPendings.list)
					{
						qps[i].value = element.value;

						// quizPendingGrade
						if (element.grade != nil)
						{
							PBQuizPendingGrade *pbQuizGrade = element.grade;

							qps[i].grade.score = pbQuizGrade.score;

							// quizPendingGradeRewardArray
							if (element.grade.rewards != nil)
							{
								if (element.grade.rewards.list != nil)
								{
									if ([element.grade.rewards.list count] > 0)
									{
										const int itemsCount2 = [element.grade.rewards.list count];
										quizPendingGradeReward *qpgr = new quizPendingGradeReward[itemsCount2];
										int k=0;

										for (PBQuizPendingGradeReward* element2 in element.grade.rewards.list)
										{
											if (CHECK_NOTNULL(element2.eventType))
											{
												qpgr[k].eventType = MakeStringCopy([element2.eventType UTF8String]);
											}

											if (CHECK_NOTNULL(element2.rewardType))
											{
												qpgr[k].rewardType = MakeStringCopy([element2.rewardType UTF8String]);
											}

											if (CHECK_NOTNULL(element2.rewardId))
											{
												qpgr[k].rewardId = MakeStringCopy([element2.rewardId UTF8String]);
											}

											if (CHECK_NOTNULL(element2.value))
											{
												qpgr[k].value = MakeStringCopy([element2.value UTF8String]);
											}

											k++;
										}

										qps[i].grade.quizPendingGradeRewardArray.data = (quizPendingGradeReward*)qpgr;
										qps[i].grade.quizPendingGradeRewardArray.count = k;
									}
								}
							}

							if (CHECK_NOTNULL(pbQuizGrade.maxScore))
							{
								qps[i].grade.maxScore = MakeStringCopy([pbQuizGrade.maxScore UTF8String]);
							}

							qps[i].grade.totalScore = pbQuizGrade.totalScore;
							qps[i].grade.totalMaxScore = pbQuizGrade.totalMaxScore;
						}

						qps[i].totalCompletedQuestions = element.totalCompletedQuestions;
						qps[i].totalPendingQuestions = element.totalPendingQuestions;

						if (CHECK_NOTNULL(element.quizId))
						{
							qps[i].quizId = MakeStringCopy([element.quizId UTF8String]);
						}

						i++;
					}

					data->quizPendingArray.data = (quizPending*)qps;
					data->quizPendingArray.count = i;
				}
			}
		}
	}
	else if (type == responseType_questionFromQuiz)
	{
		PBQuestion_Response* cr = (PBQuestion_Response*)response;

		question* data = (question*)outData;
		if (cr.question != nil)
		{
			PBQuestion *q = cr.question;

			if (CHECK_NOTNULL(q.question))
			{
				data->question = MakeStringCopy([q.question UTF8String]);
			}

			if (CHECK_NOTNULL(q.questionImage))
			{
				data->question = MakeStringCopy([q.questionImage UTF8String]);
			}

			if (q.options != nil && q.options.options != nil)
			{
				if ([q.options.options count] > 0)
				{
					const int itemsCount = [q.options.options count];
					questionOption *qo = new questionOption[itemsCount];
					int i=0;

					for (PBQuestionOption *option in q.options.options)
					{
						if (CHECK_NOTNULL(option.option))
						{
							qo[i].option = MakeStringCopy([option.option UTF8String]);
						}

						if (CHECK_NOTNULL(option.optionImage))
						{
							qo[i].optionImage = MakeStringCopy([option.optionImage UTF8String]);
						}

						if (CHECK_NOTNULL(option.optionId))
						{
							qo[i].optionId = MakeStringCopy([option.optionId UTF8String]);
						}

						i++;
					}

					data->optionArray.data = qo;
					data->optionArray.count = i;
				}
			}

			data->index = q.index;
			data->total = q.total;
			if (CHECK_NOTNULL(q.questionId))
			{
				data->questionId = MakeStringCopy([q.questionId UTF8String]);
			}
		}
	}
	else if (type == responseType_questionAnswered)
	{
		// TODO: Add this...
	}
}

/*
	Fields and methods exposed by Playbasis class.
*/
const char* _version() {
	return MakeStringCopy([[Playbasis version] UTF8String]);
}

const char* _token() {
	return MakeStringCopy([[Playbasis sharedPB].token UTF8String]);
}

void _auth(const char* apikey, const char* apisecret, const char* bundleId, OnResult callback) {
	[[Playbasis sharedPB] authWithApiKeyAsync:CreateNSString(apikey) apiSecret:CreateNSString(apisecret) bundleId:CreateNSString(bundleId) andBlock:^(PBAuth_Response *auth, NSURL *url, NSError *error) {
       	if (error == nil)
       	{
       		NSLog(@"%@", auth);

       		if (callback)
       		{
       			NSLog(@"Call callback(true) on auth()");
       			callback(true);
       		}
       	}
       	else
       	{
       		NSLog(@"Failed in calling auth()");

       		// callback with failure
       		if (callback)
       		{
       			NSLog(@"Call callback(false) on auth()");
       			callback(false);
       		}
       	}
    }];
}

void _renew(const char* apikey, const char* apisecret, OnResult callback) {
	[[Playbasis sharedPB] renewWithApiKeyAsync:CreateNSString(apikey) apiSecret:CreateNSString(apisecret) andBlock:^(PBAuth_Response* auth, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"%@", auth);

			if (callback)
			{
				callback(true);
			}
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _login(const char* playerId, OnResult callback)
{
	[[Playbasis sharedPB] loginPlayerAsync:CreateNSString(playerId) withBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"%@", result);

			if (callback)
			{
				callback(true);
			}
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _logout(const char* playerId, OnResult callback)
{
	[[Playbasis sharedPB] logoutPlayer:CreateNSString(playerId) withBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"%@", result);

			if (callback)
			{
				callback(true);
			}
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _register(const char* playerId, const char* userName, const char* email, const char* imageUrl, OnResult callback)
{
	[[Playbasis sharedPB] registerUserWithPlayerIdAsync:CreateNSString(playerId) username:CreateNSString(userName) email:CreateNSString(email) imageUrl:CreateNSString(imageUrl) andBlock:^(PBResultStatus_Response* result, NSURL* url, NSError *error) {
		if (error == nil)
		{
			NSLog(@"Registered a new user successfully.");

			callback(true);
		}
		else
		{
			if (callback)
			{
				callback(false);
			}
		}
	}];
}

void _playerPublic(const char* playerId, OnDataResult callback) {
	[[Playbasis sharedPB] playerPublicAsync:CreateNSString(playerId) withBlock:^(PBPlayerPublic_Response *playerResponse, NSURL *url, NSError *error) {
		if (error == nil)
		{
			playerPublic data;
			PopulateData(responseType_playerPublic, playerResponse, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _player(const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] playerAsync:CreateNSString(playerId) withBlock:^(PBPlayer_Response * p, NSURL *url, NSError *error) {
		if (error == nil)
		{
			player data;
			PopulateData(responseType_player, p, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _pointOfPlayer(const char* playerId, const char* pointName, OnDataResult callback)
{
	[[Playbasis sharedPB] pointOfPlayerAsync:CreateNSString(playerId) forPoint:CreateNSString(pointName) withBlock:^(PBPoint_Response * points, NSURL *url, NSError *error) {
		if (error == nil)
		{
            pointR data;
			PopulateData(responseType_point, points, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizList(OnDataResult callback)
{
	[[Playbasis sharedPB] quizListWithBlockAsync:^(PBActiveQuizList_Response * activeQuizList, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizList data;
			PopulateData(responseType_activeQuizList, activeQuizList, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizListOfPlayer(const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizListOfPlayerAsync:CreateNSString(playerId) withBlock:^(PBActiveQuizList_Response * activeQuizList, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizList data;
			PopulateData(responseType_activeQuizList, activeQuizList, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizDetail(const char* quizId, const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizDetailAsync:CreateNSString(quizId) forPlayer:CreateNSString(playerId) withBlock:^(PBQuizDetail_Response * quizDetail, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quiz data;
			PopulateData(responseType_quizDetail, quizDetail, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizRandom(const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizRandomForPlayerAsync:CreateNSString(playerId) withBlock:^(PBQuizRandom_Response * quizRandom, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizBasic data;
			PopulateData(responseType_quizRandom, quizRandom, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizDoneList(const char* playerId, int limit, OnDataResult callback)
{
	[[Playbasis sharedPB] quizDoneForPlayerAsync:CreateNSString(playerId) limit:limit withBlock:^(PBQuizDoneList_Response * qlist, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizDoneList data;
			PopulateData(responseType_quizDoneListByPlayer, qlist, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizPendingList(const char* playerId, int limit, OnDataResult callback)
{
	[[Playbasis sharedPB] quizPendingOfPlayerAsync:CreateNSString(playerId) limit:limit withBlock:^(PBQuizPendings_Response * response, NSURL *url, NSError *error) {
		if (error == nil)
		{
			quizPendingList data;
			PopulateData(responseType_quizPendingsByPlayer, response, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizQuestion(const char* quizId, const char* playerId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizQuestionAsync:CreateNSString(playerId) forPlayer:CreateNSString(playerId) withBlock:^(PBQuestion_Response * q, NSURL *url, NSError *error) {
		if (error == nil)
		{
			question data;
			PopulateData(responseType_questionFromQuiz, q, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}

void _quizAnswer(const char* quizId, const char* optionId, const char* playerId, const char* questionId, OnDataResult callback)
{
	[[Playbasis sharedPB] quizAnswerAsync:CreateNSString(quizId) optionId:CreateNSString(optionId) forPlayer:CreateNSString(playerId) ofQuestionId:CreateNSString(questionId) withBlock:^(PBQuestionAnswered_Response * q, NSURL *url, NSError *error) {
		if (error == nil)
		{
			questionAnswered data;
			PopulateData(responseType_questionAnswered, q, &data);

			if (callback)
			{
				callback((void*)&data, -1);
			}
		}
		else
		{
			if (callback)
			{
				callback(nil, (int)error.code);
			}
		}
	}];
}