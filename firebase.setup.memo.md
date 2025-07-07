```sh
➜  completely-understood-vol61 git:(refactor/firebase) firebase init

     ######## #### ########  ######## ########     ###     ######  ########
     ##        ##  ##     ## ##       ##     ##  ##   ##  ##       ##
     ######    ##  ########  ######   ########  #########  ######  ######
     ##        ##  ##    ##  ##       ##     ## ##     ##       ## ##
     ##       #### ##     ## ######## ########  ##     ##  ######  ########

You're about to initialize a Firebase project in this directory:

  /Users/akihiko.kigure/work/completely-understood-vol61

? Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices.
 ◯ Genkit: Setup a new Genkit project with Firebase
 ◉ Functions: Configure a Cloud Functions directory and its files
 ◯ App Hosting: Enable web app deployments with App Hosting
❯◉ Hosting: Configure files for Firebase Hosting and (optionally) set up GitHub Action deploys
 ◯ Storage: Configure a security rules file for Cloud Storage
 ◉ Emulators: Set up local emulators for Firebase products
 ◯ Remote Config: Configure a template file for Remote Config

```

---

```sh
✔ Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices. Functions: Configure a Cloud Functions directory and its files, Hosting: Configure files for Firebase
Hosting and (optionally) set up GitHub Action deploys, Emulators: Set up local emulators for Firebase products

=== Project Setup

First, let's associate this project directory with a Firebase project.
You can create multiple project aliases by running firebase use --add,
but for now we'll just set up a default project.

? Please select an option: (Use arrow keys)
❯ Use an existing project
  Create a new project
  Add Firebase to an existing Google Cloud Platform project
  Don't set up a default project

```

---

```sh
✔ Please select an option: Use an existing project
? Select a default Firebase project for this directory: (Use arrow keys)
❯ completely-understood-vo-a0f23 (completely-understood-vol61)
  lifewood-d627c (lifewood)
```

---

```sh
=== Functions Setup
Let's create a new codebase for your functions.
A directory corresponding to the codebase will be created in your project
with sample code pre-configured.

See https://firebase.google.com/docs/functions/organize-functions for
more information on organizing your functions using codebases.

Functions can be deployed with firebase deploy.

? What language would you like to use to write Cloud Functions?
  JavaScript
❯ TypeScript
  Python

```

---

```sh
Functions can be deployed with firebase deploy.

✔ What language would you like to use to write Cloud Functions? TypeScript
✔ Do you want to use ESLint to catch probable bugs and enforce style? Yes
✔  Wrote functions/package.json
✔  Wrote functions/.eslintrc.js
✔  Wrote functions/tsconfig.dev.json
✔  Wrote functions/tsconfig.json
✔  Wrote functions/src/index.ts
✔  Wrote functions/.gitignore
✔ Do you want to install dependencies with npm now? Yes
⠼
```

---

```sh
=== Hosting Setup

Your public directory is the folder (relative to your project directory) that
will contain Hosting assets to be uploaded with firebase deploy. If you
have a build process for your assets, use your build's output directory.

✔ What do you want to use as your public directory? dist/apps/frontend/browser
✔ Configure as a single-page app (rewrite all urls to /index.html)? No
✔ Set up automatic builds and deploys with GitHub? No
✔  Wrote dist/apps/frontend/browser/404.html
✔ File dist/apps/frontend/browser/index.html already exists. Overwrite? No
i  Skipping write of dist/apps/frontend/browser/index.html
```

---

```sh
=== Emulators Setup
? Which Firebase emulators do you want to set up? Press Space to select emulators, then Enter to confirm your choices.
 ◯ Authentication Emulator
 ◉ Functions Emulator
 ◯ Firestore Emulator
❯◯ Database Emulator
 ◉ Hosting Emulator
 ◯ Pub/Sub Emulator
 ◯ Storage Emulator

```

---

```sh
=== Emulators Setup
✔ Which Firebase emulators do you want to set up? Press Space to select emulators, then Enter to confirm your choices. Functions Emulator, Hosting Emulator
✔ Which port do you want to use for the functions emulator? 5001
✔ Which port do you want to use for the hosting emulator? 5000
✔ Would you like to enable the Emulator UI? Yes
✔ Which port do you want to use for the Emulator UI (leave empty to use any available port)?
✔ Would you like to download the emulators now? Yes

✔  Wrote configuration info to firebase.json
✔  Wrote project information to .firebaserc

✔  Firebase initialization complete!
```

---

firebase emulators:start
