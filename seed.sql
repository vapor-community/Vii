CREATE TABLE "public"."DemoTable" (
    "id" SERIAL,
    "name" text NOT NULL,
    "created_at" timestamp,
    PRIMARY KEY ("id")
);
CREATE TABLE "public"."another_table" (
    "id" SERIAL,
    "is_array" _char,
    "demo_id" int4,
    CONSTRAINT "another_table_demo_id_fkey" FOREIGN KEY ("demo_id") REFERENCES "public"."DemoTable"("id"),
    PRIMARY KEY ("id")
);