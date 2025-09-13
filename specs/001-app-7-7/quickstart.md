# Quickstart Guide

This guide provides the steps to test the core functionality of the self-discipline app.

## Prerequisites

- A Flutter development environment is set up.
- The application is installed on a simulator or physical device.

## Testing Scenarios

### Scenario 1: Logging a Positive Behavior

1.  **Launch the app.**
2.  **Observe** the initial score is 0.
3.  **Tap** on a default positive behavior tag (e.g., "Read a book").
4.  **Verify** that the score updates to 1.
5.  **Tap** on another positive behavior tag.
6.  **Verify** that the score updates to 2.
7.  **Tap** on a third positive behavior tag.
8.  **Verify** that the score remains 2 (due to the daily limit).

### Scenario 2: Logging a Negative Behavior

1.  **Launch the app.**
2.  **Observe** the current score.
3.  **Tap** on a default negative behavior tag (e.g., "Ate junk food").
4.  **Verify** that the score decreases by 1.

### Scenario 3: Managing Behaviors

1.  **Navigate** to the "Manage Behaviors" screen.
2.  **Tap** the "Add New" button.
3.  **Enter** "Exercise" as the name and select "Positive" as the type.
4.  **Save** the new behavior.
5.  **Verify** that "Exercise" now appears on the homepage.
6.  **Tap** the "Exercise" tag on the homepage.
7.  **Verify** the score updates correctly.
8.  **Return** to the "Manage Behaviors" screen.
9.  **Delete** the "Exercise" behavior.
10. **Verify** that it is no longer visible on the homepage.

### Scenario 4: Setting a Reminder

1.  **Navigate** to the "Settings" screen.
2.  **Enable** reminders.
3.  **Set** the start time to 9:00 AM, end time to 5:00 PM, and frequency to 2 hours.
4.  **Save** the settings.
5.  **Verify** that a notification is received at the next scheduled interval (this may require adjusting the device time for testing).
