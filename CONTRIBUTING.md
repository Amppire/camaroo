# Contributing to Camaroo

Thank you for your interest in contributing to Camaroo! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/camaroo.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes thoroughly
6. Commit with descriptive messages
7. Push to your fork
8. Create a Pull Request

## Development Setup

1. Install Flutter SDK (>=3.0.0)
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Code Standards

### Dart/Flutter Style
- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` to check for issues
- Format code with `dart format .`

### Code Organization
- Keep files small and focused
- Use meaningful names for variables and functions
- Add comments for complex logic
- Follow the existing project structure

### Commit Messages
- Use clear, descriptive commit messages
- Start with a verb (Add, Update, Fix, Remove)
- Keep the first line under 50 characters
- Add detailed description if needed

Example:
```
Add face detection feature to portrait mode

- Implement ML Kit face detection
- Add UI indicators for detected faces
- Update camera preview overlay
```

## Pull Request Process

1. **Update Documentation**: If you add features, update the README
2. **Add Tests**: Include tests for new functionality
3. **Check Linting**: Run `flutter analyze` before submitting
4. **Test on Both Platforms**: Test on both Android and iOS if possible
5. **Describe Changes**: Provide a clear description in your PR

## Reporting Issues

### Bug Reports
When reporting bugs, include:
- Device and OS version
- Flutter version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

### Feature Requests
For feature requests, describe:
- The problem you're trying to solve
- Your proposed solution
- Any alternatives you've considered
- Additional context or examples

## Code Review Process

- Maintainers will review PRs as time permits
- Address feedback and requested changes
- PRs may be merged, closed, or require revisions
- Be patient and respectful during the review process

## Areas for Contribution

We welcome contributions in these areas:

### Features
- New camera modes (timelapse, burst, HDR)
- Advanced editing tools
- AI/ML improvements
- Performance optimizations

### Bug Fixes
- UI/UX improvements
- Platform-specific issues
- Memory leaks
- Crash fixes

### Documentation
- Code documentation
- User guides
- API documentation
- Tutorial videos

### Testing
- Unit tests
- Integration tests
- UI tests
- Performance tests

## Community Guidelines

- Be respectful and inclusive
- Help others when you can
- Accept constructive criticism
- Focus on what's best for the project
- Follow the [Code of Conduct](CODE_OF_CONDUCT.md)

## Questions?

If you have questions about contributing:
- Open a [Discussion](https://github.com/harisrovca/camaroo/discussions)
- Join our community chat
- Email the maintainers

Thank you for contributing to Camaroo! 🎉
