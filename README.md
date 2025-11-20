<p align="center">
<img src="assets/img/Project_Starter_Script_blue_logo_v2.webp" alt="Project Starter Script Logo goes here" width="350">
</p>



# Project Starter Script 🚀
![Language](https://img.shields.io/badge/Language-Bash-lightgrey.svg) 
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)
![Maintained](https://img.shields.io/badge/Maintained%3F-Yep-brightgreen.svg)
/Users/userx/Downloads/Project_Starter_Script_logo.af
/Users/userx/Downloads/Project_Starter_Script_blue_logo.webp
A friendly bash script to automate the setup of new projects for GitHub. This tool creates a clean directory structure, generates standard boilerplate files, and helps you push your new project to GitHub, all from your command line.

Stop the repetitive busywork and start every new project with a consistent foundation.


### Features

### Features

* **Standard Directory Structure**: Creates a clean project layout with `src`, `docs`, and `tests` folders.
* **Smart Language Setup**: Automatically detects and configures your environment:
    * **Python**: Creates a `.venv`, upgrades pip, and adds a `requirements.txt`.
    * **Node.js**: Initializes `package.json` and creates an `.nvmrc`.
* **CI/CD Ready**: Installs a default GitHub Action (`ci.yml`) so your project is ready for automated testing immediately.
* **Git & GitHub Automation**: Initializes Git, safeguards against dirty directories, and offers to create/push the repo to GitHub.
* **Workflow Tools**: Includes a companion `start-work.sh` script for standardized branching (Feature/Bugfix/Hotfix).
* **Standard Boilerplate**: Fetches essential files (`README`, `LICENSE`, `CONTRIBUTING`, `CHANGELOG`) from a central template repository.


### Prerequisites

Before you begin, make sure you have the following tools installed on your system:

* **Bash**: Should be available on any macOS or Linux system.
* **Git**: For version control.
* **cURL**: To fetch boilerplate files from GitHub and APIs.
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

    Alternatively, you can pass the project name directly to skip the first prompt:

    ```bash
    ./start-project.sh my-new-app
    ```

The script will then guide you through the setup process, asking for the `.gitignore` preference and other details.

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

### License

This project is licensed under the Unlicense License.

For more information, please refer to [Unlicense](https://unlicense.org)