# NemID Keycard App

Tool for managing multiple 2-factor code sheets for the NemID service.


## Purpose

Managing code sheets and looking up a code when testing systems with multiple users or where you reset often is a hassle.

This tool allows you to select an identity, either by name or by code sheet identifier, and then enter the requested code. It then filters until it shows the one to enter.


## Creating code sheets

To create code sheets, you need access to https://appletk.danid.dk/developers/. This access is gated by IP whitelisting.

The code sheets created there can only be used on systems configured to interact with the non-production version of NemID.


## Added code sheets to the tool


## Saving and restoring data

Data is handled through the DocumentPicker APIs on Apple platforms. This means that the app is not responsible for storing data, instead relying on external locations.

This can be either device-only or through a provider such as iCloud, Google Drive, Dropbox, or any of their competitors.
