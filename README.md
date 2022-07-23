# imongo ORM

Schema-first mongoDB interface (inspired by [Mongoose](https://mongoosejs.com/)). Library serves as a thin wrapper around [PyMongo](!https://pymongo.readthedocs.io/en/stable/).

\
&nbsp;

## Why use imongo?

- Schema first API 😎
- Built-In on-write validation for insertions and updates ✅
- Last updated timestamp on every update for [Slowly changing dimensions](https://en.wikipedia.org/wiki/Slowly_changing_dimension)
- Support for nested schemas 🪢

\
&nbsp;

## Getting Started

### 1. Writing your first Model

```python
from imongo import Key
from imongo import Model
from imongo import Schema
from imongo import Types

EMAIL_REGEX = """(?:[a-z...""" # trimmed because of space

user_schema = Schema(
    {
        "name": Key(type=Types.String, required=True, min_length=5, max_length=50, lowercase=True),
        "email": Key(type=Types.String, required=True, regex=EMAIL_REGEX),
        "role": Key(type=Types.String, required=True, default=None, enum=["A", "B", None]),
        "details": {
            "last_visit": Key(type=Types.Date, required=False),
            "age": Key(type=Types.String, required=False),
        }
    },
    timestamps=True,
    validate=True,
)

User = Model("users", user_schema)
```

### 2. Connect with MongoDB and link imongo

```python
from pymongo import MongoClient
def connect_db(db_name: str = "helloworld") -> MongoClient:
    client = MongoClient("mongodb://root:example@localhost:27017")

    # register schemas
    User.register_client(client, db_name)

    return client
```

### 3. Use imongo through pyMongo operations

```python
connect_db("helloworld")

# Insert new user
new_user = User({"name": "Roberto", "email": "asd@google.com", "role": "A"})
res = User.insert_one(new_user)
new_user_id = res.inserted_id

# Fail to Update new user due to validation
res = User.update_one({"_id": new_user_id}, {"$set": {"name": "Rob"}})

# Find users
for user in User.find({"name": "roberto"}):
    print(user, "\n")

```

### Validation Config for Key

```python
required: bool = True                   #   Specify whether key is required
default: Union[Any, None] = None        #   Specify default value for key if value is not provided
enum: Union[List[Any], None] = None     #   Specify allowed values for key
immutable: bool = False                 #   Specify if value is immutable (i.e. it can't be altered after creation)
lowercase: bool = False                 #   Apply inline lowercase transformation (Types.String)
uppercase: bool = False                 #   Apply inline uppercase transformation (Types.String)
regex: str = None                       #   Regex match check against value (Types.String)
min: int = None                         #   Specify key's minimum value (Types.Integer, Types.Long, Types.Double)
max: int = None                         #   Specify key's maximum value (Types.Integer, Types.Long, Types.Double)
min_length: int = None                  #   Specify key's minimum length (Types.String)
max_length: int = None                  #   Specify key's minimum length (Types.String)
```
