# Contributing to Dart Board

Thank you for your interest in contributing to Dart Board! This document outlines the process for contributing to the project and provides guidelines to ensure a smooth collaboration experience.

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) to maintain a respectful and inclusive community.

## Getting Started

1. **Set up your development environment**:
   ```bash
   # Clone the repository
   git clone https://github.com/ahammer/dart_board.git
   cd dart_board
   
   # Install Melos (required for monorepo management)
   flutter pub global activate melos
   
   # Bootstrap the project
   melos bootstrap
   ```

2. **Familiarize yourself with the project structure**:
   - `core/` - Core framework components
   - `features/` - Reusable feature modules
   - `templates/` - UI templates
   - `integrations/` - Example applications

## Development Workflow

### 1. Create a Branch

Create a new branch for your work:
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-you-are-fixing
```

Use appropriate prefixes like `feature/`, `fix/`, `docs/`, etc.

### 2. Make Your Changes

When developing new features or fixing bugs:

- Follow existing code style and patterns
- Add appropriate tests for your changes
- Update documentation as needed
- Keep commits focused and related to a single change

### 3. Use Conventional Commits

Dart Board uses the [Conventional Commits](https://www.conventionalcommits.org/) standard for commit messages:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

Types include:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or updating tests
- `chore`: Changes to the build process or tools

Examples:
```
feat(locator): add support for factory registration
fix(firebase): correct authentication flow
docs(readme): update installation instructions
```

### 4. Test Your Changes

Run tests to ensure your changes don't break existing functionality:

```bash
# Run tests for all packages
melos test

# Run analyzer for all packages
melos analyze
```

### 5. Create a Pull Request

1. Push your branch to GitHub:
   ```bash
   git push -u origin your-branch-name
   ```

2. Create a pull request on GitHub with a clear description of:
   - What the PR changes
   - Why the change is needed
   - How it has been tested
   - Any related issues

3. Request review from a maintainer

## Adding a New Feature Package

If you're creating a new feature package for Dart Board:

1. Follow the standard Flutter package structure
2. Create a `.gitignore` file with appropriate settings
3. Add a comprehensive README.md explaining the feature
4. Include a CHANGELOG.md file
5. Ensure your pubspec.yaml includes appropriate Dart Board dependencies
6. Add appropriate tests
7. Include example code demonstrating usage

Example package structure:
```
features/dart_board_your_feature/
  ├── lib/
  │   ├── dart_board_your_feature.dart
  │   └── src/
  │       ├── your_feature.dart
  │       └── ...
  ├── test/
  │   └── your_feature_test.dart
  ├── example/
  │   └── main.dart
  ├── pubspec.yaml
  ├── README.md
  ├── CHANGELOG.md
  └── .gitignore
```

## Documentation Guidelines

Good documentation is crucial for Dart Board. When contributing, please:

1. Document all public APIs with meaningful comments
2. Update README.md files when changing functionality
3. Provide clear examples that demonstrate usage
4. Keep documentation up-to-date with code changes

## Using Melos

Dart Board uses [Melos](https://github.com/invertase/melos) to manage the monorepo. Common commands:

```bash
# Bootstrap all packages
melos bootstrap

# Clean all packages
melos clean

# Run tests across all packages
melos test

# Run analysis across all packages
melos analyze

# Run a custom script defined in melos.yaml
melos run script_name
```

## Versioning and Publishing

Dart Board follows [Semantic Versioning](https://semver.org/). Package releases are managed by maintainers and published to pub.dev.

## Getting Help

If you need help or have questions:

1. Open a [GitHub Discussion](https://github.com/ahammer/dart_board/discussions)
2. Check existing [Issues](https://github.com/ahammer/dart_board/issues)
3. Reach out on [Twitter](https://twitter.com/adamhammer) (Adam Hammer, maintainer)

## Thank You

Your contributions help make Dart Board better for everyone. We appreciate your time and effort!
