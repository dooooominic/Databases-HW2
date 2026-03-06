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
SELECT 
FROM 
