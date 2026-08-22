# Release — App Store Connect and TestFlight

The iOS build is signed and uploaded from a laptop, not from CI. There is no
Fastlane and no CocoaPods in this project: plugins link through Swift Package
Manager, so `ios/` has a `Package.swift` under `Flutter/ephemeral/` and no
`Podfile` at all. Anything you read elsewhere about `pod install` does not apply
here.

## Identity

| | |
| --- | --- |
| Bundle ID | `com.taknikiyaat.adhkar` |
| Team ID | `W4AV7ZYYPV` |
| App Store name | Adhkar - to stay connected |
| Home screen name | Sakinah (`CFBundleDisplayName`) |
| Deployment target | iOS 13.0 |

The bundle ID was the Flutter scaffold default (`com.taknikiyaat.adhkarAppFlutter`)
until the first upload was prepared. It was changed while it was still free to
change: a bundle ID is permanent once a build reaches App Store Connect.

**The two names differ on purpose and it is a review risk.** The store listing
says Adhkar; the icon on the home screen says Sakinah. Guideline 2.3.7 is about
exactly this mismatch, so App Review Information carries a note explaining it.
If a rejection ever cites 2.3.7, that note is the thing to point at — not a
reason to rename either half.

## Credentials

An App Store Connect **Team Key** with the **Admin** role. Admin is not
optional: App Manager cannot create signing certificates, so a lower role gets
all the way to the archive and fails there.

```
~/.appstoreconnect/private_keys/AuthKey_<KEY_ID>.p8   mode 600
```

That path is where `xcodebuild` and `xcrun altool` look without being told, which
is why the key lives there rather than beside the project.

| | |
| --- | --- |
| Key ID | `3S47965Y9P` |
| Issuer ID | see App Store Connect → Users and Access → Integrations |

**The `.p8` is not in git and must never be.** Git history outlives rotation: a
key committed once stays recoverable from the history after it has been revoked
and replaced, and a private repo is one collaborator away from being a wider
audience than intended. The two identifiers above are recorded here because they
are useless without the file. Apple serves the `.p8` exactly once at generation
time, so the copy on disk is the only copy — if it is lost, the key is revoked
and regenerated, not recovered.

## The encryption key that would otherwise stall every build

`ios/Runner/Info.plist` carries:

```xml
<key>ITSAppUsesNonExemptEncryption</key>
<false/>
```

Without it every uploaded build lands in TestFlight as **Missing Compliance** and
cannot be distributed until someone answers the question by hand, once per build.
`false` is the honest answer and not a shortcut: the app makes no network request
at all (there is no `http` dependency — see the `client` skill), so there is no
encryption to declare. **If the update, sync, sign-in or audio features from PRD
X2.2 are ever built, this answer has to be revisited** — HTTPS alone still
qualifies for the exemption, but the declaration stops being trivially true.

## Building and uploading

```bash
~/flutter/bin/flutter build ipa --export-options-plist=ios/ExportOptions.plist
```

```bash
xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios \
  --apiKey 3S47965Y9P --apiIssuer <ISSUER_ID>
```

`ExportOptions.plist` uses `method: app-store-connect` and automatic signing.
With `-allowProvisioningUpdates`, `xcodebuild` will create the distribution
certificate and the App Store provisioning profile itself the first time, which
is the reason the key needs Admin.

Bump `version:` in `pubspec.yaml` before every upload. The part after `+` is the
build number and **App Store Connect rejects a build number it has already seen**,
permanently — a rejected upload still burns the number.

## Privacy

Nothing to declare: the app collects no data and has no analytics, no crash
reporter and no network. The App Privacy questionnaire is answered "no data
collected" throughout.

Privacy manifests ship from two places already and neither is ours to maintain:
`Flutter.framework/PrivacyInfo.xcprivacy` from the engine, and one inside
`shared_preferences_foundation`'s resource bundle. The Runner target declares no
manifest of its own because its own code uses no required-reason API — the
`UserDefaults` access all happens inside the plugin.

## TestFlight

**Internal testing** takes up to 100 members of the team, needs no review, and a
build is usually available a few minutes after processing finishes.

**External testing** is a different thing: it needs a Beta App Review pass and
the App Privacy questionnaire completed first. Budget a day for the first one.
