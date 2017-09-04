-- 创建个人表
CREATE TABLE IF NOT EXISTS "T_Person" (
"id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
"name" text,
"age" integer,
"height" real
);

-- 创建图书表
CREATE TABLE IF NOT EXISTS "T_Book" (
"id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
"bookName" text
);
