# Manago

Manago is a project management application built with Ruby on Rails, featuring a modern UI with Tailwind CSS, Hotwire (Turbo and Stimulus), and Alpine.js. It helps users organize projects, track tasks, and collaborate effectively.

The application is built with a minimal amount of custom JavaScript code. Dynamic interactivity is achieved primarily through Hotwire and Alpine.js, making the frontend lean and maintainable. Keep in mind that this is only a Minimum Viable Product (MVP) for a small-scale project management solution.

## Features

-   **User Authentication**: Secure login and registration with user roles (regular users and admins)
-   **Project Management**:
    -   Create, edit, and manage projects
    -   Track project status (draft, in progress, completed, archived)
    -   Visual progress tracking with timeline bars
    -   Project archiving for completed work
    -   Detailed project statistics and analytics
-   **Task Management**:
    -   Create and assign tasks within projects
    -   Track task status and priority
    -   Interactive checklists for task items
    -   Due date tracking with overdue indicators
-   **Comments and Collaboration**:
    -   Add comments to tasks
    -   Real-time updates using Hotwire
-   **User Profiles**: Personalized user dashboards with activity summaries

## Technology Stack

-   **Backend**: Ruby on Rails 8
-   **Database**: PostgreSQL
-   **Frontend**:
    -   Tailwind CSS for styling
    -   Hotwire (Turbo and Stimulus) for dynamic interactions
    -   Alpine.js for lightweight interactivity
    -   Pines components for UI elements
    -   Chart.js for data visualization
-   **Authentication**: Devise
-   **Authorization**: Pundit

## Installation

### Prerequisites

-   Ruby 3.2.x
-   Rails 8.0.x
-   PostgreSQL
-   Node.js and Bun

### Setup Instructions

1. **Clone the repository**

    ```bash
    git clone https://github.com/yourusername/manago.git
    cd manago
    ```

2. **Install dependencies**

    ```bash
    bundle install
    bun install
    ```

3. **Configure the database**

    Update `config/database.yml` with your PostgreSQL credentials if needed.

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed  # Optional: loads sample data
    ```

4. **Start the server**

    ```bash
    bin/dev
    ```

    The application will be available at `http://localhost:3000`

## Usage

1. **Registration and Login**

    - Create a new account or login with existing credentials

2. **Creating Projects**

    - Click "New Project" on the dashboard
    - Fill in project details including title, description, dates, and status

3. **Managing Tasks**

    - From a project, click "Add Task"
    - Set task properties, due dates, and priority
    - Use checklists to break down tasks further

4. **Project Workflow**
    - Projects start as "Draft" or "In Progress"
    - Mark projects as "Completed" when all tasks are done
    - Archive completed projects to store them for reference

## Development

### Key Directories

-   `app/models`: Database models and business logic
-   `app/controllers`: Request handling
-   `app/views`: UI templates
-   `app/policies`: Authorization rules
-   `app/javascript`: Frontend JavaScript

### Testing

Run the test suite with:

```bash
rails test
```

## License

This project is licensed under the MIT License.

---
