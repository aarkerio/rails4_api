-- rails4api Tables
-- Chipotle Software (c) 2015

-- rails g scaffold Group name:string description:string
CREATE TABLE groups (
  "id" serial PRIMARY KEY,
  "name" varchar(50) NOT NULL UNIQUE,
  "description" varchar(150) NOT NULL
);

-- Users
-- rails g scaffold User fname:string lname:string uname:string email:string  passwd:string active:boolean group:references
CREATE TABLE users (
    "id" serial PRIMARY KEY,
    "uname" varchar(50) NOT NULL UNIQUE, --login
    "passwd"  varchar(36)  NOT NULL,
    "fname"  varchar(70)  NOT NULL,           --real name
    "lname"  varchar(70)  NOT NULL,           --real name
    -- "email"  varchar(45)  NOT NULL UNIQUE,    -- this column is currently dropped in order to use devise
    "group_id" integer NOT NULL,                                                     -- Admin, normal user
    "created" timestamp(0) with time zone DEFAULT now() NOT NULL
);
