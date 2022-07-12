CREATE TABLE users (
	id SERIAL NOT NULL PRIMARY KEY,
	email VARCHAR(50) NOT NULL,
	password VARCHAR(50) NOT NULL,
	name VARCHAR(50) NOT NULL,
	photo BLOB
);

CREATE TABLE groups (
	id SERIAL NOT NULL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	description TEXT NOT NULL
);

CREATE TABLE user_groups (
	user_id INTEGER NOT NULL,
	group_id INTEGER NOT NULL,

	PRIMARY KEY (user_id, group_id),
	CONSTRAINT fk_user_group FOREIGN KEY (user_id)
		REFERENCES users (id),
	CONSTRAINT fk_group_user FOREIGN KEY (group_id)
		REFERENCES groups (id)
);

CREATE TABLE quizes (
	id SERIAL NOT NULL PRIMARY KEY,
	description TEXT NOT NULL,
	max_attempts INTEGER NOT NULL,
	author_id INTEGER NOT NULL,
	creation_date TIMESTAMP NOT NULL
		DEFAULT TODAY(),
	end_date TIMESTAMP NOT NULL 
		CHECK (end_date > creation_date),

	CONSTRAINT fk_user_quiz FOREIGN KEY (author_id)
		REFERENCES users (id)
);

CREATE TABLE questions (
	id SERIAL NOT NULL,
	quiz_id INTEGER NOT NULL,
	type VARCHAR(16) NOT NULL,	-- TEXT, OPTI, ASSO
	description TEXT NOT NULL,
	correct_answer TEXT,		-- JSON
	options TEXT,				-- JSON

	PRIMARY KEY (id, quiz_id),
	CONSTRAINT fk_quest_quiz FOREIGN KEY (quiz_id)
		REFERENCES quiz (id)
);

CREATE TABLE attempts (
	user_id INTEGER NOT NULL,
	quiz_id INTEGER NOT NULL,
	num_attempt INTEGER NOT NULL,
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP,

	PRIMARY KEY (user_id, quiz_id, num_attempt),
	CONSTRAINT fk_user_attempt FOREIGN KEY (user_id)
		REFERENCES users (id),
	CONSTRAINT fk_quiz_attempt FOREIGN KEY (quiz_id)
		REFERENCES quiz (id)
);

CREATE TABLE attempts_questions (	
	user_id INTEGER NOT NULL,
	quiz_id INTEGER NOT NULL,
	num_attempt INTEGER NOT NULL,
	question_id INTEGER NOT NULL,
	answer TEXT NOT NULL,

	PRIMARY KEY (user_id, quiz_id, num_attempt, question_id),
	CONSTRAINT fk_user_att_quest FOREIGN KEY (user_id)
		REFERENCES users (id),
	CONSTRAINT fk_quiz_att_quest FOREIGN KEY (quiz_id)
		REFERENCES quiz (id),
	CONSTRAINT fk_att_quest FOREIGN KEY (question_id)
		REFERENCES questions (id)
);
