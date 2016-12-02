# The Test assignment

1). Provide 2 http endpoints that accepts JSON base64 encoded binary data on both endpoints
    - <host>/v1/diff/<ID>/left and <host>/v1/diff/<ID>/right
2). The provided data needs to be diff-ed and the results shall be available on a third end point
    - <host>/v1/diff/<ID>
3). The results shall provide the following info in JSON format
    - If equal return that
    - If not of equal size just return that
    - If of same size provide insight in where the diffs are, actual diffs are not needed.
      - So mainly offsets + length in the data
4). Make assumptions in the implementation explicit, choices are good but need to be communicated

Explanations of the project are below.


# Project "ruby_jsons_comparison"

Application for comparing JSONs base64 encoded binary data.

This application has one endpoint for storing the left content to be compared by POST
```
<host>/v1/diff/<ID>/left
```

The second endpoint is for storing the right content to be compared by POST
```
<host>/v1/diff/<ID>/right
```

And the third endpoint is for retrieving the diff results by GET
```
<host>/v1/diff/<ID>
```

---
# Preparation steps

### Installing dependencies

Go to project's folder and run:
> bundle install

Use Rails generator to generate all structure:
> rails generate controller v1/diffs left right show

Install/generate RSpec structure:
> rails generate rspec:install

and all other stuff.

### Creating database structure

Create DB:
> rake db:create

then just:
> rake db:migrate


---
# Running the test suite

Prepare DB for tests:
> rake db:test:prepare

The tests written for this application could be run by the command below. The unit tests are placed in the spec/models/v1 directory. The integration tests are located in the spec/controllers/v1 directory.
> bundle exec rspec

Output of running tests looks like:
```
V1::DiffsController
  POST #left
    Returns success
  POST #right
    Returns success
  GET #show
    Left or Right aren't provided yet
    Left and Right are equaled
    Left and Right have different sizes
    Returns diff result

V1::Diff
  .jsons_comparison
    Left or Right aren't provided yet
    Left and Right are equaled
    Left and Right have different sizes
    Returns diff result

Finished in 0.10484 seconds (files took 1.35 seconds to load)
10 examples, 0 failures
```

---
# Running the application

Use this command in the next opened terminal window to launch rails server on 3003 port:
> rails s -p 3003


---
# Usage

After the rails server is started, you will be able to send requests to the diffs API. In the root directory of this project, there are two JSON base64 encoded binary data files (left.json and right.json) that can be used as samples for the following tests:

### Posting left content to be compared
> curl -X POST --data-binary "@left.json" http://localhost:3003/v1/diff/1/left

Output on server side will be:
```
Started POST "/v1/diff/1/left" for ::1 at 2016-12-02 18:25:17 +0100
  ActiveRecord::SchemaMigration Load (0.1ms)  SELECT "schema_migrations".* FROM "schema_migrations"
Processing by V1::DiffsController#left as */*
  Parameters: {"eyJjYXIiOiJuaXNzYW4ifQ"=>"=\n", "id"=>"1"}
  V1::Diff Load (0.1ms)  SELECT  "v1_diffs".* FROM "v1_diffs" WHERE "v1_diffs"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
   (0.1ms)  begin transaction
   (0.0ms)  commit transaction
Completed 200 OK in 21ms (ActiveRecord: 0.7ms)
```

### Posting right content to be compared
> curl -X POST --data-binary "@right.json" http://localhost:3003/v1/diff/1/right

Output on server side will be:
```
Started POST "/v1/diff/1/right" for ::1 at 2016-12-02 18:25:39 +0100
Processing by V1::DiffsController#right as */*
  Parameters: {"eyJjdXIiOiJuaXNzdW4ifQ"=>"=\n", "id"=>"1"}
  V1::Diff Load (0.1ms)  SELECT  "v1_diffs".* FROM "v1_diffs" WHERE "v1_diffs"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
   (0.1ms)  begin transaction
   (0.1ms)  commit transaction
Completed 200 OK in 4ms (ActiveRecord: 0.4ms)
```

### Obtaining diff results
> curl -X GET http://localhost:3003/v1/diff/1

Output on server side will be:
```
Started GET "/v1/diff/1" for ::1 at 2016-12-02 18:25:49 +0100
Processing by V1::DiffsController#show as */*
  Parameters: {"id"=>"1"}
  V1::Diff Load (0.1ms)  SELECT  "v1_diffs".* FROM "v1_diffs" WHERE "v1_diffs"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
Completed 200 OK in 2ms (Views: 0.4ms | ActiveRecord: 0.1ms)
```

Some examples of possible returns while obtaining diff results:
```
{"jsons_comparison":"Left or Right aren't provided yet"}
{"jsons_comparison":"Left and Right are equaled"}
{"jsons_comparison":"Left and Right have different sizes"}
{"jsons_comparison_result":[{"offset":3,"length":1},{"offset":12,"length":1}]}
```
