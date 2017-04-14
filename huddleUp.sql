--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: childuserteam_childid_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE childuserteam_childid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE childuserteam_childid_seq OWNER TO "Julie";

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: childuserteam; Type: TABLE; Schema: public; Owner: Julie
--

CREATE TABLE childuserteam (
    parent integer,
    teamid integer,
    childname character varying,
    childid integer DEFAULT nextval('childuserteam_childid_seq'::regclass) NOT NULL
);


ALTER TABLE childuserteam OWNER TO "Julie";

--
-- Name: ChildUserTeam_childId_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE "ChildUserTeam_childId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "ChildUserTeam_childId_seq" OWNER TO "Julie";

--
-- Name: ChildUserTeam_childId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Julie
--

ALTER SEQUENCE "ChildUserTeam_childId_seq" OWNED BY childuserteam.childid;


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE messages_id_seq OWNER TO "Julie";

--
-- Name: messages; Type: TABLE; Schema: public; Owner: Julie
--

CREATE TABLE messages (
    id integer DEFAULT nextval('messages_id_seq'::regclass) NOT NULL,
    sender integer,
    title character varying,
    message character varying,
    teamid integer,
    date date DEFAULT now(),
    "time" time without time zone DEFAULT now()
);


ALTER TABLE messages OWNER TO "Julie";

--
-- Name: Messages_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE "Messages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Messages_id_seq" OWNER TO "Julie";

--
-- Name: Messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Julie
--

ALTER SEQUENCE "Messages_id_seq" OWNED BY messages.id;


--
-- Name: Parent_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE "Parent_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Parent_id_seq" OWNER TO "Julie";

--
-- Name: team_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE team_id_seq OWNER TO "Julie";

--
-- Name: team; Type: TABLE; Schema: public; Owner: Julie
--

CREATE TABLE team (
    id integer DEFAULT nextval('team_id_seq'::regclass) NOT NULL,
    teamname character varying,
    coachid integer,
    astcoach character varying,
    teamcode character varying,
    description character varying
);


ALTER TABLE team OWNER TO "Julie";

--
-- Name: Team_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE "Team_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "Team_id_seq" OWNER TO "Julie";

--
-- Name: Team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Julie
--

ALTER SEQUENCE "Team_id_seq" OWNED BY team.id;


--
-- Name: parent_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE parent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE parent_id_seq OWNER TO "Julie";

--
-- Name: parent; Type: TABLE; Schema: public; Owner: Julie
--

CREATE TABLE parent (
    id integer DEFAULT nextval('parent_id_seq'::regclass) NOT NULL,
    firstname character varying,
    lastname character varying,
    cellphone character varying,
    homephone character varying,
    password character varying,
    email character varying
);


ALTER TABLE parent OWNER TO "Julie";

--
-- Name: User_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE "User_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "User_id_seq" OWNER TO "Julie";

--
-- Name: User_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Julie
--

ALTER SEQUENCE "User_id_seq" OWNED BY parent.id;


--
-- Name: childuserteam_childId_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE "childuserteam_childId_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "childuserteam_childId_seq" OWNER TO "Julie";

--
-- Name: events; Type: TABLE; Schema: public; Owner: Julie
--

CREATE TABLE events (
    id integer NOT NULL,
    title character varying,
    date date,
    starttime time without time zone,
    endtime time without time zone,
    location character varying,
    comment character varying,
    teamid integer
);


ALTER TABLE events OWNER TO "Julie";

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE events_id_seq OWNER TO "Julie";

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Julie
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: photo; Type: TABLE; Schema: public; Owner: Julie
--

CREATE TABLE photo (
    id integer NOT NULL,
    teamid integer,
    parentid integer,
    path character varying,
    title text,
    date date DEFAULT '2017-04-14'::date
);


ALTER TABLE photo OWNER TO "Julie";

--
-- Name: photo_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE photo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE photo_id_seq OWNER TO "Julie";

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: Julie
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE photos_id_seq OWNER TO "Julie";

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: Julie
--

ALTER SEQUENCE photos_id_seq OWNED BY photo.id;


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: photo id; Type: DEFAULT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY photo ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: ChildUserTeam_childId_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('"ChildUserTeam_childId_seq"', 1, false);


--
-- Name: Messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('"Messages_id_seq"', 1, false);


--
-- Name: Parent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('"Parent_id_seq"', 2, true);


--
-- Name: Team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('"Team_id_seq"', 1, false);


--
-- Name: User_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('"User_id_seq"', 1, false);


--
-- Data for Name: childuserteam; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY childuserteam (parent, teamid, childname, childid) FROM stdin;
5	2	Toby	1
7	9	James	7
7	2	Jill	6
5	7	John	2
5	8	Mark	9
7	8	Kim	8
5	2	Andrew	4
5	8	Tommy	3
7	9	Emma	5
6	8	Greg	12
5	8	Katie	10
5	8	Johny	13
5	9	Bryan	11
12	10	Kimberly	14
12	7	John	15
\.


--
-- Name: childuserteam_childId_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('"childuserteam_childId_seq"', 1, false);


--
-- Name: childuserteam_childid_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('childuserteam_childid_seq', 15, true);


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY events (id, title, date, starttime, endtime, location, comment, teamid) FROM stdin;
5	Game v. the Dr. Peppers	2017-04-25	10:00:00	12:00:00	Fullers Park	Game against the Dr. Peppers	9
4	Game v. the Chronics	2017-04-25	10:00:00	12:00:00	Fullers Park	Game against the Chronics	7
2	Match v. the Wildcats	2017-04-22	00:15:00	00:18:00	Cypress Field	Match against the Wildcats	2
11	Match v. Soccer Stars	2017-04-22	00:15:00	00:18:00	Cypress Field	Match against the Soccer Stars	10
12	Match v. the Dragons	2017-04-29	11:00:00	12:00:00	Cypress field	Game v. the dragons, see everyone Saturday	2
1	Pizza Party	2017-04-27	00:18:00	00:21:00	Kim Steel Residence	Come over to our house after the game! We'll have pizza and drinks for everyone.	2
13	Match against the Dr. Peppers	2017-05-13	09:00:00	11:00:00	Field 1	See everyone Saturday!	8
\.


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('events_id_seq', 13, true);


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY messages (id, sender, title, message, teamid, date, "time") FROM stdin;
1	5	Hello	Hi everyone! Looking forward to next weeks game!	2	2017-04-12	15:09:12.813268
5	6	Hey everyone	Looking forward to a great season! See everyone at the first game.	8	2017-04-12	15:30:41.314216
10	5	Great game	Everyone looked great out there! See you next week.	8	2017-04-13	11:21:46.795418
18	5	The best	The Chronics are the best team out there!	9	2017-04-13	15:31:00.837577
19	5	Saturday	Looking forward to the game!	7	2017-04-13	19:21:30.210483
20	7	Hi Everyone!	Looking forward to a great season!	7	2017-04-13	19:31:31.275532
\.


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('messages_id_seq', 20, true);


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY parent (id, firstname, lastname, cellphone, homephone, password, email) FROM stdin;
7	Bill	Gates	404-404-4044		$2a$10$aBuO/EclcyMTCyAo3SYTLuFcy8nCOKqHKAMEE2Eoa4zboc9GYxW5.	bgates@gmail.com
5	Julie	Dyer	504-616-9063		$2a$10$wD1iBV708R4M6bSiKqmyxO8at6oXexYy0LjZIHXcYC9y1u0uU62o6	juliemdyer@gmail.com
6	Toby	Ho	123-456-7890		$2a$10$Q8aRb8CHeAfARaoJTvZtauqBhDGasZXocrz4hie/2cyzkUamEJoMW	toby@gmail.com
8	John	Martin	123-123-1234		$2a$10$QuadJIx9lXZeF8bkv6WIcOruOQeodfU8ZJvP9uQ5GIG8zHsmwob3e	DDre@thechronic.com
9	John	Webster	504-172-3223		$2a$10$ZqXYzNUSA7J22C5B4pGEHOzF0CLjNB3/KGvgPG8cAdcsK1N.oQsCy	johnw@gmail.com
12	Tom	Jones	202-523-2352		$2a$10$vl9f9ITmR1wI7LuhuvoUFePtw8o8DLiLS3ij0DZLguITkI.MUOiOS	tomjones@gmail.com
13	Test	Test	202-123-2342	\N	email	Email
\.


--
-- Name: parent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('parent_id_seq', 13, true);


--
-- Data for Name: photo; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY photo (id, teamid, parentid, path, title, date) FROM stdin;
2	11	5	photos/file-1492178291795.jpeg	ball3.jpg	2017-04-14
3	11	5	photos/file-1492178453029.jpeg	ball4.jpg	2017-04-14
4	8	5	photos/file-1492179287333.jpeg	ball2.jpg	2017-04-14
5	8	5	photos/file-1492179296449.jpeg	ball5.jpg	2017-04-14
6	8	5	photos/file-1492179569734.jpeg	ball3.jpg	2017-04-14
7	8	5	photos/file-1492179657070.jpeg	ball6.jpg	2017-04-14
8	8	5	photos/file-1492179722713.jpeg	ball4.jpg	2017-04-14
\.


--
-- Name: photo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('photo_id_seq', 1, false);


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('photos_id_seq', 8, true);


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY team (id, teamname, coachid, astcoach, teamcode, description) FROM stdin;
8	The Dr. Peppers	5	Todd	1234	Atlanta Youth t-ball team
9	The Chronics	8	Snoop	QOI-RT-QXD	Atlanta Youth t-ball team
2	Soccer Stars	5	Todd	2390234	Atlanta Youth soccer team
10	The Wildcats	7	John	QOI-RT-QGF	Atlanta Youth soccer team
7	Jimminy Crickets	6	James	8675309	Atlanta Youth soccer team
11	Wildcats	5	Tom	HNB-RL-CAZ	Youth Soccer team
14	The Peaches	5	Tom Hanks	WUA-EL-YEV	Women's Baseball League
\.


--
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('team_id_seq', 16, true);


--
-- Name: childuserteam childuserteam_pkey; Type: CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY childuserteam
    ADD CONSTRAINT childuserteam_pkey PRIMARY KEY (childid);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: parent parent_email_key; Type: CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY parent
    ADD CONSTRAINT parent_email_key UNIQUE (email);


--
-- Name: parent parent_pkey; Type: CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY parent
    ADD CONSTRAINT parent_pkey PRIMARY KEY (id);


--
-- Name: photo photos_pkey; Type: CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY photo
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: team team_pkey; Type: CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- Name: childuserteam ChildUserTeam_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY childuserteam
    ADD CONSTRAINT "ChildUserTeam_parent_fkey" FOREIGN KEY (parent) REFERENCES parent(id);


--
-- Name: childuserteam ChildUserTeam_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY childuserteam
    ADD CONSTRAINT "ChildUserTeam_team_fkey" FOREIGN KEY (teamid) REFERENCES team(id);


--
-- Name: messages Messages_sender_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT "Messages_sender_fkey" FOREIGN KEY (sender) REFERENCES parent(id);


--
-- Name: messages Messages_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT "Messages_teamId_fkey" FOREIGN KEY (teamid) REFERENCES team(id);


--
-- Name: team Team_coach_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY team
    ADD CONSTRAINT "Team_coach_fkey" FOREIGN KEY (coachid) REFERENCES parent(id);


--
-- Name: events events_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY events
    ADD CONSTRAINT "events_teamId_fkey" FOREIGN KEY (teamid) REFERENCES team(id);


--
-- Name: photo photos_parentid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY photo
    ADD CONSTRAINT photos_parentid_fkey FOREIGN KEY (parentid) REFERENCES parent(id);


--
-- Name: photo photos_teamid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY photo
    ADD CONSTRAINT photos_teamid_fkey FOREIGN KEY (teamid) REFERENCES team(id);


--
-- PostgreSQL database dump complete
--

