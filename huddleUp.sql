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
-- Name: events id; Type: DEFAULT; Schema: public; Owner: Julie
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


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
\.


--
-- Name: childuserteam_childId_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('"childuserteam_childId_seq"', 1, false);


--
-- Name: childuserteam_childid_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('childuserteam_childid_seq', 13, true);


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY events (id, title, date, starttime, endtime, location, comment, teamid) FROM stdin;
1	Pizza Party	2017-04-22	00:18:00	00:21:00	Kim Steel Residence	Come over to our house after the game! We'll have pizza and drinks for everyone.	2
5	Game v. the Dr. Peppers	2017-04-25	10:00:00	12:00:00	Fullers Park	Game against the Dr. Peppers	9
4	Game v. the Chronics	2017-04-25	10:00:00	12:00:00	Fullers Park	Game against the Chronics	7
2	Match v. the Wildcats	2017-04-22	00:15:00	00:18:00	Cypress Field	Match against the Wildcats	2
11	Match v. Soccer Stars	2017-04-22	00:15:00	00:18:00	Cypress Field	Match against the Soccer Stars	10
\.


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('events_id_seq', 11, true);


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY messages (id, sender, title, message, teamid, date, "time") FROM stdin;
1	5	Hello	Hi everyone! Looking forward to next weeks game!	2	2017-04-12	15:09:12.813268
5	6	Hey everyone	Looking forward to a great season! See everyone at the first game.	8	2017-04-12	15:30:41.314216
\.


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('messages_id_seq', 9, true);


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY parent (id, firstname, lastname, cellphone, homephone, password, email) FROM stdin;
7	Bill	Gates	404-404-4044		$2a$10$aBuO/EclcyMTCyAo3SYTLuFcy8nCOKqHKAMEE2Eoa4zboc9GYxW5.	bgates@gmail.com
5	Julie	Dyer	504-616-9063		$2a$10$wD1iBV708R4M6bSiKqmyxO8at6oXexYy0LjZIHXcYC9y1u0uU62o6	juliemdyer@gmail.com
6	Toby	Ho	123-456-7890		$2a$10$Q8aRb8CHeAfARaoJTvZtauqBhDGasZXocrz4hie/2cyzkUamEJoMW	toby@gmail.com
8	John	Martin	123-123-1234		$2a$10$QuadJIx9lXZeF8bkv6WIcOruOQeodfU8ZJvP9uQ5GIG8zHsmwob3e	DDre@thechronic.com
\.


--
-- Name: parent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('parent_id_seq', 8, true);


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: Julie
--

COPY team (id, teamname, coachid, astcoach, teamcode, description) FROM stdin;
8	The Dr. Peppers	5	Todd	1234	Atlanta Youth t-ball team
9	The Chronics	8	Snoop	QOI-RT-QXD	Atlanta Youth t-ball team
2	Soccer Stars	5	Todd	2390234	Atlanta Youth soccer team
10	The Wildcats	7	John	QOI-RT-QGF	Atlanta Youth soccer team
7	Jimminy Crickets	6	James	8675309	Atlanta Youth soccer team
\.


--
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: Julie
--

SELECT pg_catalog.setval('team_id_seq', 10, true);


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
-- PostgreSQL database dump complete
--

