# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Add Password reset email subject to Securial configuration
- Add the SecurialMailer sender email address to Securial configuration
- Add `Securial::RegexHelper`
- Add `Securial::RouteInspector` helper with methods to print out the Engine routes.
- Add reset password token expiration
- Include the `Securial::Identity` in the application controller by default

### Changed

- Refactor password reset functionality to use SecurialMailer and update related tests
- Use ERB for templates to pass codeQL
- Refactor and extract Normalizing helpers
- Renamed `Securial::JwtHelper` to `Securial::AuthHelper`

### Security

- The fields `reset_password_token` and `reset_password_token_created_at` are now filtered params

### Fixed

- Allow rails internal routes (e.g /rails/info, /rails/mailers, etc.) without authentication
- destination root of the initializer in tests was invalid.

## [0.3.1] - 2025-05-20 - https://github.com/AlyBadawy/Securial/compare/v0.3.0...v0.3.1

### Added

- Log when the engine is mounted and started

### Changed

- Initial config to enable logging
- Structure of runtime and development dependencies

---

## [0.3.0] - 2025-05-20

### Added

- First public release of `Securial`.
- Provides authentication scaffolding as a Rails API-only engine.
- Includes Jbuilder views for scaffolding.
- Configuration system for customizing authentication behavior.
- Session management with automatic expiration.
- JWT token generation and validation.
- Email templates for authentication notifications.

### Security

- Secure session storage with encryption.
- Rate limiting for authentication attempts.
- Configurable password hashing options.

### Changed

- Optimized database queries for session lookups.
- Improved error messages and logging.

### Fixed

- Session cleanup for expired tokens.
- Token validation edge cases.

---

## [0.2.0] - 2025-05-15 (Yanked!)

### Added

- Basic authentication controllers.
- Session model implementation.
- JWT helper methods.
- Initial configuration system.

### Changed

- Refactored token generation process.
- Updated gem dependencies.

---

## [0.1.0] - 2025-05-11 (Yanked!)

### Added

- Initial project structure.
- Basic Rails engine setup.
- Core authentication functionality.

---

Unreleased: https://github.com/AlyBadawy/Securial/compare/v0.3.1...main \
v0.3.1: https://github.com/AlyBadawy/Securial/compare/v0.3.0...v0.3.1
