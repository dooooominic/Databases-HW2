CREATE TABLE Participant (
    pid INT PRIMARY KEY,
    participant_name TEXT NOT NULL,
    affiliation TEXT NOT NULL,
    skill_level TEXT NOT NULL,
    registration_year INT NOT NULL
);

CREATE TABLE Team(
    team_id INT PRIMARY KEY,
    team_name TEXT NOT NULL
);


CREATE TABLE Challenge(
    challenge_id INT PRIMARY KEY,
    title TEXT NOT NULL,
    domain TEXT NOT NULL,
    difficulty TEXT NOT NULL
);

CREATE TABLE Judge(
    jid INT PRIMARY KEY,
    judge_name TEXT NOT NULL
);

CREATE TABLE TeamMember(
    pid INT NOT NULL,
    team_id INT NOT NULL,
    role TEXT NOT NULL,
    
    FOREIGN KEY (pid) REFERENCES Participant(pid),
    FOREIGN KEY (team_id) REFERENCES Team(team_id),
    PRIMARY KEY (pid, team_id)
);

CREATE TABLE Round(
    challenge_id INT NOT NULL,
    round_id INT NOT NULL,
    round_name TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    PRIMARY KEY (challenge_id, round_id),
    FOREIGN KEY (challenge_id) REFERENCES Challenge(challenge_id)
);

CREATE TABLE Submission(
    team_id INT NOT NULL,
    challenge_id INT NOT NULL,
    round_id INT NOT NULL,
    submission_date DATE NOT NULL,
    model_type TEXT NOT NULL,
    PRIMARY KEY (team_id, challenge_id, round_id, submission_date),
    FOREIGN KEY (team_id) REFERENCES Team(team_id),
    FOREIGN KEY (challenge_id, round_id) REFERENCES Round(challenge_id, round_id) 
);

CREATE TABLE Evaluates(
    jid INT NOT NULL,
    challenge_id INT NOT NULL,
    round_id INT NOT NULL,
    team_id INT NOT NULL,
    score INT NOT NULL,
    PRIMARY KEY (jid, challenge_id, round_id, team_id),
    FOREIGN KEY (jid) REFERENCES Judge(jid),
    FOREIGN KEY (team_id) REFERENCES Team(team_id),
    FOREIGN KEY (challenge_id, round_id) REFERENCES Round(challenge_id, round_id)
);

CREATE TABLE Leaderboard(
    challenge_id INT NOT NULL,
    team_id INT NOT NULL,
    rank INT NOT NULL,
    c_score DECIMAL NOT NULL,
    PRIMARY KEY (challenge_id, team_id),
    FOREIGN KEY (challenge_id) REFERENCES Challenge(challenge_id),
    FOREIGN KEY (team_id) REFERENCES Team(team_id)
);
