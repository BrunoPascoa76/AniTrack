# Changelog

## [V20241113.1] - 2024-11-13

### Added

* Object classes modeled
* Fetches user from anilist and saves it in internal state
* Added a screen to add clientId (should get someone to test it someday)
* Watchlists are fetched and displayed

## [V20241113.3] - 2024-11-13

### Fixed

* Number of episodes now display correctly (needed some parenthesis)
* Added prevention for if the user has marked unreleased episodes as seen

## [V20241113.4] - 2024-11-13

### Fixed

* Fixed weird bug when doing fresh start of app

## [V20241121.1] - 2024-11-21

### Added

* Added media profile
* Added calendar
* Allow users to filter by watched on calendar

### Unconfirmed bugs

* Sometimes the app hit the rate limit for no reason. This should be solved by lazy loading query widgets but due to the unpredicatble nature of the bug, it's hard to be sure
