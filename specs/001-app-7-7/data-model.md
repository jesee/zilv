# Data Model

This document outlines the primary data entities for the self-discipline app.

## Entity: User

Represents the application user.

| Field         | Type    | Description                            | Constraints      |
|---------------|---------|----------------------------------------|------------------|
| `id`          | Integer | Unique identifier for the user.        | Primary Key      |
| `totalScore`  | Integer | The user's current cumulative score.   | Not Null, Default 0 |
| `dailyPoints` | Integer | Points earned today (for the 2-point limit). | Not Null, Default 0 |
| `lastPointDate`| Date   | The date the last point was awarded.   | Not Null         |


## Entity: Behavior

Represents a positive or negative habit the user is tracking.

| Field       | Type    | Description                             | Constraints      |
|-------------|---------|-----------------------------------------|------------------|
| `id`        | Integer | Unique identifier for the behavior.     | Primary Key      |
| `name`      | String  | The name of the behavior (e.g., "Read a book"). | Not Null, Unique |
| `type`      | Enum    | The type of behavior: `POSITIVE` or `NEGATIVE`. | Not Null         |
| `isDefault` | Boolean | Whether this is a default or user-created behavior. | Not Null, Default false |
| `isActive`  | Boolean | Whether the behavior is active and can be logged. | Not Null, Default true |


## Entity: LogEntry

Represents a record of a user performing a behavior.

| Field         | Type      | Description                               | Constraints      |
|---------------|-----------|-------------------------------------------|------------------|
| `id`          | Integer   | Unique identifier for the log entry.      | Primary Key      |
| `behaviorId`  | Integer   | Foreign key linking to the `Behavior` table. | Not Null         |
| `timestamp`   | DateTime  | The exact time the behavior was logged.   | Not Null         |
| `pointValue`  | Integer   | The point value of the log (+1 or -1).    | Not Null         |


## Entity: Reminder

Represents a scheduled notification for the user.

| Field       | Type    | Description                               | Constraints      |
|-------------|---------|-------------------------------------------|------------------|
| `id`        | Integer | Unique identifier for the reminder.       | Primary Key      |
| `startTime` | Time    | The time of day to start reminders.       | Not Null         |
| `endTime`   | Time    | The time of day to stop reminders.        | Not Null         |
| `frequency` | Integer | The interval in hours between reminders.  | Not Null         |
| `isEnabled` | Boolean | Whether the reminder is active.           | Not Null, Default true |

## Relationships

- A `User` can have many `LogEntry` records.
- A `Behavior` can be associated with many `LogEntry` records.
