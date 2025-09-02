# Cursor Setup Guide: Memory Bank System

This guide will help you set up Cursor to use the Memory Bank system, transforming it from a stateless assistant into a persistent development partner that can effectively "remember" your project details over time.

## What is the Memory Bank?

The Memory Bank is a structured documentation system that allows Cursor to maintain context across sessions. It transforms Cursor from a stateless assistant into a persistent development partner that can effectively "remember" your project details over time.

**How it works:** The Memory Bank isn't a Cursor-specific feature - it's a methodology for managing AI context through structured documentation. When you instruct Cursor to "follow custom instructions," it reads the Memory Bank files to rebuild its understanding of your project.

## Setup Steps

### Step 1: Configure Cursor Settings

1. Open Cursor
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
3. Type "Preferences: Open User Settings (JSON)"
4. Add the following configuration to your `settings.json`:

```json
{
  "workbench.editorAssociations": {
    "*.csv": "default",
    "*.mdc": "default"
  }
}
```

This ensures that `.mdc` files (Memory Bank files) are properly recognized by Cursor.

### Step 2: Set Up User Rules

1. In Cursor, go to **Settings** → **AI** → **User Rules**
2. Copy the content from `cline-memory-bank.md` and paste it into the User Rules section
3. This makes the Memory Bank instructions available to Cursor in every session

## Key Commands

### Essential Commands

- **"follow your custom instructions"** - This tells Cline to read the Memory Bank files and continue where you left off (use this at the start of tasks)
- **"initialize memory bank"** - Use when starting a new project
- **"update memory bank"** - Triggers a full documentation review and update during a task. Use after completing a task to update memory

### Workflow Commands

- **Toggle Plan/Act modes** based on your current needs
- **"review memory bank"** - Ask Cursor to review and summarize current project state

## How User Rules Work with Memory Bank

The User Rules in Cursor serve as the "instruction manual" that tells Cursor how to use the Memory Bank system. Here's how they work together:

- **User Rules** contain the Memory Bank methodology and instructions
- **Memory Bank files** contain the actual project-specific information
- When you say "follow your custom instructions," Cursor reads the User Rules to understand how to process the Memory Bank files
- This creates a two-layer system: methodology (User Rules) + project data (Memory Bank)

## How to Use

1. Create your project folder
2. Run `"initialize memory bank"` command
3. Cursor will create the basic Memory Bank structure
4. Provide a project brief when prompted

### Daily Workflow

1. **Start each session** with: "follow your custom instructions"
2. **Work on tasks** as usual
3. **After completing tasks**, use: "update memory bank"
4. **When switching contexts**, remind Cursor to follow custom instructions

### Project Continuity

- The Memory Bank maintains context across sessions
- Cursor will remember your project architecture, decisions, and progress
- No need to re-explain project details in new sessions

## Memory Bank Structure

The system automatically creates and maintains these files:

- `projectbrief.md` - Core project requirements and goals
- `productContext.md` - Why the project exists and how it should work
- `activeContext.md` - Current work focus and recent changes
- `systemPatterns.md` - System architecture and technical decisions
- `techContext.md` - Technologies, setup, and constraints
- `progress.md` - Current status and what's left to build

## Benefits

✅ **Persistent Context** - Cursor remembers your project across sessions  
✅ **Consistent Understanding** - No need to re-explain project details  
✅ **Efficient Onboarding** - New team members can quickly understand the project  
✅ **Decision Tracking** - All technical decisions are documented and preserved  
✅ **Progress Visibility** - Clear view of what's completed and what's next

## Troubleshooting

### If Cursor doesn't remember context:

- Ensure you're using "follow your custom instructions" at the start
- Check that the Memory Bank files exist in your project
- Verify the `.mdc` file association in settings
- **Verify User Rules are set up** - Go to Settings → AI → User Rules to ensure the Memory Bank instructions are there

### If Memory Bank seems outdated:

- Use "update memory bank" command
- Review the generated files for accuracy
- Provide additional context if needed

## Example Usage

```
You: follow your custom instructions
Cursor: [Reads Memory Bank and provides project context]

You: I need to add a new API endpoint
Cursor: [Uses existing context to suggest implementation approach]

You: update memory bank
Cursor: [Updates documentation with new endpoint details]
```

## Next Steps

1. Complete the setup steps above
2. Start a new project or initialize Memory Bank for existing project
3. Begin using the key commands in your daily workflow
4. Experience the power of persistent AI context!

---

**Note:** The Memory Bank system works best when you consistently use the key commands and keep the documentation updated. The more you use it, the more effective it becomes at maintaining project continuity.

# Cline Modes: Plan and Act

## Plan Mode

- **Cline only observes and plans**, it is not allowed to edit or create any files.
- Cline will read the entire codebase to understand the context, identify your requirements, and propose an execution strategy
- The goal is to discuss, identify potential issues, and create a detailed plan before execution.

### When to Use

- When starting a new feature, fixing a complex bug, or refactoring the system.
- When you need to ensure clear scope and avoid mistakes before coding.

---

## Act Mode

- Once the plan is clear and approved, you switch to Act Mode. At this point, **Cline is allowed to execute the plan**: edit code, create files, add commits, etc.
- Cline will remember and apply exactly the agreed strategy from Plan Mode.

### When to Use

- When the plan is finalized and you want Cline to start implementing it.
- When you need Cline to begin execution immediately and efficiently.
