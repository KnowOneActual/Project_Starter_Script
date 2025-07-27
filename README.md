# Project Starter Script 🚀

![Language](https://img.shields.io/badge/Language-Bash-lightgrey.svg) 
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-Yes-brightgreen.svg)

A friendly and powerful bash script to automate the setup of new software projects. This tool creates a clean directory structure, generates standard boilerplate files, and helps you push your new project to GitHub, all from your command line.

Stop the repetitive busywork and start every new project with a consistent, professional foundation.


### Features

* **Standard Directory Structure**: Creates a clean project layout with `src`, `docs`, and `tests` folders.
* **Git Initialization**: Automatically initializes a Git repository and sets the default branch to `main`.
* **Boilerplate Files**: Generates essential files, including:
    * A `README.md` with your project title.
    * A `LICENSE` file with the MIT License.
    * A `.gitignore` file tailored to your chosen language (via Toptal's gitignore.io), with support for a custom boilerplate file.
    * An `.editorconfig` for consistent coding styles.
* **Workflow Automation**: Automatically downloads a companion `start-work.sh` script to help manage your Git branching workflow.
* **Language-Specific Setup**: Provides extra setup for common languages:
    * **Python**: Creates a `venv` virtual environment.
    * **Node.js**: Initializes a `package.json` file.
* **GPG Signing**: Prompts to sign the initial commit with your GPG key for added security.
* **GitHub Integration**: Guides you through pushing your new project to GitHub, with optional support for the GitHub CLI (`gh`).


### Prerequisites

Before you begin, make sure you have the following tools installed on your system:

* **Bash**: Should be available on any macOS or Linux system.
* **Git**: For version control.
* **cURL**: To fetch the `.gitignore` file from the API.
* **GPG** (Optional): If you want to sign your commits.
* **GitHub CLI (gh)** (Optional): For the automated repository creation feature. To use this feature, you only need to run `gh auth login` one time to authenticate.

```bash
gh auth login
````

### How to Use

1.  **Download the Script**
    Save the script to a convenient location on your computer. For example, you can save it as `start-project.sh` in your home directory or a dedicated `~/scripts` folder.
2.  **Make it Executable**
    Open your terminal and run the following command to give the script permission to execute:
    ```bash
    chmod +x start-project.sh
    ```
3.  **Run the Script**
    Whenever you want to start a new project, just run the script from your terminal:
    ```bash
    ./start-project.sh
    ```

The script will then guide you through the setup process, asking for the project name, primary language, and other preferences.

### Using the `start-work.sh` Script

The `start-project.sh` script automatically includes a handy `start-work.sh` script (from the [start-work-script repository](https://github.com/KnowOneActual/start-work-script)) in your new project's root directory. This tool helps you quickly start a new task by automating the Git branching process.

1.  **Make it Executable** (This is done automatically by the main script)
    ```bash
    chmod +x start-work.sh
    ```
2.  **Run it**
    When you're ready to start a new feature or fix, run the script from your project's root directory:
    ```bash
    ./start-work.sh
    ```

It will ask for a branch name, sync your `main` branch with the remote, and then create and switch to the new feature branch for you.

## **License**

This project is licensed under the Unlicense License.

For more information, please refer to [Unlicense](https://unlicense.org)

