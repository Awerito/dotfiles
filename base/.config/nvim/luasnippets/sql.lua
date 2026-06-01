-- PostgreSQL snippets (LuaSnip).
-- Usage: type the prefix, <C-y> to expand, <C-l>/<C-h> to jump between fields.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	------------------------------------------------------------------ DML
	-- SELECT
	s(
		"sel",
		fmt(
			[[
SELECT {}
FROM {}
WHERE {};]],
			{ i(1, "*"), i(2, "table"), i(3, "condition") }
		)
	),

	-- SELECT with JOIN
	s(
		"selj",
		fmt(
			[[
SELECT {}
FROM {} a
JOIN {} b ON b.{} = a.{}
WHERE {};]],
			{ i(1, "*"), i(2, "table_a"), i(3, "table_b"), i(4, "a_id"), i(5, "id"), i(6, "condition") }
		)
	),

	-- SELECT with GROUP BY
	s(
		"selg",
		fmt(
			[[
SELECT {}, count(*)
FROM {}
GROUP BY {}
ORDER BY 2 DESC;]],
			{ i(1, "column"), i(2, "table"), i(3, "column") }
		)
	),

	-- INSERT
	s(
		"ins",
		fmt(
			[[
INSERT INTO {} ({})
VALUES ({});]],
			{ i(1, "table"), i(2, "columns"), i(3, "values") }
		)
	),

	-- UPSERT (INSERT ... ON CONFLICT)
	s(
		"upsert",
		fmt(
			[[
INSERT INTO {} ({})
VALUES ({})
ON CONFLICT ({}) DO UPDATE
SET {};]],
			{ i(1, "table"), i(2, "columns"), i(3, "values"), i(4, "unique_column"), i(5, "col = EXCLUDED.col") }
		)
	),

	-- UPDATE
	s(
		"upd",
		fmt(
			[[
UPDATE {}
SET {} = {}
WHERE {};]],
			{ i(1, "table"), i(2, "column"), i(3, "value"), i(4, "condition") }
		)
	),

	-- DELETE
	s(
		"del",
		fmt(
			[[
DELETE FROM {}
WHERE {};]],
			{ i(1, "table"), i(2, "condition") }
		)
	),

	-- CTE (WITH)
	s(
		"with",
		fmt(
			[[
WITH {} AS (
    {}
)
SELECT {}
FROM {};]],
			{ i(1, "cte"), i(2, "SELECT ..."), i(3, "*"), i(4, "cte") }
		)
	),

	------------------------------------------------------------------ DDL: tables
	-- CREATE TABLE
	s(
		"tbl",
		fmt(
			[[
CREATE TABLE {} (
    id SERIAL PRIMARY KEY,
    {}
);]],
			{ i(1, "name"), i(2, "column TYPE") }
		)
	),

	-- DROP TABLE
	s("droptbl", fmt("DROP TABLE IF EXISTS {};", { i(1, "table") })),

	-- TRUNCATE
	s("trunc", fmt("TRUNCATE TABLE {} RESTART IDENTITY CASCADE;", { i(1, "table") })),

	-- ALTER: add column
	s("altadd", fmt("ALTER TABLE {} ADD COLUMN {} {};", { i(1, "table"), i(2, "column"), i(3, "TYPE") })),

	-- ALTER: drop column
	s("altdrop", fmt("ALTER TABLE {} DROP COLUMN {};", { i(1, "table"), i(2, "column") })),

	-- ALTER: rename column
	s("altren", fmt("ALTER TABLE {} RENAME COLUMN {} TO {};", { i(1, "table"), i(2, "old"), i(3, "new") })),

	-- ALTER: change type
	s(
		"alttype",
		fmt(
			"ALTER TABLE {} ALTER COLUMN {} TYPE {} USING {}::{};",
			{ i(1, "table"), i(2, "column"), i(3, "TYPE"), i(4, "column"), i(5, "TYPE") }
		)
	),

	------------------------------------------------------------------ Constraints
	-- FOREIGN KEY
	s(
		"fk",
		fmt(
			"ALTER TABLE {} ADD CONSTRAINT {} FOREIGN KEY ({}) REFERENCES {} ({});",
			{ i(1, "table"), i(2, "fk_name"), i(3, "column"), i(4, "ref_table"), i(5, "id") }
		)
	),

	-- UNIQUE
	s("uniq", fmt("ALTER TABLE {} ADD CONSTRAINT {} UNIQUE ({});", { i(1, "table"), i(2, "uq_name"), i(3, "column") })),

	-- CHECK
	s(
		"check",
		fmt("ALTER TABLE {} ADD CONSTRAINT {} CHECK ({});", { i(1, "table"), i(2, "chk_name"), i(3, "condition") })
	),

	------------------------------------------------------------------ Indexes / views
	-- CREATE INDEX
	s("idx", fmt("CREATE INDEX {} ON {} ({});", { i(1, "idx_name"), i(2, "table"), i(3, "column") })),

	-- UNIQUE INDEX
	s("uidx", fmt("CREATE UNIQUE INDEX {} ON {} ({});", { i(1, "idx_name"), i(2, "table"), i(3, "column") })),

	-- CREATE VIEW
	s(
		"view",
		fmt(
			[[
CREATE VIEW {} AS
SELECT {}
FROM {};]],
			{ i(1, "name"), i(2, "*"), i(3, "table") }
		)
	),

	-- MATERIALIZED VIEW
	s(
		"mview",
		fmt(
			[[
CREATE MATERIALIZED VIEW {} AS
SELECT {}
FROM {};]],
			{ i(1, "name"), i(2, "*"), i(3, "table") }
		)
	),

	-- REFRESH MATERIALIZED VIEW
	s("refresh", fmt("REFRESH MATERIALIZED VIEW {};", { i(1, "name") })),

	------------------------------------------------------------------ Functions / triggers
	-- Plain function
	s(
		"fn",
		fmt(
			[[
CREATE OR REPLACE FUNCTION {}({})
RETURNS {} AS $$
BEGIN
    RETURN {};
END;
$$ LANGUAGE plpgsql;]],
			{ i(1, "name"), i(2, "param TYPE"), i(3, "TYPE"), i(4, "result") }
		)
	),

	-- Trigger function
	s(
		"trigfn",
		fmt(
			[[
CREATE OR REPLACE FUNCTION {}()
RETURNS TRIGGER AS $$
BEGIN
    {}
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;]],
			{ i(1, "name"), i(2, "-- logic") }
		)
	),

	-- Trigger (edit AFTER/BEFORE + event inline)
	s(
		"trig",
		fmt(
			[[
CREATE TRIGGER {}
{} ON {}
FOR EACH ROW
EXECUTE FUNCTION {}();]],
			{ i(1, "name"), i(2, "AFTER UPDATE"), i(3, "table"), i(4, "function") }
		)
	),

	-- DROP TRIGGER / FUNCTION
	s("droptrig", fmt("DROP TRIGGER IF EXISTS {} ON {};", { i(1, "trigger"), i(2, "table") })),
	s("dropfn", fmt("DROP FUNCTION IF EXISTS {}({});", { i(1, "function"), i(2, "") })),

	-- RAISE EXCEPTION
	s("raise", fmt("RAISE EXCEPTION '{}';", { i(1, "message") })),

	------------------------------------------------------------------ Transactions / misc
	-- Transaction block
	s(
		"tx",
		fmt(
			[[
BEGIN;
    {}
COMMIT;]],
			{ i(1, "-- statements") }
		)
	),

	-- CASE WHEN
	s(
		"case",
		fmt(
			[[
CASE WHEN {} THEN {}
     ELSE {}
END]],
			{ i(1, "condition"), i(2, "value"), i(3, "else_value") }
		)
	),

	-- COMMENT ON
	s("cmt", fmt("COMMENT ON {} {} IS '{}';", { i(1, "TABLE"), i(2, "object"), i(3, "description") })),

	-- CREATE SCHEMA
	s("sch", fmt("CREATE SCHEMA IF NOT EXISTS {};", { i(1, "name") })),
}
