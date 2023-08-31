# Database administration

# Users and roles

PostgreSQL uses users and roles for authentication and authorization purposes. The only difference between a user and a role is that the user can log in whereas the role is only used as a group for permissions. User _is_ a role and can be used as a group for permissions but let's not do that and have a clear separation between these two. Following are current users and roles:

*   `postgres` user is the administrator role that is only used for administrative tasks and not for daily database usage.
*   `hub_readonly` role is allowed to only read `hub_production` database tables.
*   `hub_backup` role is allowed only to read `hub_production` database tables and additionally access the `currval` value of sequences.
*   `hub_readwrite` role is allowed to read and write to `hub_production` database. Note that tasks such as installing an extension should be performed by a database administrator.
*   `hub_regular_backup` user has `hub_backup` role and is used for regular local backups.
*   `hub_application` user is used by the Hub website and has `hub_readwrite` role.
*   `hub_metabase` user is used by Metabase and has `hub_readonly` role.

Roles were set up based on [this article](https://aws.amazon.com/blogs/database/managing-postgresql-users-and-roles/) with modifications. Executed commands are as follows:

```sql
-- Read-only role
CREATE ROLE hub_readonly;
GRANT CONNECT ON DATABASE hub_production TO hub_readonly;
GRANT USAGE ON SCHEMA public TO hub_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO hub_readonly;

-- Backup role
CREATE ROLE hub_backup;
GRANT CONNECT ON DATABASE hub_production TO hub_backup;
GRANT USAGE ON SCHEMA public TO hub_backup;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO hub_backup;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO hub_backup;

-- Read/write role
CREATE ROLE hub_readwrite;
GRANT CONNECT, TEMPORARY ON DATABASE hub_production TO hub_readwrite;
GRANT USAGE, CREATE ON SCHEMA public TO hub_readwrite;
GRANT ALL ON ALL TABLES IN SCHEMA public TO hub_readwrite;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO hub_readwrite;

-- Users creation
CREATE USER hub_regular_backup WITH PASSWORD '***';
CREATE USER hub_metabase WITH PASSWORD '***';
CREATE USER hub_application WITH PASSWORD '***';

-- Grant privileges to users
GRANT hub_backup TO hub_regular_backup;
GRANT hub_readonly TO hub_metabase;
GRANT hub_readwrite TO hub_application;

-- For resetting stats in PgHero
CREATE EXTENSION pg_stat_statements;
GRANT EXECUTE ON FUNCTION pg_stat_statements_reset TO hub_application;

-- Revoke privileges from 'public' role
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE hub_production FROM PUBLIC;

-- Log in as hub_application
\c hub_production hub_application

-- Alter default privileges so that newly created objects played nicely with the
-- existing roles.
ALTER DEFAULT PRIVILEGES FOR ROLE hub_application IN SCHEMA public GRANT SELECT ON TABLES TO hub_readonly;
ALTER DEFAULT PRIVILEGES FOR ROLE hub_application IN SCHEMA public GRANT SELECT ON TABLES TO hub_backup;
ALTER DEFAULT PRIVILEGES FOR ROLE hub_application IN SCHEMA public GRANT SELECT ON SEQUENCES TO hub_backup;
ALTER DEFAULT PRIVILEGES FOR ROLE hub_application IN SCHEMA public GRANT ALL ON TABLES TO hub_readwrite;
ALTER DEFAULT PRIVILEGES FOR ROLE hub_application IN SCHEMA public GRANT USAGE ON SEQUENCES TO hub_readwrite;
```

There's a prefix `hub_` to each role and user, it is there to explicitly distinguish users and roles of `hub_production` database from any other users of future databases. This is a relatively small burden for future extensibility.

We only use schema `public` because so far there are no particular use cases where we would need schema division.

Passwords for users were generated using Ruby's `SecureRandom.alphanumeric(64)` .

## Ownership

Tables, views, types and sequences are objects that have an owner. The owner is capable of doing anything with these objects and does not really require a `hub_readwrite` role in order to manage such objects. In our application we create tables inside a migration and run it with the user used in the Hub application, so this user becomes an owner of all created objects. However we still need permissions for the Hub user to connect and access schema, in addition there are postgres managed views which we might have permissions to access.

Some objects were created using `postgres` account so we also change their ownership with these commands:

```sql
ALTER TABLE table_name OWNER TO hub_application;
ALTER VIEW view_name OWNER TO hub_application;
ALTER SEQUENCE sequence_name OWNER TO hub_application;
ALTERY TYPE type_or_enum_name OWNER TO hub_application;
```

## Caveats

There's no command to grant a privilege to ALL TYPES, every single type must be treated separately. So far there's no reason to grant USAGE (the only existing) privilege on types to `hub_readwrite` role and we can only limit ourselves with changing the owner of types to `hub_application` . But in the future we might need to do that.

## Passwords

Passwords for users are only stored where the users are used. The only stored password is master password for the `postgres` user which is stored on the local computer of the current database administrator. It is possible to change this password at any time in AWS RDS for anyone in the Administrators group. To change the password for a user, log in as a `postgres` user and issue this command:

```sql
ALTER USER user_name WITH PASSWORD 'new_password';
```

It is recommended to use Ruby's `SecureRandom.alphanumeric(64)` for password generation.

## How to test roles and privileges

Testing roles is hard because you can't drop them until all the granted privileges are revoked. And it quickly becomes tedious to do so: for every single `GRANT` there should be a corresponding `REVOKE` statement. So here is a simple way to test this:

  

1. Back up your current state of all databases in the cluster, optionally drop any users and databases before to make the dump smaller (mine is currently 920 KB):

```plain
pg_dumpall --clean > dumpall.sql
```

1. Experiment, for example, create a file that sets all the roles like above, use `\i` command to run it, perform manual testing as necessary.
2. Restore from the dump to the initial state which restores literally everything including roles, privileges and databases with all tables (note that there will be errors about dropping `postgres` role and dropping `postgres` database because they are used to connect to the database, they don't need to be dropped):

```plain
psql -f dumpall.sql -U postgres postgres
```

  

Note that upon restoring the newly created roles will stay but their permissions will disappear, so it is okay to see errors "role already exists".