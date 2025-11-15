# App-Changelog

> A Go-based CLI tool and Git hook to interactively create commit messages following the Conventional Commits specification.

## About the Project

This project provides a command-line interface (CLI) application designed to streamline the process of writing commit messages that adhere to the Conventional Commits standard. It integrates seamlessly with your Git workflow using a `prepare-commit-msg` hook.

When you run `git commit`, this tool intercepts the process, allowing you to enhance your initial message or build a new one from scratch through an interactive form. The tool is configurable, allowing you to define your own commit types and scopes via a TOML file.

## Tech Stack

The main technologies and libraries used in this project are:

*   [Go](https://go.dev/)
*   [Bubble Tea](https://github.com/charmbracelet/bubbletea)
*   [TOML](https://github.com/BurntSushi/toml)
*   [Make](https://www.gnu.org/software/make/)

## Usage

Below are the instructions for you to set up and run the project locally.

### Prerequisites

You need to have the following software installed to run this project:

*   [Go](https://go.dev/doc/install) (v1.18 or higher)
*   [Make](https://www.gnu.org/software/make/)

### Installation and Setup

Follow the steps below:

1.  **Clone the repository**
    ```bash
    git clone https://github.com/luizvilasboas/commit-hooks.git
    ```

2.  **Navigate to the project directory**
    ```bash
    cd commit-hooks
    ```

3.  **Install dependencies**
    ```bash
    go mod tidy
    ```

4.  **Install the Git hook**
    You have two options for installation:
    *   **Local Installation (for this repository only)**
        This command will install the hook in the current project's `.git/hooks` directory.
        ```bash
        make install
        ```
    *   **Global Installation (for all your repositories)**
        This command installs the commit-hooks binary to `~/.local/bin` and configures Git to use it globally.
        ```bash
        make install-global
        ```
    **Important**: Ensure the installation directory (`~/.local/bin` by default) is in your shell's `$PATH`.

### Configuration

You can customize the available commit types and scopes by creating a `conventional_commits.toml` file in one of two locations:

1.  `./data/conventional_commits.toml` (Project-specific)
2.  `~/.commit_hooks/conventional_commits.toml` (Global fallback)

The file should follow this format:
```toml
# Example conventional\_commits.toml
types = ["feat", "fix", "docs", "style", "refactor", "test", "chore"]
scopes = ["api", "ui", "db", "auth", "deps"]
```

### Workflow

1.  Make your changes and stage them with `git add`.
2.  Run the commit command with a brief initial message:
    ```bash
    git commit -m "add user login feature"
    ```
3.  The interactive helper will launch automatically.
4.  Follow the prompts to select a type, scope(s), and refine the commit message details.
5.  Confirm your choices to finalize the structured commit message.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

Don't forget to give the project a star! Thanks again!

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
