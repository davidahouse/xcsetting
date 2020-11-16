# xcsetting

This command line tool can parse a specific Xcode build setting for a project and return it on stdout.
This can be used in a build system for accessing a build setting such as a version number.

## Usage

Supply either a project:

```
xcsetting --project <project> --scheme <scheme> <setting>
```

Or a workspace:

```
xcsetting --workspace <workspace> --scheme <scheme> <setting>
```

<p align="center"><img src="/sample.gif?raw=true"/></p>

## Installation

Use the [Mint](https://github.com/yonaskolb/Mint) package manager to install `xcsetting`:

```
$ mint install davidahouse/xcsetting
```
