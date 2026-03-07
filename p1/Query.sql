-- Problem 1, part b

--i
SELECT C.challenge_id, COUNT(DISTINCT TM.pid) as num_participants
FROM Challenge C LEFT JOIN Round R
    ON C.challenge_id = R.challenge_id
    AND R.round_name = 'Final'
LEFT JOIN Submission S
    ON S.round_id = R.round_id and S.challenge_id = R.challenge_id
LEFT JOIN TeamMember TM
    ON TM.team_id = S.team_id
GROUP BY C.challenge_id;

--ii
/*. Start with Submission, which has challenge id and round id, connect it to   */
WITH LatestSubmissions AS(
    SELECT team_id, challenge_id, round_id, MAX(submission_date) as latest_date
    FROM Submission
    GROUP BY team_id, challenge_id, round_id 
),
RoundScores AS (
    SELECT E.challenge_id, E.round_id, AVG(E.score) AS average_score
    FROM Submission S
    JOIN LatestSubmissions L
    ON S.team_id = L.team_id AND S.challenge_id = L.challenge_id AND S.round_id = L.round_id 
        AND S.submission_date = L.latest_date
    JOIN Evaluates E on 
        S.team_id = E.team_id AND S.challenge_id = E.challenge_id AND S.round_id = E.round_id
    GROUP BY E.challenge_id, E.round_id
    HAVING COUNT(DISTINCT S.team_id) > 3 --counting submissions, count(*) would've counted for evaluations by judges
)
SELECT challenge_id, round_id
FROM RoundScores
WHERE RoundScores.average_score = (SELECT MAX(average_score) FROM RoundScores);

--iii
WITH EveryRound AS(
    SELECT P.pid, P.participant_name
    FROM Participant P JOIN TeamMember TM 
    ON P.pid = TM.pid
    JOIN Submission S
    ON TM.team_id = S.team_id
    GROUP BY P.pid, P.participant_name, S.challenge_id
    HAVING COUNT(DISTINCT S.round_id) = ( --make sure the count for submissions is same as the number of rounds.
        SELECT COUNT(*) FROM Round R WHERE R.challenge_id = S.challenge_id --this is division in relational algebra!
    )
)
SELECT DISTINCT pid, participant_name FROM EveryRound;

-- iv
WITH MinScore AS(
    SELECT E.challenge_id, E.round_id, MIN(E.score) as min_score
    FROM Evaluates E
    GROUP BY E.challenge_id, E.round_id
)
SELECT MS.challenge_id, MS.round_id, J.judge_name, J.jid
FROM MinScore MS JOIN Evaluates E
ON E.score = MS.min_score AND E.round_id = MS.round_id AND E.challenge_id = MS.challenge_id
JOIN Judge J 
ON J.jid = E.jid;

-- v
WITH PairsParticipants AS(
    SELECT DISTINCT TM.pid, TM.team_id, S.challenge_id, S.round_id
    FROM TeamMember TM JOIN Submission S
    ON TM.team_id = S.team_id AND TM.challenge_id = S.challenge_id
)
SELECT P1.pid, P2.pid
FROM PairsParticipants P1 JOIN PairsParticipants P2
ON P1.challenge_id = P2.challenge_id
AND P1.round_id = P2.round_id
AND P1.team_id != P2.team_id
AND P1.pid < P2.pid --avoid duplicates 
GROUP BY P1.pid, P2.pid
HAVING COUNT(DISTINCT (P1.challenge_id,P1.round_id)) >= 3;

--vi
SELECT C.domain, COUNT(DISTINCT TM.pid)
FROM Challenge C JOIN TeamMember TM
ON C.challenge_id = TM.challenge_id
GROUP BY C.domain;

-- vii
SELECT DISTINCT P.pid, P.participant_name
FROM Participant P JOIN TeamMember TM
ON P.pid = TM.pid 
JOIN Leaderboard L 
ON TM.team_id = L.team_id AND TM.challenge_id = L.challenge_id
WHERE (P.skill_level = 'Beginner' OR P.skill_level = 'Intermediate') 
    AND L.rank <=3;


