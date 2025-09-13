# Feature Specification: Self-Discipline Point System App

**Feature Branch**: `001-app-7-7`  
**Created**: 2025-09-13  
**Status**: Draft  
**Input**: User description: "我想创建一款自律app，以积分作为媒介，正面行为增加积分，负面行为扣除积分，每天最多增加两点积分，每天扣除的积分无下限，完成正面行为增加一点积分，负面扣除一点积分，提供默认正面行为/负面行为，可新增编辑删除行为，可以设置提醒用户进行反馈做了正负行为，可以设置时间段次数，比如：在每天早上7点到晚上7点每3小时提醒一次，进入app在主页点击相应的正负行为标签即可签到正负面行为"

## Execution Flow (main)
```
1. Parse user description from Input
   → If empty: ERROR "No feature description provided"
2. Extract key concepts from description
   → Identify: actors, actions, data, constraints
3. For each unclear aspect:
   → Mark with [NEEDS CLARIFICATION: specific question]
4. Fill User Scenarios & Testing section
   → If no clear user flow: ERROR "Cannot determine user scenarios"
5. Generate Functional Requirements
   → Each requirement must be testable
   → Mark ambiguous requirements
6. Identify Key Entities (if data involved)
7. Run Review Checklist
   → If any [NEEDS CLARIFICATION]: WARN "Spec has uncertainties"
   → If implementation details found: ERROR "Remove tech details"
8. Return: SUCCESS (spec ready for planning)
```

---

## ⚡ Quick Guidelines
- ✅ Focus on WHAT users need and WHY
- ❌ Avoid HOW to implement (no tech stack, APIs, code structure)
- 👥 Written for business stakeholders, not developers

### Section Requirements
- **Mandatory sections**: Must be completed for every feature
- **Optional sections**: Include only when relevant to the feature
- When a section doesn't apply, remove it entirely (don't leave as "N/A")

### For AI Generation
When creating this spec from a user prompt:
1. **Mark all ambiguities**: Use [NEEDS CLARIFICATION: specific question] for any assumption you'd need to make
2. **Don't guess**: If the prompt doesn't specify something (e.g., "login system" without auth method), mark it
3. **Think like a tester**: Every vague requirement should fail the "testable and unambiguous" checklist item
4. **Common underspecified areas**:
   - User types and permissions
   - Data retention/deletion policies  
   - Performance targets and scale
   - Error handling behaviors
   - Integration requirements
   - Security/compliance needs

---

## User Scenarios & Testing *(mandatory)*

### Primary User Story
As a user, I want to track my positive and negative daily habits using a point system so that I can build self-discipline. I want the app to remind me to log my actions, and I want to be able to easily record them on the main screen.

### Acceptance Scenarios
1. **Given** a user has performed a positive action, **When** they tap the corresponding positive behavior tag on the homepage, **Then** their score increases by 1 point.
2. **Given** a user has performed a negative action, **When** they tap the corresponding negative behavior tag on the homepage, **Then** their score decreases by 1 point.
3. **Given** a user has already earned 2 points today, **When** they log another positive action, **Then** their score does not increase.
4. **Given** a user wants to track a new habit, **When** they navigate to the behavior management screen and add a new behavior, **Then** it appears on the homepage as a selectable tag.
5. **Given** a user has set a reminder for every 3 hours between 7 am and 7 pm, **When** the time is 10 am, **Then** the system sends a notification to the user to log their behavior.

### Edge Cases
- Logging for past days is **not allowed**. All logs must be for the current day.
- How does the system handle a score that becomes deeply negative? Is there a visual indicator or consequence?
- When a user deletes a behavior, it is **soft-deleted** (made inactive) and no longer appears for logging. Historical data associated with that behavior remains unchanged.

## Requirements *(mandatory)*

### Functional Requirements
- **FR-001**: The system MUST allow users to log positive and negative behaviors.
- **FR-002**: The system MUST use a point system to track user progress.
- **FR-003**: Logging a positive behavior MUST increase the user's score by 1 point.
- **FR-004**: Logging a negative behavior MUST decrease the user's score by 1 point.
- **FR-005**: The system MUST limit the daily increase in score from positive behaviors to a maximum of 2 points.
- **FR-006**: There MUST be no lower limit to the score deduction from negative behaviors.
- **FR-007**: The system MUST provide a default list of positive and negative behaviors.
- **FR-008**: Users MUST be able to add, edit, and delete their own custom behaviors.
- **FR-009**: Users MUST be able to configure reminders to log their behaviors.
- **FR-010**: Reminder configuration MUST allow setting a start time, end time, and frequency (e.g., every X hours).
- **FR-011**: The homepage MUST display selectable tags for the user's configured positive and negative behaviors.
- **FR-012**: The system MUST provide a view for users to see their historical log entries and basic statistics.

### Key Entities *(include if feature involves data)*
- **User**: Represents the individual using the app. Key attribute: `Total Score`.
- **Behavior**: Represents an action the user tracks. Key attributes: `Name`, `Type` (Positive/Negative).
- **Log Entry**: Represents an instance of a user logging a behavior. Key attributes: `Timestamp`, `Behavior ID`, `Point Value`.
- **Reminder**: Represents a user-configured notification. Key attributes: `Start Time`, `End Time`, `Frequency`.

---

## Review & Acceptance Checklist
*GATE: Automated checks run during main() execution*

### Content Quality
- [ ] No implementation details (languages, frameworks, APIs)
- [ ] Focused on user value and business needs
- [ ] Written for non-technical stakeholders
- [ ] All mandatory sections completed

### Requirement Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous  
- [ ] Success criteria are measurable
- [ ] Scope is clearly bounded
- [ ] Dependencies and assumptions identified

---

## Execution Status
*Updated by main() during processing*

- [ ] User description parsed
- [ ] Key concepts extracted
- [ ] Ambiguities marked
- [ ] User scenarios defined
- [ ] Requirements generated
- [ ] Entities identified
- [ ] Review checklist passed

---
