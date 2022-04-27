# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com//), and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased] - TBD

- Update build matrix for ActiveSupport 7 support (#215)

## [0.11.0] - 2021-11-22

- Adds Ruby 3.1 support (#212)
- Adds `BusinessTime::Config.with` docs to README (#184)

## [0.10.0] - 2021-02-23

- Fixes documentation typo (#177)
- Improves the business day calculation for non-business days (#179)
- Fixes warnings (#202)
- Adds Ruby 3.0 support; Improves build matrix (#203)

## [0.9.3] - 2017-11-04

- Fixes an issue with 0.business_<x> calculations (#165)
- Added est for business_days.before edge case (#166)
- Added feature for 'stacking' local configs (#172)

## [0.9.2] - 2017-06-07

- Adds support for negative numbers for days (#158)
- Remove Gemfile.lock from project (#161)
- Restores ActiveSupport 3 (#163)

## [0.9.1] - 2017-04-04

- Fixes regression on Rails 5.0 (#155)

## [0.9.0] - 2017-04-02

- performance improvements on hour date calculations (#143)
- new feature - Fiscal date methods. (#144)

## [0.8.0] - 2017-04-01

- Ruby 2.4 compatibility 4/1/2017 (yes, this is the same as 0.9.0)
  I released the 2.4 upgrade separately than the other new features
  so that people have an upgrade path to 2.4 without mixing in new
  features.
- Forces a particular date format for Regex
- A small change to include the version number in the project itself.

## [0.7.6] - 2016-06-09

- Fixed a defect where timezone was not preserved when dealing with
  beginning_or_workday and end_of_workday. Thanks bazzargh.

## [0.7.5] - 2016-04-05

No documentation yet, contributions welcome.

## [0.7.4] - 2015-04-12

No documentation yet, contributions welcome.

## [0.7.3] - 2014-06-10

No documentation yet, contributions welcome.

## [0.7.2] - 2014-03-26

No documentation yet, contributions welcome.

## [0.7.1] - 2014-02-07

- fixing a multithreaded issue, upgrading some dependencies, loosening the
  dependency on TZInfo

## [0.7.0] - 2014-01-27

- major maintenance upgrade on the process of constructing the gem, testing
  the gem, and updating dependencies. the api has not changed.

## [0.6.2] - 2013-08-12

- rchady pointed out that issue #14 didn't appear to be released.  This fixes
  that, as well as confirms that all tests run as expected on Ruby 2.0.0p195

## [0.6.1] - 2012-04-12

No documentation yet, contributions welcome.

## [0.4.0] - 2012-01-25

No documentation yet, contributions welcome.

## [0.3.1] - 2010-12-22

No documentation yet, contributions welcome.

## [0.3.0] - 2010-05-30

No documentation yet, contributions welcome.

## [0.2.2] - 2010-04-25

No documentation yet, contributions welcome.

## [0.2.1] - 2010-04-22

No documentation yet, contributions welcome.

## [0.2.0] - 2010-04-16

No documentation yet, contributions welcome.

[Unreleased]: https://github.com/bokmann/business_time/compare/v0.11.0..HEAD
[0.11.0]: https://github.com/bokmann/business_time/compare/v0.10.0..v0.11.0
[0.10.0]: https://github.com/bokmann/business_time/compare/v0.9.3..v0.10.0
[0.9.3]: https://github.com/bokmann/business_time/compare/v0.9.2..v0.9.3
[0.9.2]: https://github.com/bokmann/business_time/compare/v0.9.1..v0.9.2
[0.9.1]: https://github.com/bokmann/business_time/compare/v0.9.0..v0.9.1
[0.9.0]: https://github.com/bokmann/business_time/compare/v0.8.0..v0.9.0
[0.8.0]: https://github.com/bokmann/business_time/compare/v0.7.6..v0.8.0
[0.7.6]: https://github.com/bokmann/business_time/compare/v0.7.5..v0.7.6
[0.7.5]: https://github.com/bokmann/business_time/compare/v0.7.4..v0.7.5
[0.7.4]: https://github.com/bokmann/business_time/compare/v0.7.3..v0.7.4
[0.7.3]: https://github.com/bokmann/business_time/compare/v0.7.2..v0.7.3
[0.7.2]: https://github.com/bokmann/business_time/compare/v0.7.1..v0.7.2
[0.7.1]: https://github.com/bokmann/business_time/compare/v0.7.0..v0.7.1
[0.7.0]: https://github.com/bokmann/business_time/compare/v0.6.2..v0.7.0
[0.6.2]: https://github.com/bokmann/business_time/compare/v0.6.1..v0.6.2
[0.6.1]: https://github.com/bokmann/business_time/compare/v0.4.0..v0.6.1
[0.4.0]: https://github.com/bokmann/business_time/compare/v0.3.1..v0.4.0
[0.3.1]: https://github.com/bokmann/business_time/compare/v0.3.0..v0.3.1
[0.3.0]: https://github.com/bokmann/business_time/compare/v0.2.2..v0.3.0
[0.2.2]: https://github.com/bokmann/business_time/compare/v0.2.1..v0.2.2
[0.2.1]: https://github.com/bokmann/business_time/compare/v0.2.0..v0.2.1
[0.2.0]: https://github.com/bokmann/business_time/compare/c71a80f..v0.2.0
